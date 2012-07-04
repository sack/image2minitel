//Video2Minitel
//by Renaud, Fabrice & Phil
//Inspired from Video2ledwallHarpSerial V1.0 by Fabrice Fourc
// http://www.tetalab.org


import processing.video.*;
import processing.net.*;
int plage=44;//256;
int MINITEL_CHAR_WIDTH = 40;//*2;
int MINITEL_CHAR_HEIGHT = 24;//*4;
	// en fait ce n'est pas vraiment un pixel par pixel char...
int PIXEL_CHAR_WIDTH = 2;
int PIXEL_CHAR_HEIGHT = 3;
	
// Size of each cell in the grid, ratio of window size to video size
int videoScale = 10;
int videoScalex = 8;
int videoScaley = 6;



// Number of columns and rows in our system
int cols, rows;
// Variable to hold onto Capture object
public int s = 50;
import processing.serial.*;

// The serial port:
Serial myPort;

//luminosite globale de la colone pour le son
int colValue;
String ledCol;
String ledWallMsg;

//Client myClient;
Capture video;

PImage b;
PImage img;



void setup() 
{
  size(MINITEL_CHAR_WIDTH*PIXEL_CHAR_WIDTH*videoScalex,MINITEL_CHAR_HEIGHT*PIXEL_CHAR_HEIGHT*videoScaley);
  frameRate(25);
  
  // List all the available serial ports:
  println(Serial.list());

b = loadImage("2000.jpg");

  println(Serial.list());
  myPort = new Serial(this, "COM18", 1200);

  //myClient = new Client(this, "127.0.0.1", 5204);
  // Initialize columns and rows
  cols = width/videoScalex;
  rows = height/videoScaley;
  
}


//----------------------------------------------------------

void displayPixelChar2(int x, int y)
{
  x= x *2;
  y = y * 3;
  byte carac=0; // caractère pixel
  carac+=(Math.pow(2,0))*getG2(x+0,y+0);
  carac+=(Math.pow(2,1))*getG2(x+1,y+0);
  carac+=(Math.pow(2,2))*getG2(x+0,y+1);
  carac+=(Math.pow(2,3))*getG2(x+1,y+1);
  carac+=(Math.pow(2,4))*getG2(x+0,y+2);
  carac+=(Math.pow(2,5))*1;
  carac+=(Math.pow(2,6))*getG2(x+1,y+2);
  myPort.write(carac);
  println("carac= "+carac);
}

int getG2(int x,int y)
{
  println("x + y*video.width" + (x + y*cols));
  color c = b.pixels[x + y*(80)];
  int value = (int)brightness(c);  // get the brightness
  println(value);
  if (value<s)
  {
    return(0);
  }
  else 
  {
    return(1);
  }
}

void draw() {
  // Read image 
   b.loadPixels();
image(b, 0, 0);
  noStroke();

//loadPixels();

  if(!mousePressed) //si je ne clique pas, j'affiche le preview
  {
  
  }
  else //si je clique sur l'image j'envoie sur le port serie
  {
    myPort.write(12);
    myPort.write(14);
    for (int y=0;y<MINITEL_CHAR_HEIGHT;y++) 
    {
      for (int x=0;x<MINITEL_CHAR_WIDTH;x++) 
      {
        displayPixelChar2(x,y);
        println("x= "+x+"y= "+y);
      }
    }
  }
}

void keyPressed() //reglage du seuil (a-, z+)
{
 if( key == 'a') 
 {
   s = s - 1;
   println("s " + s);
 }
 if ( key == 'z')
 {
   s = s + 1;
   println("s " + s);
 }
}


