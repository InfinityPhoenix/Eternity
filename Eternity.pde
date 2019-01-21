/////////////////////////////////////////////////
//                                             //
//                  Eternity                   //
//                                             //
//     Credits:                                //
//     Design - Janet Liu, Cindy Xiong         //
//     Storyline - Janet Liu, Cindy Xiong      //
//     Art/Graphics - Cindy Xiong              //
//     Music/Sound - Kevin Yang                //
//     Coding - Justin Im, Kevin Yang          //
//                                             //
//     ...with help from:                      //
//     Coding - Chris Xiong                    //
//                                             //
//     Made with Processing 3.4, 2018-2019     //
//     Last updated: 1/18/2019                 //
//                                             //
/////////////////////////////////////////////////

//-----Setup-----
// Application variables
float aspect_ratio = (16.0/9.0);
float window_height = 500.0;
float window_width = aspect_ratio * window_height;
int framerate = 50;

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
  
  // Set session variables
  surface.setSize(int(window_width), int(window_height));
  frameRate(framerate);
  
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
  PImage[] crane_spritesheets = {loadImage("graphics/sprites/player/WalkCycle.png")};
  // Idle, Walking, and Jump animations
  int[][] crane_seqs = {
    // Walking animation
    {3, 8} // 3 per row, 8 total sprites
  };
  // Create the player
  player = new Sprite(crane_spritesheets, crane_seqs, calcAnimationSequence(crane_seqs));
  
  // Loading text
  String[] loading_texts = {
    "Loading.",
    "Loading..",
    "Loading..."
  };
  int[] loading_sequences = {3};
  loading = new TextAnimation(loading_texts, loading_sequences);
  
}

//-----Classes-----
// Generic animations, ie: Sprites, Text etc.
class Animation {
  
  // Class variables
  int[] animate_sequences; // Store sequences for animation
  
  // Base Animation constructor: Takes a sequence of animations and passes it in 
  Animation(int[] a) {
    animate_sequences = a;
  }
  
  // AnimationFrame variables
  int cycle = 0;
  int delay;
  int i = 0;
  
  // Calculate what frame to draw when given the sequence and total time in milliseconds
  int calcAnimationFrame(int seq, int tt) {
    
    // Calculate delay in frames
    delay = ceil(float(tt * framerate)/float(1000 * animate_sequences[seq - 1]));
    
    // Frame change logic
    if (i < delay) {
      i += 1;
      return cycle;
    }
    else {
      i = 0;
      if (cycle >= animate_sequences[seq - 1] - 1) {
        cycle = 0;
      }
      else {
        cycle += 1;
      }
      return cycle;
    }
  }
}

// Sprite-specific animations
class Sprite extends Animation {
  
  // Define class variables
  PImage[][] sprites;
  PImage[] frames;
  
  // Sprite constructor, where sss is an array of spritesheets, sssplit is an array of arrays to split (width and height), and finally animation sequences
  Sprite(PImage[] sss, int[][] sssplit, int[] a) {
    
    // Pass 'a' into the Animation constructor
    super(a);
    
    // Set the first dimension to the amount of spritesheets given. The second dimension will be set later as this is a jagged array
    sprites = new PImage[sss.length][];
    
    // Triple-nested for loops to iterate through all spritesheets and animation sequences
    for(int i = 0; i < sss.length; i++) {
      
      int images = 0; // Track images so far
      int r = ceil(float(sssplit[i][1])/float(sssplit[i][0])); // Calculate rows
      int w = int(float(sss[i].width)/float(sssplit[i][0])); // Calculate the width of each image
      int h = int(float(sss[i].height)/float(r)); // Calculate the height of each image 
      sprites[i] = new PImage[sssplit[i][1]]; // Set the second dimension to the amount of images in the current spritesheet to allow for the creation of a jagged array
      
      // Iterate through all rows
      for (int j = 0; j < r; j++) {
        // Iterate through all of the columns
        for (int k = 0; k < sssplit[i][0]; k++) {
          // Check if all the specified images have already been done, crop out a sprite if not all have been done yet
          if (images < a[i]) {
            sprites[i][images] = sss[i].get(k * w, j * h, w, h);
          }
          // Exit the loop if done
          else {
            j = a[i];
          }
          images += 1;
        }
      }   
    }
  }
  
