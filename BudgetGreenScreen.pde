import processing.video.*;

Capture video;
PImage still;
PImage bg;
int w, h;

final int MAX_SIMILARITY = 25;
final color BACKGROUND = color(0, 255, 0);

void captureEvent(Capture video) {
  video.read();
  if (mousePressed) {
    still.copy(video, 0, 0, w, h, 0, 0, w, h);
  }
}

void setup() {  
  size(1280, 360);
  frameRate(20);
  w = width/2;
  h = height;

  bg = loadImage("BG.png");
  
  video = new Capture(this, w, h);
  video.start();
  still = createImage(w, h, ARGB);
  still.loadPixels();
  for (int i = 0; i < still.pixels.length; i++) {
    still.pixels[i] = color(255);
  }
  still.updatePixels();
}

void draw() {  
  image(still, w, 0, w, h);
  video.loadPixels();
  still.loadPixels();
  bg.loadPixels();
  for (int i = 0; i < video.pixels.length; i++) {
    final int v = video.pixels[i];
    final int s = still.pixels[i];
    final int vr = (int) (v >> 16 & 0xFF);
    final int sr = (int) (s >> 16 & 0xFF);
    if (vr < sr - MAX_SIMILARITY ||  vr > sr + MAX_SIMILARITY) continue;
    final int vb = (int) (v & 0xFF);
    final int sb = (int) (s & 0xFF);
    if (vb < sb - MAX_SIMILARITY ||  vb > sb + MAX_SIMILARITY) continue;   
    final int vg = (int) (v >> 8 & 0xFF);
    final int sg = (int) (s >> 8 & 0xFF);
    if (vg < sg - MAX_SIMILARITY ||  vg > sg + MAX_SIMILARITY) continue;
    video.pixels[i] = bg.pixels[i];
  }
  video.updatePixels();
  image(video, 0, 0);
}
