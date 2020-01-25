//Author - Misha Melnyk
//Name - Shooter Game
//Purpose - Learn how to use Processing in a fun way
//
//Main file for the program

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

Player p; //Player Object

LaserSystem laserSys; //Systems for organizing Lasers and enemies that need large iterations of repeated actions
EnemySystem eSys;

Minim minim;

AudioPlayer music;

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

final float SQRT2 = sqrt(2);


void setup() {
    //size(800, 800);
    fullScreen();
    frameRate(60);
    
    minim = new Minim(this);

    p = new Player(width/2, height - 100, 0, "Sounds/zap.wav", this);

    laserSys = new LaserSystem();
    eSys = new EnemySystem();

    music = minim.loadFile("Sounds/KomikuTheMomentofTruth.mp3");

    t = new Title(this);
    GO = new GameOver("GAME OVER", 180, this);

    font = createFont("8-BIT-WONDER.ttf", 36); //Initializes an 8-bit style font
    textFont(font);
    back = new BG();

    String [] hiScores = loadStrings("hiScores.txt"); //Gets old high scores from a text file
    hiScoreEasy = int(hiScores[0]);
    hiScoreNormal = int(hiScores[1]);
    hiScoreHard = int(hiScores[2]);
}

void draw() {
    back.run(); //The background will always be generated
    eSys.genQueue();//An array of numbers is generated to determine which enemy patterns to spawn
    if (gameScene == "Title") {
        t.displayTitle(); //Title scene is drawn
        t.displayText();
        p.display();
    } else if (gameScene == "Main") {
        while (eSys.eSysArray.size() < 15) { //Keeps the amount of enemies a minimum of 15
            eSys.doEnemyRow(int(random(26)), this);
        }

        runGame(); //Main processes in the game
    } else if (gameScene == "GameOver") {
        GO.run(); //Runs game over screen
    }
}


void keyPressed() { //Key inputs

    if (key == CODED){
        if(keyCode == ESC){
            exit();
        }
    }

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

void keyReleased() { //Key input on release
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

void displayScore() { //Displays score in the bottom left
    String scoreMsg = "Score " + p.score;
    textAlign(LEFT);
    textSize(16);
    fill(255);
    text(scoreMsg, 5, height - 5);
}

void runGame() { //Main game runner
    laserSys.run();
    eSys.run();
    p.run();
    displayScore();
}
//Misha Melnyk
