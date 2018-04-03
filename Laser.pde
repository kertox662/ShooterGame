//Misha Melnyk
//Basic Class that moves, displays, and can check if it's offscreen
class Laser {

    float x;
    float y;
    int speed;
    color c;

    int w = 3;
    int h = 12;

    Laser(float x, float y, int speed, color c) {
        this.x = x;
        this.y = y;
        this.speed = speed;
        this.c = c;
    }

    void move() {
        y -= speed;
    }

    void display() {
        rectMode(CENTER);
        fill(c);
        rect(x, y, w, h);
    }

    boolean checkOffScreen() {
        if (y+h < 0 || y-h > height) {
            return true;
        }
        return false;
    }
}
