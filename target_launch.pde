//title: target launch
//authors: andrew ha and rhythm jethi
//course: physics 12
//description: a simple target launch game.

color background = #ffc3a0;          //background colour
color text = #2c57a6;                //text colour

float grav = 0.09;                   //how fast the ball will be pulled down

PImage hoop;                         //variable for picture of hoop
PImage hoopCover;
float hoopWidth = 275;               //hoop dimensions
float hoopHeight = 327;
float hoopXPos = 550;                //initial coordinates of top left corner of hoop
float hoopYPos = 50;
float hoopLeftX = hoopXPos + 2;      //initial hoop boundaries for collision detection
float hoopRightX = hoopXPos + 137;
float hoopY = hoopYPos + 226;

float arrowWidth = 26;               //arrow dimensions
float arrowHeight = 156;

PImage icon;
float ballIconWidth = 32;
float ballIconHeight = 32;

Projectile ball;                     //creates new projectile variable
float ballWidth = 100;               //basketball dimensions for collision detection
float ballHeight = 102;
float ballXPos = 75 - ballWidth/2;   //initial position coordinates
float ballYPos = 525 - ballHeight/2;

boolean launching = false;           //is the ball being launched?
boolean aiming = true;               //is the ball being aimed?
boolean dunked = false;              //did the ball make it to the hoop?
boolean scoring = false;             //should the score be increased?
boolean alreadyScored = false;       //stops score from increasing more than one point each time
boolean hoopRand = false;
boolean alreadyHoopRand = false;

String gameState = "start";          //where in the game are we? (start screen, playing, game over)
int score = 0;                       //score counter
int lives = 3;                       //lives counter

PFont smallFont;
PFont bigFont;

void setup() {            //runs once at start
  size(800,600);          //sets window size
  background(background); //sets background colour
  frameRate(100);         //sets frame rate

  fill(text);
  smallFont = loadFont("CenturyGothic-Bold-30.vlw");
  bigFont = loadFont("CenturyGothic-BoldItalic-100.vlw");
  
  ball = new Projectile(ballXPos,ballYPos); //initializes ball object
  
  hoop = loadImage("Hoop.png");             //loads pictures
  hoopCover = loadImage("Hoopcover.png");
  icon = loadImage("basketballIcon.png");
}

void draw() { //runs once every frame

  if (gameState == "start") {
    background(background);
 
    textFont(bigFont); //introduction + instructions
    text("shoot hoops.",width/2-275,height/2-70);
    
    textFont(smallFont);
    text("left and right to aim,",width/2-275,height/2+15);
    text("up and down to change power,",width/2-225,height/2+55);
    text("any key to start.", width/2-275,height/2+135);
    
    //moves to gameState "playing" in keyPressed()
  }
  
  else if (gameState == "playing") {
    background(background);              //redraws background to cover old basketball

    textFont(bigFont);
    text(score,width/2-75,height/2);
    
    for (int i = 0; i < lives; i += 1) { //draws one ball icon for each life you have
      image(icon,5+(i*ballIconWidth),5);
    }
    
    if (lives == 0) gameState = "lose";
    
    if (hoopRand) {
      hoopPosition();
    }
    
    image(hoop,hoopXPos,hoopYPos);       //draws picture of hoop
    
    if (aiming) ball.aim();              //lets you aim the ball
    else if (launching) ball.launch();   //launches ball using method from ball class
    
    //if (dunked) ball.dunk();           //increases your score when you make the shot
    if (dunked) {
      ball.dunk();
      if (!alreadyScored) {
        hoopRand = true;
      }
    }
    
    image(hoopCover,hoopXPos,hoopYPos); //makes hoop overlap ball
    
    //moves to gameState "lose" if you run out of lives
    
  }
  
  else if (gameState == "lose") {
    background(background);

    textFont(bigFont); //tells you the game is over and your score
    text("game over.", width/2-275, height/2-70);

    textFont(smallFont);
    if (score == 0) {
      text ("you didn't make any shots,", width/2-275, height/2+15);
      text("not even one.",width/2-225,height/2+55);
    }
    else if (score == 1) {
      text("you made "+score+" shot", width/2-275, height/2+15);
      text("wow!",width/2-225,height/2+55);
    }
    else {
      text("you made "+score+" shots,", width/2-225, height/2+15);
      text("not too shabby.",width/2-275,height/2+55);
    }
    text("any key to play again.", width/2-275, height/2+135);

    aiming = false;
    launching = false;
    
    //moves back to gameState "play" in keyPressed()
  }
  
}

void hoopPosition() {
  hoopXPos = random(350,width-hoopWidth);
  hoopYPos = random(height-hoopHeight);
  
  hoopLeftX = hoopXPos + 2;
  hoopRightX = hoopXPos + 137;
  hoopY = hoopYPos + 226;
  
  hoopRand = false;
}

void keyPressed() {   //runs when any key is pressed
  if (gameState == "start") {
    gameState = "playing";
  }
  
  else if (gameState == "playing") {
    if (key == ' ') {
      aiming = false;   //if you're launching then you aren't aiming
      launching = true; //launches the ball if space is pressed
    }
  }
  
  else if (gameState == "lose") {
    lives = 3;
    score = 0;
    gameState = "playing";
    aiming = true;
  }
}