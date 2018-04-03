//Misha Melnyk
//The class for enemy objects
class Enemy {
    float x; //Coordinates
    float y;
    float xspeed; //Speeds in directions
    float yspeed;

    int xdirection; //Initial directions (not really needed anymore, basically always put 1)
    int ydirection = 1;

    int xPadding = 20; //Padding so enemy doesn't completely escape screen once it enters
    int yPadding = 20; 
    boolean inPadding = false; //Used so that padding doesn't reflect the enemy back out the first time it comes from offscreen

    int life; //Life and color based on life
    int initlife;
    color c = color(0, 255, 0);

    int hitFrames = 0; //Frames to run hit animation

    PImage sprite;

    float lastxDirChange = frameRate * -1;
    float lastyDirChange = frameRate * -1;

    int scoreVal;//How much score the enemy will give

    PApplet main; //Used to initiate sound files
    SoundFile enemyHit; //Sound file

    Enemy(float x, float y, float hspeed, float vspeed, String spriteFile, int xdirection, int life, int score, PApplet main) { //Constructor
        this.x = x;
        this.y = y;
        xspeed = hspeed;
        yspeed = vspeed;
        sprite = loadImage(spriteFile);
        this.xdirection = xdirection;
        this.life = life;
        initlife = life;
        scoreVal = score;
        this.main = main;
        enemyHit = new SoundFile(main, "Sounds/EnemyKill.wav");
    }


    boolean isOnxPadding() { //Checks if enemy is on x padding
        if (x < xPadding || x > width - xPadding) {
            return true;
        } 
        return false;
    }

    boolean isOnyPadding() { //Checks if enemy is on y padding
        if (y < yPadding || y > height - yPadding) {
            return true;
        } 
        return false;
    }
    void move() {//Movement and check for edge collision

        x += xspeed*xdirection;
        y += yspeed*ydirection;

        if (isOnxPadding()) {
            if (frameCount - lastxDirChange > 10 && inPadding) {
                xdirection *= -1;
                lastxDirChange = frameCount;
            }
            if (yspeed == 0 && inPadding) {
                y += sprite.height * ydirection;
            }
        }
        if (isOnyPadding()) {
            if (frameCount - lastyDirChange > 10 && inPadding) {
                ydirection *= -1;
                lastyDirChange = frameCount;
            } 
            if (xspeed == 0 && inPadding) {
                x += sprite.width * xdirection;
            }
        }
    }

    void display() { //Draws the enemy
        imageMode(CENTER);

        if (hitFrames > 0) {
            c = color(150, 50, 50);
            hitFrames --;
        } else {
            c = color(255 * life / initlife);
        }
        tint(c);
        image(sprite, x, y);
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
                life --;
                hitFrames = 10;
                ls.lasersystem.remove(i);
            }
        }
    }


    boolean isOffScreen() { //Checks if the enemy is offscreen
        if (x < -700 || x > width + 700 || y < -700 || y > height+700) {
            return true;
        }
        return false;
    }

    void inPadding() {//If the enemy goes inside the padded area, it will stay there until it dies.
        if (!isOnxPadding() && !isOnyPadding()) {
            inPadding = true;
        }
    }
}
//Misha Melnyk
