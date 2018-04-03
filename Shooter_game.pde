import processing.sound.*;

Player p;
LaserSystem laserSys;
EnemySystem eSys;
SoundFile music;
Title t;
GameOver GO;

BG back;

PFont font;

String gameScene = "Title";
boolean mute = false;

int hiScoreEasy;
int hiScoreNormal;
int hiScoreHard;

            


void setup() {
    size(800, 800, P2D);
    frameRate(60);
    
    p = new Player(width/2, height - 100, 0, "Sounds/zap.mp3", this);
    
    laserSys = new LaserSystem();
    eSys = new EnemySystem();
    
    music = new SoundFile(this, "Sounds/KomikuTheMomentofTruth.mp3");
    
    t = new Title(this);
    GO = new GameOver("GAME OVER", 180, this);
    
    font = createFont("8-BIT-WONDER.ttf", 36);
    textFont(font);
    back = new BG();
    
    String [] hiScores = loadStrings("hiScores.txt");
    hiScoreEasy = int(hiScores[0]);
    hiScoreNormal = int(hiScores[1]);
    hiScoreHard = int(hiScores[2]);
    
    
}

void draw() {
    back.run();
    eSys.genQueue();
    if (gameScene == "Title") {
        t.displayTitle();
        t.displayText();
        p.display();
    } else if (gameScene == "Main") {
        while (eSys.eSysArray.size() < 15) {
            eSys.doEnemyRow(int(random(25)), this);
        }

        runGame();
    } else if (gameScene == "GameOver") {
        GO.run();
    }
}


void keyPressed() {
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

    //println("Pressed: "+key);
}

void keyReleased() {
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

    //println("Released: "+key);
}

void displayScore() {
    String scoreMsg = "Score: " + p.score;
    textAlign(LEFT);
    textSize(16);
    fill(255);
    text(scoreMsg, 5, height - 5);
}

void runGame() {
    laserSys.run();
    eSys.run();
    p.run();
    displayScore();
}
