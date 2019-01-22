class Button {
   
  String t;
  int x, y, w, h;
  
  Button(int x_pos, int y_pos, int b_width, int b_height, String text) {
    x = x_pos;
    y = y_pos;
    w = b_width;
    h = b_height;
    t = text;
  }
  
  boolean clicked() {
    if (mousePressed && mouseX >= x && mouseX <= x + w  && mouseY >= y && mouseY <= y + h) {
      return true;
    }
    return false;
  }
  
}
