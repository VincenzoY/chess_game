Chess one = new Chess();
int colour = 0;
PFont font;
boolean titlescreen = true;

void setup() {
  size(400, 400);
  background(100);
  font = createFont("Serif", 50);
  textFont(font);
  one.reset();
}

void draw() {
  if (titlescreen) {
    background(56, 78, 119);
    textSize(30);
    text("Welcome to Chess", 30, 50);
    textSize(20);
    text("Press \"r\" to reset to the previous move.\nCastling is accomplished by moving your\nking first then rook.\nEm passent dosen't work.\nYou can however toggle free mode with \"n\"\nto move peices freely and \"p\" to skip turns.", 30, 100);
    text("Press Space to start playing", 30, 350);
  } else {
    textSize(50);
    if (one.promote == 1 || one.promote == 2) {
      one.drawboard();
      one.display_peices();
      if (one.player == true) {
        one.promote_display_black();
      } else {
        one.promote_display_white();
      }
    } else {
      one.drawboard();
      one.display_peices();
      one.selected_outline();
    }
  }
}

void mousePressed() {
  if (one.promote == 1 || one.promote == 2) {
    one.select_to_promote();
  } else {
    one.select_peice();
  }
}

void keyPressed() {
  if (key == 32 && titlescreen) {
    titlescreen = false;
  }
  if (key == 'r') {
    one.redo(); 
    one.promote = 0;
    one.empty_array(one.selected);
  }
  if (key == 'n') {
    one.cheat = !one.cheat;
  }
  if (key == 'p') {
    one.player = !one.player;
  }
}
