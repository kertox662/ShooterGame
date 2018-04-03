class Star{
    float x;
    float y;
    float rad;
    
    int yspeed;
    int alphaVal;
    
    Star(float x, float y, int yspeed, int alphaVal, float rad){
        this.x = x;
        this.y = y;
        this.yspeed = yspeed;
        this.alphaVal = alphaVal;
        this.rad = rad;
    }
    
    void move(){
        y += yspeed;
    }
    
    void display(){
        fill(255, alphaVal);
        ellipse(x,y,rad*2,rad*2);
    }
    
    boolean isOffScreen(){
        if(y > height+100){
            return true;
        }return false;
    }
}
