import processing.sound.*;

Player p;
LaserSystem laserSys;
EnemySystem eSys;
SoundFile music;
Title t;

String gameScene = "Title";

void setup() {
    size(800, 800, P2D);
    frameRate(60);
    p = new Player(width/2, height - 100, "ship.png", "zap.mp3", this);
    laserSys = new LaserSystem();
    eSys = new EnemySystem();
    eSys.addEnemy(width/2, 100, 5, 0, "Alien2.png", 1);
    eSys.addEnemy(200, 100, 5, 0, "Alien4.png", 1);
    music = new SoundFile(this, "KomikuTheMomentofTruth.mp3");
    music.loop();
    t = new Title();
}

void draw() {

    if (gameScene == "Title") {
        t.displayTitle();
        t.displayText();
    } else if (gameScene == "Main") {
        runGame();
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
        p.setShoot(true);
    }

    println("Pressed: "+key);
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

    println("Released: "+key);
}

void displayScore() {
    String scoreMsg = "Score: " + p.score;
    textAlign(LEFT);
    textSize(16);
    fill(255);
    text(scoreMsg, 5, height - 5);
}

void runGame() {
    background(155);
    laserSys.run();
    p.display();
    p.move();
    p.shoot();
    eSys.run();
    p.displayLife();
    displayScore();
}
