class BG {
    ArrayList<Star> bgArray;

    BG() {
        bgArray = new ArrayList<Star>();
    }

    void addStar() {
        bgArray.add(new Star(random(width), -50, int(random(10, 20)), int(random(50, 255)), random(1, 6)));
    }

    void startMusic() {
        if (gameScene == "Main") {
            if (frameCount - musicStartFrame > music.duration()*frameRate) {
                if (!mute) {
                    music.play();
                    musicStartFrame = frameCount;
                }
            }
        }
    }

    void run() {
        if (random(1) < 0.2) {
            addStar();
        }
        startMusic();
        background(0);
        for (int i = bgArray.size()-1; i >= 0; i--) {
            Star s = bgArray.get(i);
            s.move();
            s.display();
            if (s.isOffScreen()) {
                bgArray.remove(i);
            }
        }
    }
}// Background
