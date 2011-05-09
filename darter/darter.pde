/**
 * Brightness Tracking 
 * by Golan Levin. 
 * 
 * Tracks the brightest pixel in a live video signal. 
 */


import processing.video.*;

Capture video;
int brightestX = 0; // X-coordinate of the brightest video pixel
int brightestY = 0; // Y-coordinate of the brightest video pixel
int oldbrightestX = 0; // X-coordinate of the brightest video pixel
//int oldbrightestY = 0; // Y-coordinate of the brightest video pixel

boolean isHit=false;

ArrayListX xpositions;
ArrayListY ypositions;

    
void setup() {
  size(640, 480); // Change size to 320 x 240 if too slow at 640 x 480
  // Uses the default video input, see the reference if this causes an error
  video = new Capture(this, width, height, 30);
  noStroke();
  smooth();
  for(int i=0;i<width;i++){
    xpositions.add(i);
  }
  for(int j=0;j<height;j++){
    yposition.add(j);
  }
}

void draw() {      
  //background(51);

  if (video.available()) {
    oldbrightestX = brightestX;
    video.read();
    image(video, 0, 0, width, height); // Draw the webcam video onto the screen
    float brightestValue = 0;
    video.loadPixels();
    int index = 0;
    if(isHit){
      for (int y = 0; y < video.height; y++) {
        for (int x = 0; x < video.width; x++) {
          // Get the color stored in the pixel
          int pixelValue = video.pixels[index];
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
          isHit=false;
          
        }
      }
    }
//    int delta = brightestX - oldbrightestX;
//    if (abs(delta) > 40) {
//      if (delta > 0)
//        println("Right");
//      else
//        println("Left");
//    }

    fill(123,210,20);
    ellipse(brightestX, brightestY,20,20);
  }
}

void keyPressed(){
   isHit=true;
  
}
