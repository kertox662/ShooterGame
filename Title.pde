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


    void changeOption(String mode, int index, int change) { //Changes the currently selected option
        if (mode == "set") {
            currOption = index;
        } else if (mode == "add") {
            if (change <= -1 && currOption >= change*-1) {
                currOption += change;
            } else if (change >= 1 && currOption <= options.length - change - 1) {
                currOption += change;
            }
        }
        changeSound.rate(1.25);
        if (!mute) {
            changeSound.play();
        }
    }

    void displayText() { //Displays option text, instructions, and high scores
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

    void displayTitle() { //Displays the title
        textAlign(CENTER, CENTER);
        fill(255, 0, 0);
        textSize(48);
        text(title, width/2, titley);
    }

    void confirmClicked() { //The method that processes when space is clickes on the title screen
        String o = options[currOption];
        if (!mute) {
            confirmSound.play();
        }
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
            eSys.difficulty += 0.25;
            if (eSys.difficulty > 1.25) {
                eSys.difficulty = 0.75;
            }
            if (eSys.difficulty < 1) {//Changes difficulty text(not an option itself)
                options[3] = "Easy Difficulty";
            } else if (eSys.difficulty == 1) {
                options[3] = "Normal Difficulty";
            } else {
                options[3] = "Hard Difficulty";
            }
        }
    }
}//Misha Melnyk
