import android.content.res.AssetManager;
import android.media.SoundPool;
import android.media.AudioManager;
import apwidgets.*;
import android.text.InputType;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputMethodManager;
import android.content.Context;
import android.os.Environment;
import java.io.*;
PImage image;
int mode;
float galleryWidth, galleryHeight, sectionWidth, spacing, mousX, mousY;
int selectedIndex, leftMost, rightMost;
ArrayList<Button> images;
Button left, right;
boolean mouseDown;

//project 2.5
APWidgetContainer editBar;
APButton save;
APButton cancel;
APEditText textEdit;
boolean isVisible = false;
ArrayList<String> fileString;

SoundPool sounds;
int soundLoc;

void playSound() {
  int k = sounds.play(soundLoc, 1, 1, 0, 0, 1);
}
//project 2.5

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
  images = new ArrayList<Button>();


  sounds = new SoundPool(5, AudioManager.STREAM_MUSIC, 0);
  left = new Button("arrowleft.png");
  right = new Button("arrowright.png");
  leftMost = 0;
  rightMost = images.size() - 1;

  speed = (sectionWidth + spacing)/frames;
  zoomSpeed = width/frames;

  //project 2.5
  editBar = new APWidgetContainer(this);
  textEdit = new APEditText((int)width - (int)spacing * 10, (int)spacing * 3, (int)spacing *10, (int)spacing * 2);
  save = new APButton((int)(width * .92), (int)(spacing * .5), "Save");
  cancel = new APButton ((int)(width * .82), (int)(spacing * .5), "Cancel");
  editBar.addWidget(save);
  editBar.addWidget(cancel);
  editBar.addWidget(textEdit);

  textEdit.setTextSize(30);
  editBar.hide();

  textEdit.setImeOptions(EditorInfo.IME_FLAG_NO_EXTRACT_UI);

  // get/create directory in internal storage

  File sketchDir = getFilesDir();
  fileString = new ArrayList<String>();

  // read strings from file into s
  try {
    //We can also use Processing's loadStrings() method:
    //s = new ArrayList<String>(Arrays.asList(loadStrings(
    //  sketchDir.getAbsolutePath() + "/inFile.txt")));

    FileReader input = new FileReader(sketchDir.getAbsolutePath() + "/inFile.txt");
    BufferedReader bInput = new BufferedReader(input);
    String ns = bInput.readLine();
    while (ns != null) {
      fileString.add(ns);
      ns = bInput.readLine();
    }
    bInput.close();
    /*    textSize(40);
     int offY = 50;
     text("Read: " + s.size(), width/4, offY);
     for (int i=0; i<s.size (); i++) {
     offY += 50;
     text(s.get(i), width/4, offY);
     }*/
  }
  catch (Exception e) {
    textSize(40);
    text("File not found", width/4, 50);
  }
  loadImgs();
  resizeImages(sectionWidth, galleryHeight);
  handleArrows(galleryWidth, galleryHeight);
}
void onClickWidget(APWidget widget) {
  if (widget == save) {
    images.get(selectedIndex).addTag(textEdit.getText());
  } else if (widget == cancel) {
    hideVirtualKeyboard();
  } else if (widget == textEdit) {
    isVisible = !isVisible;

    if (isVisible) {
      showVirtualKeyboard();
    } else {
      hideVirtualKeyboard();
    }
  }
}
void showVirtualKeyboard() {
  InputMethodManager imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
  imm.toggleSoftInput(InputMethodManager.SHOW_FORCED, 0);
}
void hideVirtualKeyboard() {
  InputMethodManager imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
  imm.toggleSoftInput(InputMethodManager.HIDE_IMPLICIT_ONLY, 0);
}
void saveToFile() {
  //We can also use Processing's saveStrings() method:
  //saveStrings(sketchDir.getAbsolutePath() + "/inFile.txt", 
  //s.toArray(new String[s.size()]));

  File sketchDir = getFilesDir();

  java.io.File outFile;
  try {
    println("Saved to: " + sketchDir.getAbsolutePath());
    outFile = new java.io.File(sketchDir.getAbsolutePath() + "/inFile.txt");
    if (!outFile.exists())
      outFile.createNewFile();
    FileWriter outWriter = new FileWriter(sketchDir.getAbsolutePath() + "/inFile.txt");

    for (int i=0; i<images.size (); i++) {
      if (images.get(i).getTags() != null) {
        outWriter.write(images.get(i).getPath() + images.get(i).getTags() + "\n");
      }
    }
    outWriter.flush();
    outWriter.close();
  }
  catch (Exception e) {
    e.printStackTrace();
  }
}

