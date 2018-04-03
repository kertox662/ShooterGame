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
    String[] spriteList = {"Images/ship.png", "Images/ship2.png", "Images/ship3.png"};
    int currSprite;

    SoundFile lifeGainSound;
    SoundFile shipHit;

    int lastFrameShot = 0; //Delay for shooting

    float xpadding; //Padding so player doesn't leave screen
    float ypadding;

    int life = 5;
    PImage heart = loadImage("Images/PixelHeart.png");

    int score;
    int lastFrameHit = -60;

    int nextLifeGain = 250;


    Player(float x, float y, int currSprite, String soundfile, PApplet main) { //Constructor with default speeds of 3
        this.x = x;
        this.y = y;
        xspeed = 1;
        yspeed = 1;
        this.currSprite = currSprite;
        sprite = loadImage(spriteList[currSprite]);
        laserSound = new SoundFile(main, soundfile);
        lifeGainSound = new SoundFile(main, "Sounds/LifeGain.flac");
        shipHit = new SoundFile(main, "Sounds/shipHit.aiff");
        xpadding = sprite.width/2;
        ypadding = sprite.height/2;
    }

    Player(float x, float y, int hspeed, int vspeed, String file, String soundfile, PApplet main) { //Constructor with given speeds
        this.x = x;
        this.y = y;
        xspeed = hspeed;
        yspeed = vspeed;
        sprite = loadImage(file);
        laserSound = new SoundFile(main, soundfile);
        xpadding = sprite.width/2;
        ypadding = sprite.height/2;
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
        if (isFlashing()) {
            tint(255, 40);
        } else {
            tint(255);
        }
        image(sprite, x, y);
    }

    void displayLife() {
        addLife();
        for (int i = 0; i<life; i++) {
            imageMode(CENTER);
            tint(255);
            image(heart, 18 + i*34, 20);
        }
    }

    void addLife() {
        if (score >= nextLifeGain) {
            life++;
            nextLifeGain *= 1.75;
            lifeGainSound.rate(2);
            if (!mute) {
                lifeGainSound.play();
            }
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
                if (!mute) {
                    laserSound.play();
                }
            }
        }
    }

    void changeSprite() {
        currSprite ++;
        sprite = loadImage(spriteList[currSprite%spriteList.length]);
    }

    boolean isColliding(Enemy other) { //Checks if colliding with laser object

        float distX = 0;
        float distY = 0;

        if (other.x <= x) {
            distX = abs((x - sprite.width/2) - (other.x + other.sprite.width/2));
        } else if (other.x >= x) {
            distX = abs((x + sprite.width/2) - (other.x - other.sprite.width/2));
        }

        if (other.y <= y) {
            distY = abs((y + sprite.height/2) - (other.y + other.sprite.height/2));
        } else if (other.y >= y) {
            distY = abs((y - sprite.height/2) - (other.y - other.sprite.height/2));
        }

        if (distX < 10) {
            if (distY < sprite.height/2 + other.sprite.height/2) {
                return true;
            }
        }
        return false;
    }

    void checkCollisions(EnemySystem es) {
        for (int i = es.eSysArray.size()-1; i >= 0; i--) {
            Enemy e = es.eSysArray.get(i);
            if (frameCount- lastFrameHit >= frameRate *1.5) {
                if (isColliding(e)) {
                    life --;
                    if (!mute) {
                        shipHit.rate(1.4);
                        shipHit.play();
                    }
                    lastFrameHit = frameCount;
                }
            }
        }
        if (life <= 0) {
            GO.gameOverSound.rate(1.2);
            GO.gameOverSound.play();
            GO.start = frameCount;
            GO.score = score;
            gameScene = "GameOver";
            music.stop();
        }
    }

    boolean isFlashing() {
        if (frameCount- lastFrameHit <= frameRate) {
            if ((frameCount - lastFrameHit)%20 < 10) {
                return true;
            }
        }
        return false;
    }

    void run() {
        move();
        shoot();
        display();
        checkCollisions(eSys);
        displayLife();
    }
}
