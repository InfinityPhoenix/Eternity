///////////////////////////////////////////////
//                                           //
//                Eternity                   //
//                                           //
//      Credits:                             //
//      Design - Cindy Xiong                 //
//      Storyline - Janet Liu                //
//      Art/Graphics - Cindy Xiong           //
//      Music/Sound - Kevin Yang             //
//      Coding - Victor Qiu, Kevin Yang      //
//                                           //
//      Made with Processing 3.4, 2018       //
//                                           //
///////////////////////////////////////////////

//-----Setup-----
// Application variables
int window_width = 720;
int window_height = 480;
int framerate = 30;

// Sprites/Images
PImage background;
Sprite player;

// Set scene names
int SCENE_LOADING = 1,
    SCENE_MAIN = 2,
    SCENE_GAME = 3,
    SCENE_GAMEOVER = 4;

void setup() {
  
  // Set window size
  surface.setSize(window_width, window_height);
  // size(screenWidth, screenHeight);
  
  // Set draw conditions
  imageMode(CENTER);
  
  // Load Images
  String path = "graphics/environment/";
  background = loadImage(path + "Background_Largest.png");
  
  path = "graphics/sprites/player/";
  PImage[] crane_images = {loadImage(path + "Crane_IdleAnim_1.png"), loadImage(path + "Crane_IdleAnim_2.png"), loadImage(path + "Crane_Walkcycle_1.png"), loadImage(path + "Crane_Walkcycle_2.png"), loadImage(path + "Crane_Walkcycle_3.png"), loadImage(path + "Crane_Walkcycle_4.png"), loadImage(path + "Crane_Walkcycle_5.png"), loadImage(path + "Crane_Walkcycle_6.png"), loadImage(path + "Crane_Walkcycle_7.png"), loadImage(path + "Crane_Walkcycle_8.png"), loadImage(path + "Crane_JumpAnim_Up.png"), loadImage(path + "Crane_JumpAnim_Down.png")};
  // Idle, Walking, Jump
  int[][] crane_sequences = {{0, 1}, {2, 3, 4, 5, 6, 7, 8, 9}, {10, 11}};
  // Create the player
  player = new Sprite(crane_images, crane_sequences, framerate);
  
}

//-----Classes-----

class Sprite {
  
  PImage[] images;
  int[][] animate_sequences;
  int fps;
  
  Sprite(PImage[] i, int[][] a, int f) {
    images = i;
    animate_sequences = a;
    fps = f;
  }
  
  PImage sprite_frame;
  
  void drawSprite(PImage i, int x, int y) {
    sprite_frame = i;
    image(sprite_frame, x, y);
  }
  
  int cycle = 1;
  int delay = 1;
  int i = 1;
  
  int calcAnimationFrame(int seq, int del) {
    delay = del;
    int[] animation_sequence = animate_sequences[seq - 1];
    if (cycle >= animation_sequence.length) {
      cycle = 1;
      return cycle;
    }
    else {
      if (i < delay) {
        i += 1;
        return cycle;
      }
      else {
        i = 1;
        cycle += 1;
        return cycle;
      }
    }
  }
  
}

class Crane {

}

class Environment {

}

//-----Functions-----

void drawScene(int scene) {
  
  PImage crane_idle_1;
  
  // Startup
  if (scene == SCENE_LOADING) {
    // Pink background
    color backdrop = color(245, 175, 185);
    background(backdrop);
    player.drawSprite(player.images[player.animate_sequences[1][player.calcAnimationFrame(2, 5) - 1]], width/2, height/2);
  } 
  
  // Main screen/Start screen
  else if (scene == SCENE_MAIN) {
    
  }
  
  // Game
  else if (scene == SCENE_GAME) {
    image(background, width/2, height/2, width, height);
  }
  // Game Over
  else if (scene == SCENE_GAMEOVER) {
  
  }
  // 
  else if (scene == 5) {
  
  }
  else {
    print("Error: Requested scene not found.");
  }
  
}

void draw() {
  
  frameRate(framerate);
  drawScene(SCENE_LOADING);
  
}
