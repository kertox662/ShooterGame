class Player {
    
    float x; //Coordinates
    float y;

    boolean up; //Key input togglers
    boolean down;
    boolean left;
    boolean right;
    boolean shooting;

    int xspeed; //Movement
    int yspeed;
    float fric = 0.5;
    float xvel = 0;
    float yvel = 0;

    SoundFile laserSound; //Sprite and Sound variables
    PImage sprite;

    int lastFrameShot = 0; //Delay for shooting

    int xpadding = 30; //Padding so player doesn't leave screen
    int ypadding = 27;
    
    int life = 5;
    PImage heart = loadImage("PixelHeart.png");
    
    int score;

    Player(float x, float y, String spritefile, String soundfile, PApplet main) { //Constructor with default speeds of 3
        this.x = x;
        this.y = y;
        xspeed = 1;
        yspeed = 1;
        sprite = loadImage(spritefile);
        laserSound = new SoundFile(main, soundfile);
    }

    Player(float x, float y, int hspeed, int vspeed, String file, String soundfile, PApplet main) { //Constructor with given speeds
        this.x = x;
        this.y = y;
        xspeed = hspeed;
        yspeed = vspeed;
        sprite = loadImage(file);
        laserSound = new SoundFile(main, soundfile);
    }

    void changeVelocity() { //Changes Velocity based on which directions are toggles to be moved in
        if (up && !down) {
            yvel -= yspeed*fric;
        } else if (down && !up) {
            yvel += yspeed*fric;
        } else {
            if (yvel!=0) {
                yvel -= yvel*fric ;
            }
        }

        if (left && !right) {
            xvel -= xspeed*fric;
        } else if (right && !left) {
            xvel += xspeed*fric;
        } else {
            if (xvel!=0) {
                xvel -= xvel*fric;
            }
        }
    }

    void checkPadding() { //Checks if the player is colliding with the padding and moves them into the desired area if outside
        if (x > width-xpadding || x < xpadding) {
            xvel = 0;
            if (x>width-xpadding) {
                x = width - xpadding;
            } else {
                x = xpadding;
            }
        }

        if (y > height-ypadding || y < ypadding) {
            yvel = 0;
            if (y>height-ypadding) {
                y = height - ypadding;
            } else {
                y = ypadding;
            }
        }
    }
    
    void move() { // Changes x and y based on velocity
        changeVelocity();
        checkPadding();
        if (yvel != 0) {
            y += yvel*fric;
        }
        if (xvel != 0) {
            x += xvel*fric;
        }
    }

    void display() { //Draws the player sprite
        imageMode(CENTER);
        image(sprite, x, y);
    }
    
    void displayLife(){
        for(int i = 0; i<life; i++){
            imageMode(CENTER);
            tint(255);
            image(heart, 18 + i*34, 20);
        }
    }

    void setMove(int dir, boolean doMove) { //Sets the movement conditions when called
        //direction value passed in increases up, right, down, left
        if (dir == 0) {
            up = doMove;
        } else if (dir == 1) {
            right = doMove;
        } else if (dir == 2) {
            down = doMove;
        } else if (dir == 3) {
            left = doMove;
        }
    }

    void setShoot(boolean startStop) { //Sets shooting conditions
        shooting = startStop;
    }

    void shoot() { //Shoots if shooting condition is true
        if (shooting) {
            if (frameCount - lastFrameShot > frameRate/3) {
                laserSys.addLaser(x, y, 15, color(255, 0, 0));
                lastFrameShot = frameCount;
                laserSound.amp(0.25);
                laserSound.rate(1.5);
                laserSound.play();
            }
        }
    }
}