// When app is stopped, save to file
@ Override
public void onStop() {
  println("stop");
  if (images != null)
    saveToFile();

  super.onStop();
}

File getFilesDir() {
  File extDir = Environment.getExternalStorageDirectory();
  String sketchName = this.getClass().getSimpleName();
  return extDir;
}

void loadTags(String path) {
  int i;
  if (fileString.contains(path)) {
    i = fileString.indexOf(path); 
    while (fileString.get (i).contains(".png")|| fileString.get(i).contains(".jpg")) {
      images.get(images.size() - 1).addTag(fileString.get(i));
      i++;
    }
  }
}
void loadImgs() {
  String [] fileNames; 
  fileNames = new String[2];
  AssetManager am = getAssets();
  // load the files from Image folder 
  try {
    fileNames = am.list("images");  // am - returns array of file names
  } 
  catch (IOException e) {
    print("Error, cannot find image!"); 
    return;
  }
  // loads the entire collection of images into an array
  for (int k = 0; k < fileNames.length; k++) {
    if (fileNames.length >= 1 && fileNames[k].endsWith(".png")) {
      images.add(new Button("images/" + fileNames[k]));
      loadTags("images/" + fileNames[k]);
    } else if (fileNames[k].endsWith(".wav") || fileNames[k].endsWith(".mp3")) {
      try {
        soundLoc = sounds.load(am.openFd("images/" + fileNames[k]), 0);
      }
      catch(IOException e) {
      }
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
/*void mousePressed() {
 mouseDown = true;
 mousX = mouseX;
 mousY = mouseY;
 checkMouse(mouseX, mouseY);
 }*/
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
  background(175);
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

  images.get(selectedIndex).render(galleryWidth, galleryHeight, true);
  editBar.show();
}
void galleryInput(int x, int y) {
  //if (mouseDown) {
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
      playSound();
    }
  }
  if (currentFrame < 0) {
    if (right.check(x, y)) {
      currentFrame = frames*5;
      movingLeft = false;
      playSound();
    }
  }
  //}
}
void zoomInput(int x, int y) {
  if (currentFrame < 0) {  

    if (left.check(x, y)) {
      selectedIndex--;
      playSound();
      if (selectedIndex < 0) {
        selectedIndex = images.size() - 1;
      }
      images.get(selectedIndex).zoomIn(galleryWidth, galleryHeight);
    } else if (right.check(x, y)) {
      selectedIndex++;
      playSound();
      if (selectedIndex == images.size()) {
        selectedIndex = 0;
      }
      images.get(selectedIndex).zoomIn(galleryWidth, galleryHeight);
    } else {
      mode = 0;
      for (int i = 0; i < images.size (); i++) {
        images.get(i).zoomOut(sectionWidth, galleryHeight);
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
  String tags;
  String original;
  PImage image;
  float x, y, w, h;
  public Button(String path) {
    image = loadImage(path);
    x = 0;
    y = 0;
    w = image.width;
    h = image.height;

    original = path;
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
      if (tags != null) {
        textSize(45);
        text(tags, 20, 50);
      }
    } else {
      image(image, x, y, this.w, this.h);
    }
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

  void addTag(String newTag) {
    if (tags != null) {
      tags = tags + ", " + newTag;
    } else {
      tags = newTag;
    }
  }

  String getTags() {
    return tags;
  }
  String getPath() {
    return original;
  }
}
