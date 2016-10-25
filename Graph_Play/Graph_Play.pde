/* *
 -----------------------
 ---- Jasper Dorman ----
 ------- 10/2016 -------
 ---- Version 1.3.0-----
 -----------------------
 */

// Import Libraries
import ddf.minim.*;
import ddf.minim.ugens.*;
import ddf.minim.analysis.*;

// establish the minim library
Minim minim;

// for playing back
AudioPlayer player;

// establishes a file reader
BufferedReader reader;

// string variable for current line of txt file
String line;

// string array for importing and spliting the contents of the txt file
String[] trackLength;

// interger for the leeway either side the one second line
int greenZone = 20;
int mappedSecond;

// float variable
float avgSecond;

// colour variables
color white;
color black;
color strokeColour;

void setup() {
  
  // initialise the program in fullscreen with the P2D renderer on the secondary screen
  fullScreen(P2D,2); 
  // initialise the minim library
  minim = new Minim(this);
  // set the colour mode to HSB, with the max variables for the HSBA respectively
  colorMode(HSB, 360, 100, 100, 100);
  // establish the colours here because it is after setting the colour mode
  black = color(0, 0, 0, 100);
  white = color(0, 0, 100, 100);
  strokeColour = color(188, 100, 100, 20);
}

void draw() {

  background(white);
  // try to open the txt file and read the line
  try {
    reader = createReader("/Volumes/My Book Thunderbolt Duo/Personal/Visual Arts and Design/MEDA/MEDA102/Assessment 3 Output on Input/Record/trackLength.txt");
    line = reader.readLine();
  } 
  // if returns a exception set line to null
  catch (IOException e) {
    e.printStackTrace();
    line = null;
  }
  // if line equals null do nothing (probably could but a close() function but thats just annoying
  if (line == null) {
    
  // split all elements that are in the line using a  comma as the separator and assign each a position in the array
  } else {
    trackLength = split(line, ",");
    drawGraph();
  }
  drawOverlay();
}


void drawGraph() {
  
  // for each element in the array i.e. the number of iterations recorded execute the following (minus one because the split function returns zero for the last comma in the file
  for (int j = 0; j < trackLength.length - 1; j++) {
    // the average second for the track equals its length divided by 20, for the 20 seconds they counted
    avgSecond = int(trackLength[j])/20;
    // map this second across the width of the screen ( the max limit for the average second is 2000 because the max record length is 40 seconds so divide that by two and viola
    mappedSecond = int(map(avgSecond, 0, 2000, 0, width));
    // if the mapped second is outside the green zone then set colour to red
    if (mappedSecond > width/2 + greenZone || mappedSecond < width/2 - greenZone) {
      strokeColour = color(360, 100, 100, 30);
    // if inside the green zone set colour to green
    } else {

      strokeColour = color(125, 100, 100, 30);
    }
    strokeWeight(20);
    stroke(strokeColour);
    // draw line from top to bottom at the x pos of the mapped second
    line(mappedSecond, 0, mappedSecond, height);
  }
}

// bunch of code that draws two lines top and bottom to mark where one second is + some rotated text
void drawOverlay() {

  stroke(black);
  strokeWeight(2);
  line(width/2, 100, width/2, 150);
  line(width/2, height - 150, width/2, height - 100);
  textSize(18);
  textAlign(CENTER, CENTER);
  fill(black);
  pushMatrix();
  translate(width/2 + 5, 45);
  rotate(PI/2);
  text("1 second", 0, 0);
  popMatrix();
  pushMatrix();
  translate(width/2 - 5, height - 45);
  rotate(-PI/2);
  text("1 second", 0, 0);
  popMatrix();
}