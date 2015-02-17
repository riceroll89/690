int mode;
int galleryWidth, galleryHeight, sectionWidth;
ArrayList<Button>;
Button left, right;
void setup() {
  orientation(LANDSCAPE);
  mode = 0;
  sectionWidth = galleryWidth/5;
  images = new ArrayList<Button>;
  images.add(new Button(""));
  resizeImages(int section);
}

void resizeImages(int sectionWidth){
  for(int i = 0; images.size(

}

void draw() {
  background(0);
  if (mode ==0) {
    drawMode0();
    gallery();
  } else {
    drawMode1();
    zoom();
  }
}

void drawMode0() {
  int startingLocation = width/50;
  int spacing = width/50;
  int columnWidth;

  for (int i = 0; i < images.size - 1; i++) {
  }
}
void drawMode1() {
}
void gallery() {
}
void zoom() {
}

public class Button {
  PImage img;
  float x, y, w, h;
  public Button(String path) {
    img = loadImage(path);
  }

  void setPosition(int x, int y) {
    this.x = x;
    this.y = y;
  }
  void setSize(int w, int h) {
    this.w = w;
    this.h = h;
  }
  boolean press(int x, int y) {
    if (x < this.x + width && x > this.x) {
      if (y > this.y && y < this.y + height) {
        return true;
      }
    }
    return false;
  }
  public void focus() {
    float currentWidth = image.width, currentHeight = image.height;
    float expand = .1.05f;
    while (currentWidth * exand < maxWidth || currentHeight * expand < height) {
      currentWidth = currentWidth * expand;
      currentHeight = currentHeight * expand;
    }
    setSize((int)currentWidth, (int)currentHeight);
  }

  public void unfocus(float maxWidth) {
    float currentWidth = image.width, currentHeight = image.height;
    float shrink = .95f;
    while (currentWidth * shrink > maxWidth || currentHeight * shrink > height) {
      currentWidth = currentWidth * shrink;
      currentHeight = currentHeight * shrink;
    }
    setSize((int)currentWidth, (int)currentHeight);
  }
}
