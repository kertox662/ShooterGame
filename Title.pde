class Title{
    Title(){
    }
    
    
    int ygap = 20;
    int currOption = 0;
    String[] options = {"Start Game", "Choose Ship"};
    String title = "Shooter Game";
    int titley = 200;
    
    
    void changeOption(String mode, int index, int change){
        if(mode == "set"){
            currOption = index;
        } else if (mode == "add"){
            if(change <= -1 && currOption >= change*-1){
                currOption += change;
            } else if(change >= 1 && currOption <= options.length - change - 1){
                currOption += change;
            }
        }
    }
    
    void displayText(){
        for(int i = 0; i>=options.length-1; i++){
            textAlign(CENTER, CENTER);
            
            if (i == currOption){
                fill(250,215,0);
            }else{
                fill(255);
            }
            textSize(24);
            text(options[i], width/2, height - 200);
        }
    }
    
    void displayTitle(){
        textAlign(CENTER, CENTER);
        fill(255,0,0);
        textSize(48);
        text(title, width/2, titley);
    }
    
}
