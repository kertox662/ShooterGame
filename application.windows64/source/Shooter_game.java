import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.sound.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Shooter_game extends PApplet {

//Author - Misha Melnyk
//Name - Shooter Game
//Purpose - Learn how to use Processing in a fun way
//
//Main file for the program



Player p; //Player Object

LaserSystem laserSys; //Systems for organizing Lasers and enemies that need large iterations of repeated actions
EnemySystem eSys;

SoundFile music;

Title t; //Declare the objects for the scenes
GameOver GO;
BG back;

PFont font;

String gameScene = "Title"; //Initial conditions
boolean mute = false;

int hiScoreEasy; //High score system
int hiScoreNormal;
int hiScoreHard;

int musicStartFrame; //For reseting music




public void setup() {
    
    frameRate(60);

    p = new Player(width/2, height - 100, 0, "Sounds/zap.mp3", this);

    laserSys = new LaserSystem();
    eSys = new EnemySystem();

    music = new SoundFile(this, "Sounds/KomikuTheMomentofTruth.mp3");

    t = new Title(this);
    GO = new GameOver("GAME OVER", 180, this);

    font = createFont("8-BIT-WONDER.ttf", 36); //Initializes an 8-bit style font
    textFont(font);
    back = new BG();

    String [] hiScores = loadStrings("hiScores.txt"); //Gets old high scores from a text file
    hiScoreEasy = PApplet.parseInt(hiScores[0]);
    hiScoreNormal = PApplet.parseInt(hiScores[1]);
    hiScoreHard = PApplet.parseInt(hiScores[2]);
}

public void draw() {
    back.run(); //The background will always be generated
    eSys.genQueue();//An array of numbers is generated to determine which enemy patterns to spawn
    if (gameScene == "Title") {
        t.displayTitle(); //Title scene is drawn
        t.displayText();
        p.display();
    } else if (gameScene == "Main") {
        while (eSys.eSysArray.size() < 15) { //Keeps the amount of enemies a minimum of 15
            eSys.doEnemyRow(PApplet.parseInt(random(26)), this);
        }

        runGame(); //Main processes in the game
    } else if (gameScene == "GameOver") {
        GO.run(); //Runs game over screen
    }
}


public void keyPressed() { //Key inputs
    if (key == 'a'||key == 'A') {
        if (gameScene == "Main") {
            p.setMove(3, true);
        }
    } else if (key == 'w'|| key == 'W') {
        if (gameScene == "Main") {
            p.setMove(0, true);
        } else if (gameScene == "Title") {
            t.changeOption("add", 0, -1);
        }
    } else if (key == 'd' || key == 'D') {
        if (gameScene == "Main") {
            p.setMove(1, true);
        }
    } else if (key == 's' || key == 'S') {
        if (gameScene == "Main") {
            p.setMove(2, true);
        } else if (gameScene == "Title") {
            t.changeOption("add", 0, 1);
        }
    } else if (keyCode == 32) {
        if (gameScene == "Main") {
            p.setShoot(true);
        } else if (gameScene == "Title") {
            t.confirmClicked();
        }
    }
}

public void keyReleased() { //Key input on release
    if (key == 'a'||key == 'A') {
        p.setMove(3, false);
    } else if (key == 'w'|| key == 'W') {
        p.setMove(0, false);
    } else if (key == 'd' || key == 'D') {
        p.setMove(1, false);
    } else if (key == 's' || key == 'S') {
        p.setMove(2, false);
    } else if (keyCode == 32) {
        p.setShoot(false);
    }
}

public void displayScore() { //Displays score in the bottom left
    String scoreMsg = "Score: " + p.score;
    textAlign(LEFT);
    textSize(16);
    fill(255);
    text(scoreMsg, 5, height - 5);
}

public void runGame() { //Main game runner
    laserSys.run();
    eSys.run();
    p.run();
    displayScore();
}
//Misha Melnyk
//Misha Melnyk
//Generates the background in all scenes
class BG {
    ArrayList<Star> bgArray;

    BG() {
        bgArray = new ArrayList<Star>();
    }

    public void addStar() { //Adds Star object to array, which will go across screen
        bgArray.add(new Star(random(width), -50, PApplet.parseInt(random(10, 20)), PApplet.parseInt(random(50, 255)), random(1, 6)));
    }

    public void startMusic() { //Restarts music if finishes before player dies
        if (gameScene == "Main") {
            if (frameCount - musicStartFrame > music.duration()*frameRate) {
                if (!mute) {
                    music.play();
                    musicStartFrame = frameCount;
                }
            }
        }
    }

    public void run() { //Runs the main loop for the background
        if (random(1) < 0.2f) {
            addStar();
        }
        startMusic();
        background(0);
        for (int i = bgArray.size()-1; i >= 0; i--) { //Moves, displays and removes stars
            Star s = bgArray.get(i);
            s.move();
            s.display();
            if (s.isOffScreen()) {
                bgArray.remove(i);
            }
        }
    }
}// Background
//Misha Melnyk
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
    int c = color(0, 255, 0);

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


    public boolean isOnxPadding() { //Checks if enemy is on x padding
        if (x < xPadding || x > width - xPadding) {
            return true;
        } 
        return false;
    }

    public boolean isOnyPadding() { //Checks if enemy is on y padding
        if (y < yPadding || y > height - yPadding) {
            return true;
        } 
        return false;
    }
    public void move() {//Movement and check for edge collision

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

    public void display() { //Draws the enemy
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

    public boolean isColliding(Laser other) { //Checks if colliding with laser object
        if (other.x > x - sprite.width/2 && other.x < x + sprite.width/2) {
            if (other.y > y - sprite.height/2 && other.y < y + sprite.height/2) {
                return true;
            }
        }
        return false;
    }

    public void checkCollisions(LaserSystem ls) { //Checks collision with all laser objects in a laser system
        for (int i = ls.lasersystem.size()-1; i >= 0; i--) {
            Laser l = ls.lasersystem.get(i);
            if (isColliding(l)) {
                life --;
                hitFrames = 10;
                ls.lasersystem.remove(i);
            }
        }
    }


    public boolean isOffScreen() { //Checks if the enemy is offscreen
        if (x < -700 || x > width + 700 || y < -700 || y > height+700) {
            return true;
        }
        return false;
    }

    public void inPadding() {//If the enemy goes inside the padded area, it will stay there until it dies.
        if (!isOnxPadding() && !isOnyPadding()) {
            inPadding = true;
        }
    }
}
//Misha Melnyk
//Misha Melnyk
//The system to organize enemy objects
class EnemySystem {
    ArrayList<Enemy> eSysArray; //Storage for enemy objects
    int[] patternQueue = new int[6];
    float difficulty = 1; //Difficuly, raises the speed of enemies
    
    int numOptions = 26;
    
    
    EnemySystem() {
        eSysArray = new ArrayList<Enemy>();
    }

    //Adds an enemy to the system array to allow for massive updates in one frame
    public void addEnemy(float x, float y, float hspeed, float vspeed, String file, int xdirection, int life, int scoreVal, PApplet main) {
        eSysArray.add(new Enemy(x, y, hspeed, vspeed, file, xdirection, life, scoreVal, main));
    }

    public void run() { //Runs the enemy methods for each enemy
        for (int i = eSysArray.size()-1; i >= 0; i--) {
            Enemy e = eSysArray.get(i);
            if (e.life <= 0) {
                p.score += e.scoreVal;
                if (!mute) {
                    e.enemyHit.amp(0.4f);
                    e.enemyHit.play();
                }
                eSysArray.remove(i);
            }

            if (e.isOffScreen()) {
                eSysArray.remove(i);
            }
            e.checkCollisions(laserSys);
            e.move();
            e.display();
            e.inPadding();
        }
    }
    //Adds a row of enemies to the system array
    public void addEnemyRow(int amount, int firstX, int xgap, int firstY, int ygap, float hspeed, float vspeed, String file, int xdirection, int life, int scoreVal, PApplet main) {
        for (int i = 0; i < amount; i++) {
            addEnemy(firstX + i*xgap, firstY + i*ygap, hspeed, vspeed, file, xdirection, life, scoreVal, main);
        }
    }
    //Creates a Queue from which to get the pattern numbers
    public void genQueue() {
        for (int i = 0; i < patternQueue.length; i++) {
            patternQueue[i] = PApplet.parseInt(random(25));
        }
    }
    //The patterns that can be gotten from the Queue
    public void doEnemyRow(int pattern, PApplet main) {

        if (pattern%numOptions == 0) {
            eSys.addEnemyRow(6, -100, -100, 50, 0, 1*difficulty, 0, "Images/Alien1.png", 1, 1, 25, main);// Alien 1 row
        } else if (pattern%numOptions == 1) { 
            eSys.addEnemyRow(5, -200, -70, 600, 70, 1*difficulty, -2*difficulty, "Images/Alien1.png", 1, 1, 25, main);//Alien 1 diagonal right
        } else if (pattern%numOptions == 2) { 
            eSys.addEnemyRow(5, width + 200, 70, 500, 70, -1*difficulty, -2*difficulty, "Images/Alien1.png", 1, 1, 25, main);//Alien 1 diagonal left
        } else if (pattern%numOptions == 3) {
            eSys.addEnemyRow(4, -200, -70, 600, 70, 1*difficulty, -2*difficulty, "Images/Alien1.png", 1, 1, 25, main);//Alien 1 diagonal right + left
            eSys.addEnemyRow(4, width + 200, 70, 600, 70, -1*difficulty, -2*difficulty, "Images/Alien1.png", 1, 1, 25, main);
        } else if (pattern%numOptions == 4) {
            eSys.addEnemyRow(5, width/2, 50, -100, -70, -1*difficulty, 1*difficulty, "Images/Alien1.png", 1, 1, 25, main); //Alien 1 center diagonal left
        } else if (pattern%numOptions == 5) {
            eSys.addEnemyRow(5, width/2, -50, -100, -70, 1*difficulty, 1*difficulty, "Images/Alien1.png", 1, 1, 25, main);//Alien 1 center diagonal right
        } else if (pattern%numOptions == 6) {
            eSys.addEnemyRow(4, width/2, -50, -100, -70, 1*difficulty, 1*difficulty, "Images/Alien1.png", 1, 1, 25, main);//Alien 1 center diagonal right
            eSys.addEnemyRow(4, width/2, 50, -100, -70, -1*difficulty, 1*difficulty, "Images/Alien1.png", 1, 1, 25, main);
        }
        //============================================================================================================
        else if (pattern%numOptions == 7) {
            eSys.addEnemyRow(6, -100, -100, 50, 0, -3*difficulty, 0, "Images/Alien2.png", 1, 2, 50, main); // Alien 2 row
        } else if (pattern%numOptions == 8) {
            eSys.addEnemyRow(5, -300, -70, 500, 70, 3*difficulty, -3*difficulty, "Images/Alien2.png", 1, 2, 50, main); //Alien 2 diagonal right
        } else if (pattern%numOptions == 9) {
            eSys.addEnemyRow(5, width + 300, 70, 500, 70, -3*difficulty, -3*difficulty, "Images/Alien2.png", 1, 2, 50, main); //Alien 2 diagonal left
        } else if (pattern%numOptions == 10) {
            eSys.addEnemyRow(5, width/2, 50, -100, -70, -3*difficulty, 3*difficulty, "Images/Alien2.png", 1, 2, 50, main); //Alien 2 center diagonal left
        } else if (pattern%numOptions == 11) {
            eSys.addEnemyRow(5, width/2, -50, -100, -70, 3*difficulty, 3*difficulty, "Images/Alien2.png", 1, 2, 50, main);//Alien 2 center diagonal right
        }
        //============================================================================================================
        else if (pattern%numOptions == 12) {
            eSys.addEnemyRow(5, -100, -100, 50, 0, 5*difficulty, 0, "Images/Alien3.png", 1, 3, 100, main); // Alien 3 row
        } else if (pattern%numOptions == 13) {
            eSys.addEnemyRow(3, -200, -70, 500, 70, 5*difficulty, -4*difficulty, "Images/Alien3.png", 1, 3, 100, main); //Alien 3 diagonal right
        } else if (pattern%numOptions == 14) {
            eSys.addEnemyRow(3, width + 200, 70, 500, 70, -5*difficulty, -4*difficulty, "Images/Alien3.png", 1, 3, 100, main); //Alien 3 diagonal left
        } else if (pattern%numOptions == 15) {
            eSys.addEnemyRow(3, -200, -70, 500, 70, 5*difficulty, -4*difficulty, "Images/Alien3.png", 1, 3, 100, main); //Alien 3 diagonal right
            eSys.addEnemyRow(3, width + 200, 70, 500, 70, -5*difficulty, -4*difficulty, "Images/Alien3.png", 1, 3, 100, main); //Alien 3 diagonal left
        } else if (pattern%numOptions == 16) {
            eSys.addEnemyRow(3, width/2, 50, -100, -70, -5*difficulty, 4*difficulty, "Images/Alien3.png", 1, 3, 100, main); //Alien 3 center diagonal left
        } else if (pattern%numOptions == 17) {
            eSys.addEnemyRow(3, width/2, -50, -100, -70, 5*difficulty, 4*difficulty, "Images/Alien3.png", 1, 3, 100, main);//Alien 3 center diagonal right
        } else if (pattern%numOptions == 18) {
            eSys.addEnemyRow(3, width/2, 50, -100, -70, -5*difficulty, 4*difficulty, "Images/Alien3.png", 1, 3, 100, main); //Alien 3 center diagonal left
            eSys.addEnemyRow(3, width/2, -50, -100, -70, 5*difficulty, 4*difficulty, "Images/Alien3.png", 1, 3, 100, main);//Alien 3 center diagonal right
        }            
        //============================================================================================================
        else if (pattern%numOptions == 19) {
            eSys.addEnemyRow(5, -100, -100, 50, 0, -7*difficulty, 0, "Images/Alien4.png", 1, 1, 125, main); // Alien 4 row
        } else if (pattern%numOptions == 20) {
            eSys.addEnemyRow(3, -200, -70, 500, 70, 6*difficulty, -6*difficulty, "Images/Alien4.png", 1, 1, 125, main); //Alien 4 diagonal right
        } else if (pattern%numOptions == 21) {
            eSys.addEnemyRow(3, width + 200, 70, 500, 70, -6*difficulty, -6*difficulty, "Images/Alien4.png", 1, 1, 125, main); //Alien 4 diagonal left
        } else if (pattern%numOptions == 22) {
            eSys.addEnemyRow(3, width/2, 50, -100, -70, -7*difficulty, 6*difficulty, "Images/Alien4.png", 1, 1, 125, main); //Alien 4 center diagonal left
            eSys.addEnemyRow(3, width/2, -50, -100, -70, 7*difficulty, 6*difficulty, "Images/Alien4.png", 1, 1, 125, main);//Alien 4 center diagonal right
        }

        //Combined Alien types =======================================================================================
        else if (pattern%numOptions == 23) {
            eSys.addEnemyRow(3, -100, -200, 50, 0, 2*difficulty, 0, "Images/Alien1.png", 1, 1, 25, main); // Row Alien1&2
            eSys.addEnemyRow(2, -200, -200, 50, 0, 2*difficulty, 0, "Images/Alien2.png", 1, 2, 50, main);
            eSys.addEnemyRow(3, -100, -200, 100, 0, 2*difficulty, 0, "Images/Alien2.png", 1, 2, 50, main);
            eSys.addEnemyRow(2, -200, -200, 100, 0, 2*difficulty, 0, "Images/Alien1.png", 1, 1, 25, main);
        } else if (pattern%numOptions == 24) {

            eSys.addEnemyRow(4, -100, -200, 50, 0, 6*difficulty, 0, "Images/Alien3.png", 1, 2, 100, main); // Row Alien3&4
            eSys.addEnemyRow(3, -200, -200, 50, 0, 6*difficulty, 0, "Images/Alien4.png", 1, 3, 125, main);
            eSys.addEnemyRow(4, -100, -200, 100, 0, 6*difficulty, 0, "Images/Alien4.png", 1, 3, 125, main);
            eSys.addEnemyRow(3, -200, -200, 100, 0, 6*difficulty, 0, "Images/Alien3.png", 1, 2, 100, main);
        }

        //Special Patterns
        else if (pattern%numOptions == 25) {
            eSys.addEnemyRow(4, 100, 0, -100, -100, 0, 3*difficulty, "Images/Alien2.png", 1, 2, 50, main); //M-shape
            eSys.addEnemyRow(1, 200, 0, -300, 0, 0, 3*difficulty, "Images/Alien2.png", 1, 2, 50, main);
            eSys.addEnemyRow(1, 300, 0, -200, 0, 0, 3*difficulty, "Images/Alien2.png", 1, 2, 50, main);
            eSys.addEnemyRow(1, 400, 0, -300, 0, 0, 3*difficulty, "Images/Alien2.png", 1, 2, 50, main);
            eSys.addEnemyRow(4, 500, 0, -100, -100, 0, 3*difficulty, "Images/Alien2.png", 1, 2, 50, main);
        }
    }
}
//Misha Melnyk
//Misha Melnyk
//The scene that processes a game over
class GameOver {

    int start;//Starting frame
    int delay;//How long it will last
    String message;//What it will say
    int score; //The score it displays
    SoundFile gameOverSound;

    GameOver(String message, int delay, PApplet main) {
        this.message = message;
        this.delay = delay;
        gameOverSound = new SoundFile(main, "Sounds/GameOver.wav");
    }

    public void displayText() { //Displays main message as well as score underneath
        textAlign(CENTER, CENTER);
        textSize(48);
        fill(255);
        text(message, width/2, height/2);
        String msg = "Your final score was - "+ score;
        textSize(24);
        text(msg, width/2, height/2 + 100);
    }

    public void run() { //Runs the main methods
        if (frameCount - start <= delay) {//Occurs for 3 seconds from instance in Shooter_game
            displayText();
        } else {
            if (eSys.difficulty < 1) { //Updates score based on difficulty
                if (score > hiScoreEasy) {
                    hiScoreEasy = score;
                }
            } else if (eSys.difficulty == 1) {
                if (score > hiScoreNormal) {
                    hiScoreNormal = score;
                }
            } else if (eSys.difficulty > 1) {
                if (score > hiScoreHard) {
                    hiScoreHard = score;
                }
            }

            PrintWriter scoresOut; //Updates score in text file
            scoresOut = createWriter("data/hiScores.txt");
            scoresOut.println(hiScoreEasy);
            scoresOut.println(hiScoreNormal);
            scoresOut.println(hiScoreHard);
            scoresOut.flush();
            scoresOut.close();

            //Resets the game
            gameScene = "Title";
            p.x = width/2;
            p.y = height - 100;
            p.life = 5;
            p.score = 0;
            p.nextLifeGain = 250;
            for (int i = eSys.eSysArray.size()-1; i>=0; i--) {
                eSys.eSysArray.remove(i);
            }
        }
    }
}
//Misha Melnyk
//Misha Melnyk
//Basic Class that moves, displays, and can check if it's offscreen
class Laser {

    float x;
    float y;
    int speed;
    int c;

    int w = 5;
    int h = 14;

    Laser(float x, float y, int speed, int c) {
        this.x = x;
        this.y = y;
        this.speed = speed;
        this.c = c;
    }

    public void move() {
        y -= speed;
    }

    public void display() {
        rectMode(CENTER);
        fill(c);
        rect(x, y, w, h);
    }

    public boolean checkOffScreen() {
        if (y+h < 0 || y-h > height) {
            return true;
        }
        return false;
    }
}
//Misha Melnyk
//The system to organize laser objects
class LaserSystem {
    ArrayList<Laser> lasersystem; //Main storage variable for lasers

    LaserSystem() {
        lasersystem = new ArrayList<Laser>();
    }

    public void addLaser(float x, float y, int speed, int c) { //Adds a laser to the array
        lasersystem.add(new Laser(x, y, speed, c));
    }

    public void removeOld() { //Removes the laser from array if off screen
        for (int i = lasersystem.size()-1; i>=0; i--) {
            Laser l = lasersystem.get(i);
            if (l.checkOffScreen()) {
                lasersystem.remove(i);
            }
        }
    }

    public void run() { //Runs the methods for all lasers in the array
        removeOld();
        for (int i = lasersystem.size()-1; i>=0; i--) {
            Laser l = lasersystem.get(i);
            l.move();
            l.display();
        }
    }
}//Misha Melnyk
//Misha Melnyk
//The class that is responsible for the player's ship
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
    float fric = 0.1f;
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

    int life = 5; //Life count and heart image
    PImage heart = loadImage("Images/PixelHeart.png");

    int score;//Score
    int lastFrameHit = -60; //Last frame that the player was hit, allows for them to be hit and not immediately die due to higher framerate

    int nextLifeGain = 250; //The score needed to gain an extra life


    Player(float x, float y, int currSprite, String soundfile, PApplet main) { //Constructor with default speeds of 3
        this.x = x;
        this.y = y;
        xspeed = 4;
        yspeed = 4;
        this.currSprite = currSprite;
        sprite = loadImage(spriteList[currSprite]);
        laserSound = new SoundFile(main, soundfile);
        lifeGainSound = new SoundFile(main, "Sounds/LifeGain.flac");
        shipHit = new SoundFile(main, "Sounds/shipHit.aiff");
        xpadding = sprite.width/2;
        ypadding = sprite.height/2;
    }

    public void changeVelocity() { //Changes Velocity based on which directions are toggles to be moved in
        if (up && !down) {
            yvel -= yspeed;
        } else if (down && !up) {
            yvel += yspeed;
        }
        if (yvel!=0) {
                yvel -= yvel*fric ;
            }

        if (left && !right) {
            xvel -= xspeed;
        } else if (right && !left) {
            xvel += xspeed;
        } 
        if (xvel!=0) {
                xvel -= xvel*fric;
            }
    }

    public void checkPadding() { //Checks if the player is colliding with the padding and moves them into the desired area if outside
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

    public void move() { // Changes x and y based on velocity
        changeVelocity();
        checkPadding();
        if (yvel != 0) {
            y += yvel*fric;
        }
        if (xvel != 0) {
            x += xvel*fric;
        }
    }

    public void display() { //Draws the player sprite
        imageMode(CENTER);
        if (isFlashing()) {
            tint(255, 40);
        } else {
            tint(255);
        }
        image(sprite, x, y);
    }

    public void displayLife() { //Displays the life total in top left
        addLife();
        for (int i = 0; i<life; i++) {
            imageMode(CENTER);
            tint(255);
            image(heart, 18 + i*34, 20);
        }
    }

    public void addLife() { //Checks if the player has enough score to get an extra life
        if (score >= nextLifeGain) {
            life++;
            nextLifeGain *= 1.4f;
            lifeGainSound.rate(2);
            if (!mute) {
                lifeGainSound.play();
            }
        }
    }

    public void setMove(int dir, boolean doMove) { //Sets the movement conditions when called
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

    public void setShoot(boolean startStop) { //Sets shooting conditions
        shooting = startStop;
    }

    public void shoot() { //Shoots if shooting condition is true
        if (shooting) {
            if (frameCount - lastFrameShot > frameRate*3/8) {
                laserSys.addLaser(x, y, 15, color(255, 0, 0));
                lastFrameShot = frameCount;
                laserSound.amp(0.25f);
                laserSound.rate(1.5f);
                if (!mute) {
                    laserSound.play();
                }
            }
        }
    }

    public void changeSprite() {//Changes the file used as the sprite for the player
        currSprite ++;
        sprite = loadImage(spriteList[currSprite%spriteList.length]);
    }

    public boolean isColliding(Enemy other) { //Checks if colliding with enemy object

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

    public void checkCollisions(EnemySystem es) {//Checks collision for all enemy objects
        for (int i = es.eSysArray.size()-1; i >= 0; i--) {
            Enemy e = es.eSysArray.get(i);
            if (frameCount- lastFrameHit >= frameRate *1.5f) {
                if (isColliding(e)) {
                    life --;
                    if (!mute) {
                        shipHit.rate(1.4f);
                        shipHit.play();
                    }
                    lastFrameHit = frameCount;
                }
            }
        }
        if (life <= 0) { //If no life, initializes game over screen
            GO.gameOverSound.rate(1.2f);
            GO.gameOverSound.play();
            GO.start = frameCount;
            GO.score = score;
            gameScene = "GameOver";
            music.stop();
        }
    }

    public boolean isFlashing() {//Determines if the display method should have the player flashing
        if (frameCount- lastFrameHit <= frameRate) {
            if ((frameCount - lastFrameHit)%20 < 10) {
                return true;
            }
        }
        return false;
    }

    public void run() {//Runs main methods
        move();
        shoot();
        display();
        checkCollisions(eSys);
        displayLife();
    }
}
//Misha Melnyk
//Misha Melnyk
//Basic class that move across the screen, displays with alpha, and knows when it's offscreen
//Displays as a circle
class Star {
    float x;
    float y;
    float rad;

    int yspeed;
    int alphaVal;

    Star(float x, float y, int yspeed, int alphaVal, float rad) {
        this.x = x;
        this.y = y;
        this.yspeed = yspeed;
        this.alphaVal = alphaVal;
        this.rad = rad;
    }

    public void move() {
        y += yspeed;
    }

    public void display() {
        fill(255, alphaVal);
        ellipse(x, y, rad*2, rad*2);
    }

    public boolean isOffScreen() {
        if (y > height+100) {
            return true;
        }
        return false;
    }
}
//Misha Melnyk
//The scene responsible for drawing the title
class Title {

    PApplet main;//Used for initializing sound
    SoundFile changeSound;
    SoundFile confirmSound;

    Title(PApplet main) {
        this.main = main;
        changeSound = new SoundFile(main, "Sounds/changeSound.wav");
        confirmSound = new SoundFile(main, "Sounds/confirmSound.wav");
    }


    int ytoTitle = 50; //Distance of option 1 to title
    int ygap = 30;//Distance between options
    int currOption = 0;
    String[] options = {"Start Game", "Change Ship", "Mute " + mute, "Normal Difficulty"}; //Option text
    String title = "Shooter Game";
    int titley = 200;


    public void changeOption(String mode, int index, int change) { //Changes the currently selected option
        if (mode == "set") {
            currOption = index;
        } else if (mode == "add") {
            if (change <= -1 && currOption >= change*-1) {
                currOption += change;
            } else if (change >= 1 && currOption <= options.length - change - 1) {
                currOption += change;
            }
        }
        changeSound.rate(1.25f);
        if (!mute) {
            changeSound.play();
        }
    }

    public void displayText() { //Displays option text, instructions, and high scores
        for (int i = 0; i<=options.length-1; i++) {
            textAlign(CENTER, CENTER);

            if (i == currOption) { //The currently selected option will be gold
                fill(250, 215, 0);
            } else {
                fill(255);
            }
            textSize(24);
            text(options[i], width/2, titley + ytoTitle + (i+1) * ygap);
        }
        textSize(12);
        fill(255);
        textAlign(LEFT);
        text("WASD    Move", 10, height - 40);
        text("Space   Shoot or Select", 10, height - 20);

        text("Easy HighScore    " + hiScoreEasy, 10, 20);
        text("Normal HighScore  " + hiScoreNormal, 10, 40);
        text("Hard HighScore    " + hiScoreHard, 10, 60);
    }

    public void displayTitle() { //Displays the title
        textAlign(CENTER, CENTER);
        fill(255, 0, 0);
        textSize(48);
        text(title, width/2, titley);
    }

    public void confirmClicked() { //The method that processes when space is clickes on the title screen
        String o = options[currOption];
        if (o == "Start Game") {//Starts the main game
            gameScene = "Main";
            if (!mute) {
                music.play();
                musicStartFrame = frameCount;
            }
        } else if (o == "Change Ship") {//Switches ship sprite
            p.changeSprite();
        } else if (currOption == 2) {//Toggles mute
            mute = !mute;
            options[2] = "Mute " + mute;
        } else if (currOption == 3) {//Sets difficulty
            eSys.difficulty += 0.25f;
            if (eSys.difficulty > 1.25f) {
                eSys.difficulty = 0.75f;
            }
            if (eSys.difficulty < 1) {//Changes difficulty text(not an option itself)
                options[3] = "Easy Difficulty";
            } else if (eSys.difficulty == 1) {
                options[3] = "Normal Difficulty";
            } else {
                options[3] = "Hard Difficulty";
            }
        }
        if (!mute) {
            confirmSound.play();
        }
    }
}//Misha Melnyk
  public void settings() {  size(800, 800, P2D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Shooter_game" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
