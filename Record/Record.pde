
import ddf.minim.*;
import ddf.minim.ugens.*;
import java.awt.Toolkit;
import ddf.minim.analysis.*;

PrintWriter audioTracks;
PrintWriter trackLength;
Minim minim;

// for recording
AudioInput in;
AudioRecorder recorder;

int i;
int step = 1;
int currentTime;
int recordLength;
int playLength;
int playTrackStart;
color bg = color(0);
boolean playing = false;
boolean recording = false;

IntList maxLength;
String  step1 = "Press the spacebar and after the third tone, count every second to 20 seconds and press the spacebar again";


// for playing back
AudioOutput out;
FilePlayer player;
AudioPlayer cmon;


void setup()
{
  fullScreen(P2D,1);

  minim = new Minim(this);
  maxLength = new IntList();
  // get a stereo line-in: sample buffer length of 2048
  // default sample rate is 44100, default bit depth is 16
  in = minim.getLineIn(Minim.STEREO, 2048);
  trackLength = createWriter("trackLength.txt");

  // get an output we can playback the recording on
  out = minim.getLineOut( Minim.STEREO );
}

void draw() {

  translate(width/2, height/2 - 20);
  background(0);
  smooth();
  noStroke();
  currentTime = millis();
  if (step == 1) {
    fill(255);
    textAlign(CENTER, CENTER);
    text(step1, 0, - 150);
  } else if (recording == true) {
    fill(255, 0, 0);
    stroke(255, 0, 0);
    ellipse(0, 0, 25, 25);
    filter(BLUR, 6);
    ellipse(0, 0, 20, 20);
  } else if (playing == true){
  
    fill(0, 255, 0);
    stroke(0, 255, 0);
    triangle(-15, -15, 15, 0, -15, 15);
    filter(BLUR, 6);
    triangle(-10, -10, 5, 0, -10, 10);
  }
  if (recording == true && currentTime - recordLength > 40000) {

    text("RECORDING STOPPED", 0, - 150);
    endRecord();
  } else if (playing == true && currentTime - playTrackStart > playLength){
  
      playing = false;
      step = 1;
  } 
}
void keyPressed() {

  if (key == ' ' && playing == false) {
    switch (step) {
    case 1:
      Toolkit.getDefaultToolkit().beep();
      delay(1000);
      Toolkit.getDefaultToolkit().beep();
      delay(1000);
      Toolkit.getDefaultToolkit().beep();
      recording = true;
      startRecord();
      break;
    case 2:
      endRecord();
      break;
    }
  }
}

void startRecord() {

  recorder = minim.createRecorder(in, "myrecording" + i +".wav");
  recordLength = millis();
  recorder.beginRecord();
  
  step++;
}

void endRecord() {

  //print(step);
  recorder.endRecord();
  player = new FilePlayer( recorder.save() );
  maxLength.append(player.length());
  trackLength.print(player.length() + ",");
  trackLength.flush();
  playLength = maxLength.max();
  recording = false;
  //audioTracks.print(i + "|");
  //audioTracks.flush();
  i++;
  play();
}

void play() {
  
  playing = true;
  playTrackStart = millis();
  for (int j = 0; j < i; j++) {
    cmon = minim.loadFile("myrecording" + j +".wav");
    cmon.play();
  }


}