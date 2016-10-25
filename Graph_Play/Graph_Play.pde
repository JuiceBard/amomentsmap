import ddf.minim.*;
import ddf.minim.ugens.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer player;

BufferedReader reader;

String line;
String[] trackLength;

int greenZone = 20;
int mappedSecond;

IntList maxLength;

float avgSecond;

color white;
color black;
color strokeColour;

void setup() {
  fullScreen(P2D,2); 
  minim = new Minim(this);
  maxLength = new IntList();
  colorMode(HSB, 360, 100, 100, 100);
  black = color(0, 0, 0, 100);
  white = color(0, 0, 100, 100);
  strokeColour = color(188, 100, 100, 20);
}

void draw() {

  background(white);

  try {
    reader = createReader("/Volumes/My Book Thunderbolt Duo/Personal/Visual Arts and Design/MEDA/MEDA102/Assessment 3 Output on Input/Record/trackLength.txt");
    line = reader.readLine();
  } 
  catch (IOException e) {
    e.printStackTrace();
    line = null;
  } 
  if (line == null) {
  } else {
    trackLength = split(line, ",");
    drawGraph();
  }
  drawOverlay();
}


void drawGraph() {

  for (int j = 0; j < trackLength.length - 1; j++) {
    avgSecond = int(trackLength[j])/20;
    mappedSecond = int(map(avgSecond, 0, 2000, 0, width));
    if (mappedSecond > width/2 + greenZone || mappedSecond < width/2 - greenZone) {
      strokeColour = color(360, 100, 100, 30);
    } else {

      strokeColour = color(125, 100, 100, 30);
    }

    strokeWeight(20);
    //stroke(map(j, 0, trackLength.length, 0, 360), 100, 100, 20);
    stroke(strokeColour);
    line(mappedSecond, 0, mappedSecond, height);
  }
}

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