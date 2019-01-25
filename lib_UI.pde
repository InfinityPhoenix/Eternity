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
  
}

class EllButton extends Button {
  
  EllButton(int x_pos, int y_pos, int b_width, int b_height, String text) {
    super(x_pos, y_pos, b_width, b_height, text);
  }
  
  boolean clicked() {
    int c = int((w/h) * sqrt(pow(h/2, 2) - pow(mouseY - y, 2)));
    if (mousePressed && mouseX >= x - c && mouseX <= x + c) {
      return true;
    }
    return false;
  }
  
  void draw() {
    ellipse(x, y, w, h);
  }
  
}
