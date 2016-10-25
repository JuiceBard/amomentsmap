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
import java.awt.Toolkit;
import ddf.minim.analysis.*;

// establish a file writer
PrintWriter trackLength;

// establish the minim library
Minim minim;

// for recording
AudioInput in;
AudioRecorder recorder;

// for playing back
AudioOutput out;
FilePlayer player;
AudioPlayer cmon;

// integer variables
int i;
int step = 1;
int currentTime;
int recordLength;
int playLength;
int playTrackStart;

// boolean variables(true or false)
boolean playing = false;
boolean recording = false;

// establish a interger list for storing the lenghts of the audio tracks
IntList maxLength;

// string variable with instructions
String  step1 = "Press spacebar and after the thrid tone, count out-loud every second to 20 seconds and press the spacebar again";




void setup() {
  
  // initialise the program in fullscreen with the P2D renderer on the primary screen
  fullScreen(P2D, 1);
  // initialise the minim library
  minim = new Minim(this);
  // initialise the interger list
  maxLength = new IntList();
  // get a stereo line-in: sample buffer length of 2048
  // default sample rate is 44100, default bit depth is 16
  in = minim.getLineIn(Minim.STEREO, 2048);
  // initialise the text file writer
  trackLength = createWriter("trackLength.txt");
  // get an output we can playback the recording on
  out = minim.getLineOut( Minim.STEREO );
}

void draw() {
  
  // relocate the zero point to the middle of the screen
  translate(width/2, height/2 - 20);
  background(0);
  smooth();
  noStroke();
  // catch the current system time
  currentTime = millis();
  // if the program is on the first step then display the instructions
  if (step == 1) {
    
    fill(255);
    textAlign(CENTER, CENTER);
    text(step1, 0, - 150);
  // if recording display the recording symbol
  } else if (recording == true) {
    
    recordCircle();
  // if playing display the play symbol
  } else if (playing == true) {
    
    playTri();
  }
  // if recording and the record length exceeds 40 seconds, then stop recording
  if (recording == true && currentTime - recordLength > 40000) {

    text("RECORDING STOPPED", 0, - 150);
    endRecord();
  // if playing then wait for the longest track to finish playing
  } else if (playing == true && currentTime - playTrackStart > playLength) {

    playing = false;
    step = 1;
  }
}
void keyPressed() {
  
  // unless playing execute the following
  if (key == ' ' && playing == false) {
    switch (step) {
    case 1:
      // on step one play three tones exactly one second apart and start recording
      Toolkit.getDefaultToolkit().beep();
      delay(1000);
      Toolkit.getDefaultToolkit().beep();
      delay(1000);
      Toolkit.getDefaultToolkit().beep();
      recording = true;
      startRecord();
      break;
    case 2:
      // on step two, end recording
      endRecord();
      break;
    }
  }
}

void startRecord() {
  
  // create a new recorder with the current iteration as an index, and as an input from a microphone
  recorder = minim.createRecorder(in, "myrecording" + i +".wav");
  // catch the current run time (for checking record length)
  recordLength = millis();
  // start recording
  recorder.beginRecord();
  // increase step by one
  step++;
}

void endRecord() {
  
  // stop recording
  recorder.endRecord();
  // save recording under the player variable
  player = new FilePlayer( recorder.save() );
  // add the track length to the interger list
  maxLength.append(player.length());
  // add the track length to the text file, with a comma as the separator character between entries
  trackLength.print(player.length() + ",");
  // make sure it has been written to the file correctly
  trackLength.flush();
  // get the longest track length from the list of track lengths and set it to the playLength (for determining when playing has finished)
  playLength = maxLength.max();
  recording = false;
  i++;
  // execute the play function
  play();
}

void play() {

  playing = true;
  // catch the current run time (for checking when the track started to play)
  playTrackStart = millis();
  // play all tracks from all iterations so far
  for (int j = 0; j < i; j++) {
    cmon = minim.loadFile("myrecording" + j +".wav");
    cmon.play();
  }
}

// function to display the play symbol with a cool glow effect
void playTri() {

  fill(0, 255, 0);
  stroke(0, 255, 0);
  triangle(-15, -15, 15, 0, -15, 15);
  filter(BLUR, 6);
  triangle(-10, -10, 5, 0, -10, 10);
}

// function to display the record symbol with a cool glow effect
void recordCircle() {

  fill(255, 0, 0);
  stroke(255, 0, 0);
  ellipse(0, 0, 25, 25);
  filter(BLUR, 6);
  ellipse(0, 0, 20, 20);
}