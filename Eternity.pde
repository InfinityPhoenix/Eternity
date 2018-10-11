//////////////////////////////////////////////////
//                                              //
//                   Eternity                   //
//                                              //
//      Credits:                                //
//      Design - Janet Liu, Cindy Xiong         //
//      Storyline - Janet Liu, Cindy Xiong      //
//      Art/Graphics - Cindy Xiong              //
//      Music/Sound - Kevin Yang                //
//      Coding - Justin Im, Victor Qiu,         //
//      Kevin Yang                              //
//                                              //
//      ...with help from:                      //
//      Coding - Chris Xiong                    //
//                                              //
//      Made with Processing 3.4, 2018          //
//                                              //
//////////////////////////////////////////////////

//-----Setup-----
// Application variables
float aspect_ratio = (16.0/9.0);
float window_height = 500.0;
float window_width = aspect_ratio * window_height;
int framerate = 30;

// Animations/Images
PImage background_img;
Sprite player;
TextAnimation loading;

// Set scene names
int SCENE_LOADING = 1,
    SCENE_MAIN = 2,
    SCENE_GAME = 3,
    SCENE_GAMEOVER = 4;

// Font declarations
PFont display;
PFont text;

void setup() {
  
  // Set window size
  surface.setSize(int(window_width), int(window_height));
  
  // Load fonts
  String fontpath = "fonts/";
  display = createFont(fontpath + "Crumbled-Pixels.ttf", 72);
  text = createFont(fontpath + "BitPotion.ttf", 72);
  
  // Set draw conditions
  imageMode(CENTER);
  
  // Load Images
  // Background
  String imagepath = "graphics/environment/";
  background_img = loadImage(imagepath + "Background_Largest.png");
  
  // Player (Crane)
  imagepath = "graphics/sprites/player/";
  PImage[] crane_images = {
    loadImage(imagepath + "Crane_IdleAnim_1.png"), 
    loadImage(imagepath + "Crane_IdleAnim_2.png"),
    loadImage(imagepath + "Crane_Walkcycle_1.png"),
    loadImage(imagepath + "Crane_Walkcycle_2.png"), 
    loadImage(imagepath + "Crane_Walkcycle_3.png"), 
    loadImage(imagepath + "Crane_Walkcycle_4.png"), 
    loadImage(imagepath + "Crane_Walkcycle_5.png"), 
    loadImage(imagepath + "Crane_Walkcycle_6.png"), 
    loadImage(imagepath + "Crane_Walkcycle_7.png"), 
    loadImage(imagepath + "Crane_Walkcycle_8.png"), 
    loadImage(imagepath + "Crane_JumpAnim_Up.png"), 
    loadImage(imagepath + "Crane_JumpAnim_Down.png")
  };
  // Idle, Walking, and Jump animations
  int[][] crane_sequences = {
    // Idle animation
    {0, 1}, 
    // Walking animation
    {2, 3, 4, 5, 6, 7, 8, 9}, 
    // Jumping animation
    {10, 11}
  };
  // Create the player
  player = new Sprite(crane_images, crane_sequences);
  
  // Loading text
  String[] loading_texts = {
    "Loading",
    "Loading.",
    "Loading..",
    "Loading..."
  };
  int[][] loading_sequences = {
    {0, 1, 2, 3}
  };
  loading = new TextAnimation(loading_texts, loading_sequences);
  
}

//-----Classes-----
// Generic animations, ie: Sprites, Text etc.
class Animation {

  int[][] animate_sequences;
  
  Animation(int[][] a) {
    animate_sequences = a;
  }
  
  int cycle = 1;
  int delay = 1;
  int i = 1;
  
  // Calculate what frame to draw
  int calcAnimationFrame(int seq, int del) {
    delay = del;
    // Account for 'seq' not being 0-indexed because asking for 'Sequence 0' makes no sense
    int[] animation_sequence = animate_sequences[seq - 1];
    // If the cycle is equal to or past the last image in the sequence, reset
    if (cycle >= animation_sequence.length) {
      if (i < delay) {
        i += 1;
        return cycle;
      }
      else {
        i = 1;
        cycle = 1;
        return cycle;
      }
    }
    else {
      // Iterate 'i' but not 'cycle' to create a 'frozen' frame
      if (i < delay) {
        i += 1;
        return cycle;
      }
      // Iterate 'cycle' but not 'i' to cycle and reset the delay counter
      else {
        i = 1;
        cycle += 1;
        return cycle;
      }
    }
  }
  
}

// Definte sprite-specific animations
class Sprite extends Animation {
  
  PImage[] images;
  
  Sprite(PImage[] i, int[][] a) {
    // Pass 'a' into the Animation constructor
    super(a);
    images = i;
  }
  
  PImage sprite_frame;
  
  // Draw a frame of a sprite at a specified location
  void drawSprite(PImage i, int x, int y, int w, int h) {
    sprite_frame = i;
    image(sprite_frame, x, y, w, h);
  }
  
}

class TextAnimation extends Animation {
  
  String[] texts;
  
  TextAnimation(String[] t, int[][] a) {
    super(a);
    texts = t;
  }
  
  String text_frame;
  
  void drawText(String t, int x, int y) {
    text_frame = t;
    text(t, x, y);
  }
  
}

class Crane {

}

class Environment {

}

//-----Functions-----

PImage adjustResolution(PImage i, float a, String al) {
  
  PImage image = i;
  float aspect = a;
  String alignment = al;
  
  if (aspect >= image.width/image.height) {
    int new_height = int(float(image.width)/aspect);
    if (alignment == "top") {
      image = image.get(0, 0, image.width, new_height);
    } 
    else if (alignment == "bottom") {
      image = image.get(0, image.height - new_height, image.width, new_height);
    }
    else {
      image = image.get(0, (image.height - new_height)/2, image.width, new_height);
    }
  }
  else {
    int new_width = int(float(image.height) * aspect);
    if (alignment == "left") {
      image = image.get(0, 0, new_width, image.height);
    } 
    else if (alignment == "right") {
      image = image.get(image.width - new_width, 0, new_width, image.height);
    }
    else {
      image = image.get((image.width - new_width)/2, 0, new_width, image.height);
    }
  }
  
  return image;
  
}

void drawScene(int scene) {
  
  // Startup
  if (scene == SCENE_LOADING) {
    
    // Pink background
    color backdrop = color(245, 175, 185);
    background(backdrop);
    
    // Draw the walking player on repeat in the same spot
    player.drawSprite(player.images[player.animate_sequences[1][player.calcAnimationFrame(2, 5) - 1]], width/2, height/2 - int(window_height/18.0), int(window_height/2.5), int(window_height/2.5));
    
    // Display a loading message
    textFont(display, int(window_height/9.0));
    textAlign(CENTER);
    loading.drawText(loading.texts[loading.animate_sequences[0][loading.calcAnimationFrame(1, 20) - 1]], width/2, height/2 + int(window_height/4.5));
  
  } 
  
  // Main screen/Start screen
  else if (scene == SCENE_MAIN) {
    
  }
  
  // Game
  else if (scene == SCENE_GAME) {
    image(adjustResolution(background_img, aspect_ratio, "center"), width/2, height/2, width, height);
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
  //drawScene(SCENE_LOADING);
  drawScene(SCENE_GAME);
  
}
