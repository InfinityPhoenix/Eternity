// Track Multiple Keypresses
IntList are_down = new IntList();

// Keypress Handler
void keyPressed() {
  if (!are_down.hasValue(keyCode)) {
    are_down.append(keyCode);
  }
}

// Key Release Handler
void keyReleased() {
  for (int i = 0; i < are_down.size(); i++){
    if (are_down.get(i) == keyCode) {
      are_down.remove(i);
    }
  }
}
