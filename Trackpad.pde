/* 
 * From SimpleOpenNI NITE Slider2d example
 * Processing Wrapper for the OpenNI/Kinect library
 * http://code.google.com/p/simple-openni
 * prog:  Max Rheiner / Interaction Design / zhdk / http://iad.zhdk.ch/
 * date:  03/28/2011 (m/d/y)
 */

class Trackpad 
{
  int xRes;
  int yRes;
  int width;
  int height;

  boolean active;
  PVector center;
  PVector offset;

  int space; 
  int focusX;
  int focusY;
  int selX;
  int selY;
  int dir;

  int currentAlpha;
  int activeItems;

  long _now, _sendAt = 0;
  boolean[][] selected;

  IRDevice device;
  Date d = new Date();

  public Trackpad(PVector center, int xRes, int yRes, int width, int height, int space, IRDevice device) 
  {
    this.currentAlpha = 255;
    this.activeItems = 0;
    this.xRes = xRes;
    this.yRes = yRes;
    this.width = width;
    this.height = height;
    active = false;
    this.center = center.get();
    offset = new PVector();
    offset.set(-(float)(xRes * width + (xRes - 1) * space) * .5f, - (float)(yRes * height + (yRes - 1) * space) * .5f, 
    0.0f);
    offset.add(this.center);
    this.space = space;
    this.selected = new boolean[yRes][xRes];
    this.device = device;
  }   

  void setAlpha(int alpha) 
  {
    this.currentAlpha = alpha;

    if (this.currentAlpha < 0)
      this.currentAlpha = 0;

    if (this.currentAlpha > 255)
      this.currentAlpha = 255;
  }

  int getAlpha() 
  {
    return this.currentAlpha;
  }

  void enable() 
  {
    active = true;
    focusX = -1;
    focusY = -1;
    selX = -1;
    selY = -1;
  }

  void update(int indexX, int indexY) 
  {
    focusX = indexX;
    focusY = (yRes - 1) - indexY;
  }

  void push(int indexX, int indexY, int dir) 
  {
    d = new Date();
    _now = d.getTime(); 
    if (_now - _sendAt > 1000) //bloqueia por um segundo o push
    {
      selX = indexX;
      selY = (yRes - 1) - indexY;
      this.dir = dir;
      activeItems++;
      selected[selY][selX] = true;    

      this.draw();
      if (device != null)
      {
        device.transmit(Integer.toString((selY * 5) + selX)); 
        d = new Date();
        _sendAt = d.getTime();
      }

      if (activeItems >= 2)
      {
        selected = new boolean[yRes][xRes];
        activeItems = 0;
      }
    }
  }

  void disable() 
  {
    active = false;
    selected = new boolean[yRes][xRes];
    activeItems = 0;
  }

  void draw() 
  {
    pushStyle();
    pushMatrix();
    translate(offset.x, offset.y);
    int k = 0;
    for (int y = 0; y < yRes; y++) {
      for (int x = 0; x < xRes; x++) {
        if (active && (selX == x) && (selY == y) || (selected[y][x])) { // selected object 
          fill(204, 102, 0, currentAlpha - 20);
          strokeWeight(1);
          stroke(204, 102, 0, 220);
        } 
        else if (active && (focusX == x) && (focusY == y)) { // focus object 
          fill(134, 1, 199, currentAlpha + 20);
          strokeWeight(1);
          stroke(134, 1, 199, 220);
        } 
        else if (active) { // normal
          fill(0, 0, 0, 60);
          strokeWeight(1);
          stroke(0, 0, 0, 190);
        } 
        else {
          noFill();
          strokeWeight(1);
          stroke(0, 0, 0, 60);
        }
        rect(x * (width + space), y * (width + space), width, height);
        fill(255, 255, 255, currentAlpha);
        textSize(56);
        text(String.valueOf(k), (x * (width + space)) + width / 2 - 25, (y * (width + space)) + height / 2 - 25, width, height);
        k++;
      }
    }
    popMatrix();
    popStyle();
  }
}

