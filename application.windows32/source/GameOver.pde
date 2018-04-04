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

    void displayText() { //Displays main message as well as score underneath
        textAlign(CENTER, CENTER);
        textSize(48);
        fill(255);
        text(message, width/2, height/2);
        String msg = "Your final score was - "+ score;
        textSize(24);
        text(msg, width/2, height/2 + 100);
    }

    void run() { //Runs the main methods
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
