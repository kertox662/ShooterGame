class GameOver {

    int start;
    int delay;
    String message;
    int score;
    SoundFile gameOverSound;

    GameOver(String message, int delay, PApplet main) {
        this.message = message;
        this.delay = delay;
        gameOverSound = new SoundFile(main, "Sounds/GameOver.wav");
    }

    void displayText() {
        textAlign(CENTER, CENTER);
        textSize(48);
        fill(255);
        text(message, width/2, height/2);
        String msg = "Your final score was - "+ score;
        textSize(24);
        text(msg, width/2, height/2 + 100);
    }

    void run() {
        if (frameCount - start <= delay) {
            displayText();
        } else {
            if(eSys.difficulty < 1){
                if(score > hiScoreEasy){
                    hiScoreEasy = score;
                }
            }else if(eSys.difficulty == 1){
                if(score > hiScoreNormal){
                    hiScoreNormal = score;
                }
            }else if(eSys.difficulty > 1){
                if(score > hiScoreHard){
                    hiScoreHard = score;
                }
            }
            
            PrintWriter scoresOut;
            scoresOut = createWriter("data/hiScores.txt");
            scoresOut.println(hiScoreEasy);
            scoresOut.println(hiScoreNormal);
            scoresOut.println(hiScoreHard);
            scoresOut.flush();
            scoresOut.close();
            
            gameScene = "Title";
            p.x = width/2;
            p.y = height - 100;
            p.life = 5;
            p.score = 0;
            p.nextLifeGain = 250;
            for(int i = eSys.eSysArray.size()-1; i>=0; i--){
                eSys.eSysArray.remove(i);
            }
        }
    }
}
