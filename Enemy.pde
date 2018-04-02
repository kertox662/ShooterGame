class Enemy {
    float x; //Coordinates
    float y;
    int xspeed; //Speeds in directions
    int yspeed;

    int xWidth; //Dimensions
    int yHeight;

    int xdirection; //Initial directions
    int ydirection = 1;

    int xPadding = 20; //Padding so enemy doesn't completely escape screen
    int yPadding = 20; //To be put in constructor to allow negative values for offscreen enemies

    int life = 255; //Life and color based on life
    color c = color(0 , 255, 0);

    int hitFrames = 0; //Frames to run hit animation
    
    PImage sprite;

    Enemy(float x, float y, int hspeed, int vspeed, String spriteFile, int xdirection) { //Constructor
        this.x = x;
        this.y = y;
        xspeed = hspeed;
        yspeed = vspeed;
        sprite = loadImage(spriteFile);
        this.xdirection = xdirection;
    }


    boolean isOnxPadding() { //Checks if enemy is on x padding
        if (x < xPadding || x > width - xPadding) {
            return true;
        } 
        return false;
    }

    void move() {//Temporary movement to test collision with lasers
        if (isOnxPadding()) {
            xdirection *= -1;
        }
        x += xspeed*xdirection;
        y += yspeed*ydirection;
    }

    void display() { //Draws the enemy
        imageMode(CENTER);
        tint(c);
        image(sprite, x, y);
        if (hitFrames > 0) {
            c = color(150,50, 50);
            hitFrames --;
        } else {
            c = color(life);
        }
    }

    boolean isColliding(Laser other) { //Checks if colliding with laser object
        if (other.x > x - sprite.width/2 && other.x < x + sprite.width/2) {
            if (other.y > y - sprite.height/2 && other.y < y + sprite.height/2) {
                return true;
            }
        }
        return false;
    }

    void checkCollisions(LaserSystem ls) { //Checks collision with all laser objects in a laser system
        for (int i = ls.lasersystem.size()-1; i >= 0; i--) {
            Laser l = ls.lasersystem.get(i);
            if (isColliding(l)) {
                life -= 15;
                hitFrames = 10;
                ls.lasersystem.remove(i);
                p.score += 100;
            }
        }
    }
}
