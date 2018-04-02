class GameOver{
    
    int start;
    int delay;
    String message;
    
    
    GameOver(String message, int delay){
        this.message = message;
        this.delay = delay;
    }
    
    void displayText(){
        textAlign(CENTER, CENTER);
        textSize(48);
        fill(255);
        text(message, width/2, height/2);
    }
    
    void run(){
        if(frameCount - start <= delay){
            displayText();
        } else{
            gameScene = "Title";
        }
    }
}
