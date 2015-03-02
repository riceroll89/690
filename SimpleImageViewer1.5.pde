import android.content.res.AssetManager;
PImage image;
int mode;
float galleryWidth, galleryHeight, sectionWidth, spacing, mousX, mousY;
int selectedIndex, leftMost, rightMost;
ArrayList<Button> images;
Button left, right;
boolean mouseDown;

//project 1.5
int frames = 5;
int currentFrame = 0;
float speed;
float zoomSpeed;
boolean movingLeft;
float endx;
void update() {
  currentFrame--;
  if (currentFrame>=0) {
    move();
  }
}
void move() {
  if (movingLeft) {
    moveLeft();
  } else {
    moveRight();
  }
}
//project 1.5

void setup() {
  orientation(LANDSCAPE);
  galleryWidth = width;
  galleryHeight = height;
  mode = 0;
  sectionWidth = galleryWidth/6;
  mouseDown = false;
  spacing = galleryWidth/30;
  loadImgs();
  left = new Button("arrowleft.png");
  right = new Button("arrowright.png");
  leftMost = 0;
  rightMost = images.size() - 1;
  resizeImages(sectionWidth, galleryHeight);
  handleArrows(galleryWidth, galleryHeight);
  speed = (sectionWidth + spacing)/frames;
  zoomSpeed = width/frames;
}

void loadImgs() {
  String [] fileNames; 
  fileNames = new String[2];
  AssetManager am = getAssets();
  // load the files from Image folder 
  try {
    fileNames = am.list("images");  // am - returns array of file names
    images = new ArrayList<Button>();
  } 
  catch (IOException e) {
    print("Error, cannot find image!"); 
    return;
  }
  // loads the entire collection of images into an array
  for (int k = 0; k < fileNames.length; k++) {
    if (fileNames.length >= 1 && fileNames[k].endsWith(".png")) {
      images.add(new Button("images/" + fileNames[k]));
    }
  }
}
void resizeImages(float section, float h) {
  for (int i =0; i < images.size (); i++) {
    Button curr = images.get(i);
    curr.zoomIn(section, h);
    curr.zoomOut(section, h);

    float yLocation = h/2f - curr.getHeight()/2f;
    curr.setPosition(spacing + (i *(spacing + sectionWidth)), (int) yLocation);
  }
  endx = images.get(images.size()-1).getX();
}

void handleArrows(float w, float h) {
  float size = h/15;
  left.zoomOut(size, size);
  left.setPosition(.5*size, h - size*1.5);

  right.zoomOut(size, size);
  right.setPosition(w - 1.5*size, h - size*1.5);
}
void mousePressed() {
  mouseDown = true;
  mousX = mouseX;
  mousY = mouseY;
  checkMouse(mouseX, mouseY);
}
void mouseReleased() {
  mouseDown = false;
  checkMouse(mouseX, mouseY);
}

void checkMouse(int x, int y) {
  if (mode==0) {
    galleryInput(x, y);
  } else {
    zoomInput(x, y);
  }
}

void draw() {
  background(255);
  if (mode ==0) {
    drawMode0();
  } else {
    drawMode1();
  }
  left.render(galleryWidth, galleryHeight, false);
  right.render(galleryWidth, galleryHeight, false);
  update();
}