  PImage sprite_frame;
  
  // Draw a frame of a sprite at a specified location
  void drawSprite(PImage img, int x, int y, int w, int h) {
    sprite_frame = img;
    image(sprite_frame, x, y, w, h);
  }

}

// Text-specific animations
class TextAnimation extends Animation {
  
  // Define class variables
  String[] texts;
  String text_frame;
  
  // TextAnimation Constructor, take in a string array of all text to be used as well as the animation sequences
  TextAnimation(String[] t, int[] a) {
    super(a);
    texts = t;
  }
  
  // Function to draw the text
  void drawText(String t, int x, int y) {
    text_frame = t;
    text(t, x, y);
  }
  
}

// Player class
class Crane {

}

// Background class
class Environment {

}

//-----Functions-----
// Adjust a graphic to fit the resolution
PImage adjustResolution(PImage i, float a, String al) {
  
  // Store function variables
  PImage image = i; // Image to crop
  float aspect = a; // Aspect ratio to use
  String alignment = al; // Alignment/cropping instructions
  
  if (aspect >= image.width/image.height) {
    int new_height = int(float(image.width)/aspect);
    // Take the top section (cuts out from the bottom)
    if (alignment == "top") {
      image = image.get(0, 0, image.width, new_height);
    } 
    // Take the bottom section (cuts out from the top)
    else if (alignment == "bottom") {
      image = image.get(0, image.height - new_height, image.width, new_height);
    }
    // Take the middle section (default, cuts from top and bottom)
    else {
      image = image.get(0, (image.height - new_height)/2, image.width, new_height);
    }
  }
  else {
    int new_width = int(float(image.height) * aspect);
    // Take the left section (cut from the right)
    if (alignment == "left") {
      image = image.get(0, 0, new_width, image.height);
    } 
    // Take the right section (cut from the left)
    else if (alignment == "right") {
      image = image.get(image.width - new_width, 0, new_width, image.height);
    }
    // Take the middle section (default, cut from left and right)
    else {
      image = image.get((image.width - new_width)/2, 0, new_width, image.height);
    }
  }
  
  return image;
  
}

// Takes an array of arrays of 2 values, the amount of rows and the total images and returns the sequences
int[] calcAnimationSequence(int[][] s) {
  int[] animation_sequences = {};
  for (int i = 0; i < s.length; i++) {
    int sequence = s[i][1]; // Get the amount of images in one sequence
    animation_sequences = append(animation_sequences, sequence); // Add the result to the array
  }
  return animation_sequences; // Return the amount of images in each sequence as an array
}

void drawScene(int scene) {
  
  // Startup
  if (scene == SCENE_LOADING) {
    
    // Pink background
    color backdrop = color(245, 175, 185);
    background(backdrop);
    fill(255);
    
    // Draw the walking player on repeat in the same spot
    player.drawSprite(player.sprites[0][player.calcAnimationFrame(1, 1600)], width/2, height/2 - int(window_height/18.0), int(window_height/2.5), int(window_height/2.5));
    
    // Display a loading message
    textFont(display, int(window_height/9.0));
    textAlign(CENTER);
    loading.drawText(loading.texts[loading.calcAnimationFrame(1, 2400)], width/2, height/2 + int(window_height/4.5));
  
  } 
  
  // Main screen/Start screen
  else if (scene == SCENE_MAIN) {
    // Image Background
    image(adjustResolution(background_img, aspect_ratio, "center"), width/2, height/2, width, height);
    fill(255);
    
    // Display Game Name
    textFont(text, int(window_height/4.0));
    textAlign(CENTER);
    text("Eternity", width/2, window_height/5.0);
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
  
  frameRate(framerate); // Set framerate
  //drawScene(SCENE_LOADING);
  drawScene(SCENE_MAIN);

}
