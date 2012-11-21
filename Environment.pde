/*
 * Environment
 * @author Jonathan Simon Prates (jonathan.simonprates@gmail.com)
 */

import fullscreen.*;
import JMyron.*;

public class Environment
{
  private boolean fullscreen = true;
  private int screenWidth = 1440;
  private int screenHeight = 900;
  private int framerate = 30;
  private PImage backgroundImage;
  private JMyron capture;
  private boolean userFocus = false;
  private PApplet pApplet = null;

  public void setUserFocus(boolean value) 
  {
    this.userFocus = value;
  }

  public boolean getUserFocus() 
  {
    return this.userFocus;
  }

  private void setupFullScreen()
  {  
    if (this.fullscreen) 
    {
      FullScreen fs = new FullScreen(this.pApplet);
      fs.setResolution(this.screenWidth, this.screenHeight);
      fs.enter();
    }
  }

  private void setupCapture() 
  {     
    capture = new JMyron();
    capture.start(640, 480);
    capture.settings();
    capture.findGlobs(0);
  }

  public void update()
  {    
    this.capture.update();
    this.capture.imageCopy(backgroundImage.pixels);                       
    this.backgroundImage.updatePixels();
    image(this.backgroundImage, 0, 0, this.screenWidth, this.screenHeight);
  }

  private void setup() 
  {
    noCursor();
    size(this.screenWidth, this.screenHeight);
    frameRate(this.framerate);
    this.backgroundImage = createImage(640, 480, RGB);
    this.setupFullScreen();
    this.setupCapture();
  } 

  public void stop()
  {
    this.capture.stop();
    this.capture = null;
    this.backgroundImage = null;
  }  

  private void init() 
  {
    this.setup();
    this.update();
  }

  public Environment(PApplet app)
  {
    this.pApplet = app;
    this.init();
  }

  public Environment(PApplet app, boolean useFullscreen)
  {
    this.pApplet = app;
    this.fullscreen = useFullscreen;
    this.init();
  }

  public Environment(PApplet app, int width, int height, int frameRate, boolean useFullscreen)
  {
    this.pApplet = app;
    this.screenWidth = width;
    this.screenHeight = height;
    this.framerate = frameRate;
    this.fullscreen = useFullscreen;
    this.init();
  }
}

