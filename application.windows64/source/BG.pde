//Misha Melnyk
//Generates the background in all scenes
class BG {
    ArrayList<Star> bgArray;

    BG() {
        bgArray = new ArrayList<Star>();
    }

    void addStar() { //Adds Star object to array, which will go across screen
        bgArray.add(new Star(random(width), -50, int(random(10, 20)), int(random(50, 255)), random(1, 6)));
    }

    void startMusic() { //Restarts music if finishes before player dies
        if (gameScene == "Main") {
            if (frameCount - musicStartFrame > music.duration()*frameRate) {
                if (!mute) {
                    music.play();
                    musicStartFrame = frameCount;
                }
            }
        }
    }

    void run() { //Runs the main loop for the background
        if (random(1) < 0.2) {
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
