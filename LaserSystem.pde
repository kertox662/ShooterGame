//Misha Melnyk
//The system to organize laser objects
class LaserSystem {
    ArrayList<Laser> lasersystem; //Main storage variable for lasers

    LaserSystem() {
        lasersystem = new ArrayList<Laser>();
    }

    void addLaser(float x, float y, int speed, color c) { //Adds a laser to the array
        lasersystem.add(new Laser(x, y, speed, c));
    }

    void removeOld() { //Removes the laser from array if off screen
        for (int i = lasersystem.size()-1; i>=0; i--) {
            Laser l = lasersystem.get(i);
            if (l.checkOffScreen()) {
                lasersystem.remove(i);
            }
        }
    }

    void run() { //Runs the methods for all lasers in the array
        removeOld();
        for (int i = lasersystem.size()-1; i>=0; i--) {
            Laser l = lasersystem.get(i);
            l.move();
            l.display();
        }
    }
}//Misha Melnyk
