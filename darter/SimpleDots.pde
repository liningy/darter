class SimpleDots{
  int xpos,ypos;
  
  SimpleDots(int _x, int _y){
    xpos=_x;
    ypos=_y;    
  }
  
  void update(){
    ellipse(xpos,ypos,10,10);
  }
}
