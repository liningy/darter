import processing.video.*;
import processing.serial.*;

Serial myPort;  // Create object from Serial class
int val;      // Data received from the serial port

Capture video;
int brightestX = 0; // X-coordinate of the brightest video pixel
int brightestY = 0; // Y-coordinate of the brightest video pixel
int oldbrightestX = 0; // X-coordinate of the brightest video pixel
//int oldbrightestY = 0; // Y-coordinate of the brightest video pixel


boolean isHit=false;

PVector spot=new PVector(0,0);   //spot is a vector, which instored current detected brightest spot
ArrayList spots=new ArrayList(); //spots is a vital ArrayList, whth all brightest spots stored one after another
PImage imagewithSpots;

//different applications
boolean application_1=true;
int choice=0;
Movie waterSpring;
    
void setup() {
  background(255);
  
  size(1600,1200-200);
  //size(640, 480); // Change size to 320 x 240 if too slow at 640 x 480
  // Uses the default video input, see the reference if this causes an error
  video = new Capture(this, 640, 480, 30);
  noStroke();
  //noLoop();
  smooth();
  
  spots.add(spot);
  imagewithSpots=createImage(video.width,video.height,RGB);
  
  //Serial Read
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
  
  //different application
  //1
  waterSpring=new Movie(this, "waterspring.wav");
   println(Serial.list());
}

void draw() { 

  if ( myPort.available() > 0) {  // If data is available,
    val = myPort.read();         // read it and store it in val
    println(val);
  }
  
  if(val==1){
     isHit=true;  
     val=0;
  }  
  if (video.available()) {
    oldbrightestX = brightestX;
    video.read();
    float brightestValue = 0;
    video.loadPixels();
    imagewithSpots.loadPixels();
    imagewithSpots.copy(video,0,0,video.width,video.height,0,0,video.width,video.height);
    imagewithSpots.updatePixels();

    //get brightest spots and cover them with black squares
    for(int i=0;i<spots.size()-1;i++){
      PVector temp=(PVector)spots.get(i);    
      int y=(int)temp.y;
      int x=(int)temp.x;
      
      for(int m=constrain(x-20,0,x-20);m<constrain(x+20,x+20,video.width);m++){
        for(int n=constrain(y-20,0,y-20);n<constrain(y+20,y+20,video.height);n++){
          color black = color(0);
          imagewithSpots.pixels[n*video.width+m]=black;
        }
      }      
    }

    imagewithSpots.updatePixels();
    
    background(255); //background is here to prevent screen refreshing effect
    image(imagewithSpots,0,0);  //draw the black squared overlayed image on the screen
    //image(video, 0, 0, width, height); // Draw the webcam video onto the screen

    int index = 0;
    //we are finding brightest spot from black square overlayed image, not directly from the video. Hence, the former brightest spot will be hided 
    //to prevent the same spot being detected twice
    if(isHit){
      choice=(int)random(0,2);
      //println(choice);
      for (int y = 0; y < video.height; y++) {
        for (int x = 0; x < video.width; x++) {
          // Get the color stored in the pixel
          int pixelValue = imagewithSpots.pixels[index];
          // Determine the brightness of the pixel
          float pixelBrightness = brightness(pixelValue);
          // If that value is brighter than any previous, then store the
          // brightness of that pixel, as well as its (x,y) location
          if (pixelBrightness > brightestValue) {
            brightestValue = pixelBrightness;
            brightestY = y;
            brightestX = x;
          }
          index++; 
        }
      }
      isHit=false;
      
      spot.x=brightestX;
      spot.y=brightestY;
      
      //spots.add(spot);
      PVector temp=new PVector(brightestX, brightestY);
      spots.add(temp);
      
      if(application_1){
        waterSpring.stop();
        waterSpring.play();
      }
    }

    //fill(123,210,20);
    //ellipse(brightestX, brightestY,20,20);
    
    //this is the draw Function, draw effects on the screen 
//    for(int i=0;i<spots.size()-1;i++){
//      PVector temp=(PVector)spots.get(i);    
//      int y=(int)temp.y*height/video.height;
//      int x=(int)temp.x*width/video.width;
//      if(choice==0) drawCirle_1(x,y);
//      else          drawCirle_2(x,y);
//    }
  }
  
  
  
  //application 1: draw water spring bubbles
  int y=(int)spot.y*height/video.height;
  int x=(int)spot.x*width/video.width;
  if(x!=0){
    if(choice==0) {
      //drawCirle_1(x,y);
    }
    else{
      //drawCirle_2(x,y);
    }
  }  
}

void keyPressed(){
   isHit=true;  
}


//application 1: draw water spring bubbles
void drawCirle_1(int x, int y){
    smooth();

  fill(0);
  ellipse(x,y, 240,240);
  fill(255);
  ellipse(x,y,120,120);
  fill(0);
  ellipse(x,y,60,60);
}

void drawCirle_2(int x, int y){
  fill(0);
  ellipse(x,y,120,120);
  fill(255);
  ellipse(x,y,60,60);
}
