/*
 * KinectRemoteControl
 * @author Jonathan Simon Prates (jonathan.simonprates@gmail.com)
 * @version 1.0     
 * from SimpleOpenNI NITE Slider2d example
 */

import SimpleOpenNI.*;

Environment environment;
IRDevice device;
Recognizer recognizer;
SimpleOpenNI kinect;
XnVSessionManager sessionManager;
XnVSelectableSlider2D trackPad;
Trackpad trackPadViz;
String command;

void setup() 
{
  environment = new Environment(this, false);
  device = new IRDevice("Onix4000");
  recognizer = new Recognizer();
  setupKinect();
  setupTrackpad(5, 2);
}

void draw()
{
  environment.update();
  kinect.update();
  kinect.update(sessionManager);

  image(kinect.depthImage(), 0, 0, 100, 100); //tests

  if (environment.getUserFocus()) {
    trackPadViz.draw();
  } 
  else {
    command = recognizer.findGesture(kinect, false);
    if (command != null) {
      device.transmit(command); 
      command = null;
    }
  }
}

void setupKinect()
{
  kinect = new SimpleOpenNI(this, SimpleOpenNI.RUN_MODE_MULTI_THREADED);
  kinect.setMirror(true);
  if (kinect.enableDepth() == false) {
    println("Testing kinect: Can't open depth"); 
    exit();
  }

  kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL); 

  if (kinect.enableRGB() == false) {
    println("Testing kinect: Can't open the RGB"); 
    exit();
  } 

  if (kinect.enableGesture() == false) {
    println("Testing kinect: Can't enable gestures"); 
    exit();
  }

  if (kinect.enableHands() == false) {
    println("Testing kinect: Can't enable hands"); 
    exit();
  }

  sessionManager = kinect.createSessionManager("Wave", "Wave");
  sessionManager.SetQuickRefocusTimeout(2000);
}

void setupTrackpad(int columns, int lines)
{
  float buttonWidth = environment.screenWidth  * 0.18;
  float buttonHeight = environment.screenHeight  * 0.18;
  trackPad = new XnVSelectableSlider2D(columns, lines);
  trackPad.RegisterItemHover(this);
  trackPad.RegisterValueChange(this);
  trackPad.RegisterItemSelect(this);
  trackPad.RegisterPrimaryPointCreate(this);
  trackPad.RegisterPrimaryPointDestroy(this);
  trackPadViz = new Trackpad(new PVector(environment.screenWidth / 2, environment.screenHeight / 2 - 50, 0), columns, lines, (int) buttonWidth, (int) buttonHeight, 15, device);
  sessionManager.AddListener(trackPad);
}

public void stop() {
  environment.stop();
  super.stop();
}

// NITE session callbacks
void onStartSession(PVector pos) {
  environment.setUserFocus(true);
}

void onEndSession() {
  environment.setUserFocus(false);
}

void onFocusSession(String strFocus, PVector pos, float progress) {
  // println("onFocusSession: focus=" + strFocus + ",pos=" + pos + ",progress=" + progress);
}

// XnVSelectableSlider2D callbacks
void onValueChange(float fXValue, float fYValue) {
  // println("onValueChange: fXValue=" + fXValue +" fYValue=" + fYValue);
}

void onItemHover(int nXIndex, int nYIndex)
{
  //println("onItemHover: nXIndex=" + nXIndex +" nYIndex=" + nYIndex);
  trackPadViz.update(nXIndex, nYIndex);
}

void onItemSelect(int nXIndex, int nYIndex, int eDir)
{
  // println("onItemSelect: nXIndex=" + nXIndex + " nYIndex=" + nYIndex + " eDir=" + eDir);
  trackPadViz.push(nXIndex, nYIndex, eDir);
}

void onPrimaryPointCreate(XnVHandPointContext pContext, XnPoint3D ptFocus)
{
  println("onPrimaryPointCreate");
  environment.setUserFocus(true);
  trackPadViz.enable();
}

void onPrimaryPointDestroy(int nID)
{
  println("onPrimaryPointDestroy");
  environment.setUserFocus(false);
  trackPadViz.disable();
}

void onNewUser(int userId)
{
  println("onNewUser - userId: " + userId);
  println("  start pose detection");
  kinect.startPoseDetection("Psi", userId);
}
void onLostUser(int userId)
{
  println("onLostUser - userId: " + userId);
}

void onStartCalibration(int userId)
{
  println("onStartCalibration - userId: " + userId);
}

void onEndCalibration(int userId, boolean successfull)
{
  println("onEndCalibration - userId: " + userId + ", successfull: " + successfull);
  println(successfull);
  if (successfull) 
  { 
    println("  User calibrated !!!");
    kinect.startTrackingSkeleton(userId);
  } 
  else 
  { 
    println("  Failed to calibrate user !!!");
    println("  Start pose detection");
    kinect.startPoseDetection("Psi", userId);
  }
}

void onStartPose(String pose, int userId)
{
  println("onStartPose - userId: " + userId + ", pose: " + pose);
  println(" stop pose detection");

  kinect.stopPoseDetection(userId); 
  kinect.requestCalibrationSkeleton(userId, true);
}

void onEndPose(String pose, int userId)
{
  println("onEndPose - userId: " + userId + ", pose: " + pose);
}