void drawMode0() {
  for (int i =0; i < images.size (); i++) {
    Button curr = images.get(i);
    curr.render(galleryWidth, galleryHeight, false);
  }
}
void drawMode1() {
  //for (int i = 0; i < images.size(); i++){
  images.get(selectedIndex).render(galleryWidth, galleryHeight, true);
  //}
}
void galleryInput(int x, int y) {
  if (mouseDown) {
    for (int i =0; i< images.size (); i++) {
      if (images.get(i).check(x, y)) {
        selectedIndex = i;
        mode = 1;
        images.get(selectedIndex).zoomIn(galleryWidth, galleryHeight);
        //images.get(i).zoomAll();
      }
    }
    if (currentFrame < 0) {
      if (left.check(x, y)) {
        currentFrame = frames*5;
        movingLeft = true;
      }
    }
    if (currentFrame < 0) {
      if (right.check(x, y)) {
        currentFrame = frames*5;
        movingLeft = false;
      }
    }
  }
}
void zoomInput(int x, int y) {
  if (mouseDown) {
    mode = 0;
    images.get(selectedIndex).zoomOut(sectionWidth, galleryHeight);
    if (currentFrame < 0) {
      if (left.check(x, y)) {
        currentFrame = frames*5;
        movingLeft = true;
      }
    }
    if (currentFrame < 0) {
      if (right.check(x, y)) {
        currentFrame = frames*5;
        movingLeft = false;
      }
    }
  }
}
void moveRight() {
  if (mode == 0) {
    for (int i = 0; i < images.size (); i++) {
      images.get(i).setX(images.get(i).getX() - speed);
    } 
    if (currentFrame%frames==0) {
      Button leftMostImage = images.get(leftMost);
      leftMostImage.setX(endx);
      rightMost = leftMost;
      leftMost++;
      if (leftMost == images.size()) {
        leftMost = 0;
      }
    }
  } else {
    for (int i = 0; i < images.size (); i++) {
      images.get(i).setX(images.get(i).getX() - zoomSpeed);
    }
  }
}
void moveLeft() {
  if (mode == 0) {
    for (int i = 0; i < images.size (); i++) {
      images.get(i).setX(images.get(i).getX() + speed);
    } 
    if (currentFrame%frames==0) {
      Button rightMostImage = images.get(rightMost);
      rightMostImage.setX(spacing);//moved left to location of old rightMost
      leftMost = rightMost;
      rightMost--;
      if (rightMost < 0) {
        rightMost = images.size() - 1;
      }
    }
  } else {
    for (int i = 0; i < images.size (); i++) {
      images.get(i).setX(images.get(i).getX() + zoomSpeed);
    }
  }
}

//****************************************************************************

class Button {

  float zoomX, zoomY;
  int selectedImage;

  PImage image;
  float x, y, w, h;
  public Button(String path) {
    image = loadImage(path);
    x = 0;
    y = 0;
    w = image.width;
    h = image.height;
  }

  void setPosition(float x, float y) {
    this.x = x;
    this.y = y;
  }
  void setSize(float w, float h) {
    this.w = w;
    this.h = h;
  }
  float getX() {
    return this.x;
  }
  void setX(float x) {
    this.x = x;
  }
  float getHeight() {
    return h;
  }

  boolean check(float x, float y) {
    if (this.x <= x && this.x + w >= x) {
      if (this.y <= y && this.y + h >= y) {
        return true;
      }
    }
    return false;
  }

  void render(float w, float h, boolean zoom) {
    if (zoom) {
      float zoomx, zoomy;
      zoomx = w/2 - this.w/2;
      zoomy = h/2 - this.h/2;

      image(image, zoomx, zoomy, this.w, this.h);
    } else {
      image(image, x, y, this.w, this.h);
    }
    //System.out.println("render " + w + " " + h);
  }

  void zoomIn(float w, float h) {
    float currentW = this.w, currentH = this.h;
    float expansion = 1.03f;
    while (currentW * expansion < width && currentH * expansion < height) {
      currentW = currentW * expansion;
      currentH = currentH * expansion;
    }
    setSize((int)currentW, (int)currentH);
  }
  void zoomOut(float maxWidth, float h) {
    float currentW = this.w, currentH = this.h;
    float shrink = .95f;
    // shrink to fit. 
    while (currentW * shrink > maxWidth || currentH * shrink > height) {
      currentW = currentW * shrink;
      currentH = currentH * shrink;
    }
    setSize((int)currentW, (int)currentH);
    this.y = h/2 - this.h/2;
  }

  void setZoomPosition(float x, float y) {
    zoomX = x;
    zoomY = y;
  }
  void setZoomX(float x) {
    zoomX = (int)x;
  }
  float getZoomX() {
    return zoomX;
  }

  void zoomAll() {
    int leftIndex = selectedImage - 1;
    int rightIndex = selectedImage + 1;
    if (leftIndex < 0) {
      leftIndex = images.size() - 1;
    }
    if (rightIndex == images.size()) {
      rightIndex = 0;
    }
    Button left = images.get(leftIndex);
    Button right = images.get(rightIndex);

    left.setZoomPosition(-width/2 - left.w/2, height/2 - left.h/2);
    right.setZoomPosition(width + width/2, height/2 - right.h/2);
  }
}
