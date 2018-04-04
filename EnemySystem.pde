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
    void addEnemy(float x, float y, float hspeed, float vspeed, String file, int xdirection, int life, int scoreVal, PApplet main) {
        eSysArray.add(new Enemy(x, y, hspeed, vspeed, file, xdirection, life, scoreVal, main));
    }

    void run() { //Runs the enemy methods for each enemy
        for (int i = eSysArray.size()-1; i >= 0; i--) {
            Enemy e = eSysArray.get(i);
            if (e.life <= 0) {
                p.score += e.scoreVal;
                if (!mute) {
                    e.enemyHit.amp(0.4);
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
    void addEnemyRow(int amount, int firstX, int xgap, int firstY, int ygap, float hspeed, float vspeed, String file, int xdirection, int life, int scoreVal, PApplet main) {
        for (int i = 0; i < amount; i++) {
            addEnemy(firstX + i*xgap, firstY + i*ygap, hspeed, vspeed, file, xdirection, life, scoreVal, main);
        }
    }
    //Creates a Queue from which to get the pattern numbers
    void genQueue() {
        for (int i = 0; i < patternQueue.length; i++) {
            patternQueue[i] = int(random(25));
        }
    }
    //The patterns that can be gotten from the Queue
    void doEnemyRow(int pattern, PApplet main) {

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
