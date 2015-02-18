int mode;
float galleryWidth, galleryHeight, sectionWidth, spacing, mousX, mousY;
int selectedIndex, leftMost, rightMost;
ArrayList<Button> images;
Button left, right;
boolean mouseDown;
void setup() {
  orientation(LANDSCAPE);
  //size(1920, 1080);
  galleryWidth = width;
  galleryHeight = height;
  mode = 0;
  sectionWidth = galleryWidth/6;
  mouseDown = false;
  spacing = galleryWidth/30;
  images = new ArrayList<Button>();
  images.add(new Button("images/Test0.png"));
  images.add(new Button("images/Test1.png"));
  images.add(new Button("images/Test2.png"));
  images.add(new Button("images/Test3.png"));
  images.add(new Button("images/Test4.png"));
  images.add(new Button("images/Test5.png"));
  images.add(new Button("images/Test6.png"));
  images.add(new Button("images/Test7.png"));
  images.add(new Button("images/Test8.png"));
  images.add(new Button("images/Test9.png"));
  images.add(new Button("images/TestA.png"));
  images.add(new Button("images/TestB.png"));
  images.add(new Button("images/TestC.png"));
  images.add(new Button("images/TestD.png"));
  images.add(new Button("images/TestE.png"));
  images.add(new Button("images/TestF.png"));
  left = new Button("images/arrowleft.png");
  right = new Button("images/arrowright.png");
  leftMost = 0;
  rightMost = images.size() - 1;
  resizeImages(sectionWidth, galleryHeight);
  handleArrows(galleryWidth, galleryHeight);
}

void resizeImages(float section, float h) {
  for (int i =0; i < images.size (); i++) {
    Button curr = images.get(i);
    curr.unfocus(section, h);

    float yLocation = h/2f - curr.getHeight()/2f;
    curr.setPosition(spacing + (i *(spacing + sectionWidth)), (int) yLocation);
  }
}

void handleArrows(float w, float h) {
  float size = h/20;
  left.unfocus(size, size);
  left.setPosition(0, h - size);

  right.unfocus(size, size);
  right.setPosition(w - size, h - size);
}

void mousePressed() {
  mouseDown = true;
  mousX = mouseX;
  mousY = mouseY;
}

void mouseReleased() {
  mouseDown = false;
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
  float startingLocation = width/50;
  float spacing = width/50;

  for (int i =0; i < images.size (); i++) {
    Button curr = images.get(i);
    curr.render(galleryWidth, galleryHeight, false);
  }

  left.render(galleryWidth, galleryHeight, false);
  right.render(galleryWidth, galleryHeight, false);
}
void drawMode1() {
  images.get(selectedIndex).render(galleryWidth, galleryHeight, true);
}
void gallery() {
  if (mouseDown) {
    for (int i =0; i< images.size (); i++) {
      if (images.get(i).check(mousX, mousY)) {
        selectedIndex = i;
        mode = 1;
        images.get(i).focus(galleryWidth, galleryHeight);
      }
    }

    if (left.check(mousX, mousY)) {
      moveLeft();
    }

    if (right.check(mousX, mousY)) {
      moveRight();
    }
  }
}

void moveLeft() {
  float temp = images.get(rightMost).getX();
  for (int i = 0; i < images.size (); i++) {
    images.get(i).setX(images.get(i).getX() -(spacing + sectionWidth));
  } 
  Button leftMostImage = images.get(leftMost);
  leftMostImage.setX(temp);
  rightMost = leftMost;
  leftMost++;
  if (leftMost == images.size())
    leftMost = 0;
}

void moveRight() {
  float temp = images.get(leftMost).getX();
  for (int i = 0; i < images.size (); i++) {
    images.get(i).setX(images.get(i).getX() + spacing + sectionWidth);
  } 

  Button rightMostImage = images.get(rightMost);
  rightMostImage.setX(temp);//moved left to location of old rightMost
  leftMost = rightMost;
  rightMost--;
  if (rightMost < 0)
    rightMost = images.size() - 1;
}


void zoom() {
  if (mouseDown) {
    mode = 0;
    images.get(selectedIndex).unfocus(sectionWidth, galleryHeight);
  }
}


//****************************************************************************

class Button {
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

      image(image, zoomx, zoomy);
    } else
      image(image, x, y, this.w, this.h);

    System.out.println("render " + w + " " + h);
  }

  public void focus(float w, float h) {
    float tempw = this.w, temph = this.h, expand = 1.15f;

    if (image.width > w || image.height > h) {
      image.loadPixels();

      if (image.width > image.height) {
        image.resize(0, (int)h);
      } else
        image.resize((int)w, 0);

      image.updatePixels();
    }

    while (tempw * expand < w && temph * expand < h) {
      tempw = tempw * expand;
      temph = temph * expand;
    }
    setSize(tempw, temph);
  }

  public void unfocus(float maxWidth, float h) {
    float tempw = this.w, temph = this.h, shrink = .85f;
    while (tempw * shrink> maxWidth || temph * shrink > h) {
      tempw = tempw * shrink;
      temph = temph * shrink;
    }
    setSize(tempw, temph);
    System.out.println("temp size " + tempw + " " + temph);
    System.out.println("max size " + maxWidth + " " + h);
  }
}
