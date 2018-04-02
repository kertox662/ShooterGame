class EnemySystem{
    ArrayList<Enemy> eSysArray;
    
    
    EnemySystem(){
        eSysArray = new ArrayList<Enemy>();
    }
    
    
    void addEnemy(float x, float y, int hspeed, int vspeed,String file, int xdirection){
        eSysArray.add(new Enemy(x, y,hspeed, vspeed,file, xdirection));
    }
    
    void run(){
        for(int i = eSysArray.size()-1; i >= 0; i--){
            Enemy e = eSysArray.get(i);
            e.checkCollisions(laserSys);
            e.move();
            e.display();
            
        }
    }
}
