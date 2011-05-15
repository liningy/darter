import processing.video.*;

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

    
void setup() {
  //background(51);
  
  size(640, 480); // Change size to 320 x 240 if too slow at 640 x 480
  // Uses the default video input, see the reference if this causes an error
  video = new Capture(this, width, height, 30);
  noStroke();
  smooth();
  
  spots.add(spot);
  imagewithSpots=createImage(width,height,RGB);
  
  //different application
}

void draw() {      
  //background(51);
  
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
      
      for(int m=constrain(x-40,0,x-40);m<constrain(x+40,x+40,width);m++){
        for(int n=constrain(y-40,0,y-40);n<constrain(y+40,y+40,height);n++){
          color black = color(0);
          imagewithSpots.pixels[n*width+m]=black;
        }
      }      
    }

    imagewithSpots.updatePixels();
    
    background(51); //background is here to prevent screen refreshing effect
    image(imagewithSpots,0,0);  //draw the black squared overlayed image on the screen
    //image(video, 0, 0, width, height); // Draw the webcam video onto the screen

    int index = 0;
    //we are finding brightest spot from black square overlayed image, not directly from the video. Hence, the former brightest spot will be hided 
    //to prevent the same spot being detected twice
    if(isHit){
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
    }

    fill(123,210,20);
    //ellipse(brightestX, brightestY,20,20);
    
    //this is the draw Function, draw effects on the screen
    for(int i=0;i<spots.size()-1;i++){
      PVector temp=(PVector)spots.get(i);    
      int y=(int)temp.y;
      int x=(int)temp.x;
      ellipse(x,y,20,20);  
    }
  }
  
  //application

}

void keyPressed(){
   isHit=true;  
}
