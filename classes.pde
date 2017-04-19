class Projectile {                                //class for all projectile objects
  float angle = PI/4;                             //ball's launch angle
  float velocity = 9.0;                           //ball's actual velocity
  float xPos, yPos;                               //requires arguments for x position and y position
  float newY, newX;                               //components of velocity
  
  PImage arrow = loadImage("arrow.png");          //loads arrow image
  float arrowScale = 1;                           //factor arrow size scaled by
  
  PImage ballImage = loadImage("BasketBall.png"); //loads basketball image
  
  Projectile(float Xpos, float Ypos) { //initializes projectiles
    xPos = Xpos;                       //sets x position
    yPos = Ypos;                       //sets y position
  }
  
  void aim() {
    pushMatrix(); //draws arrow in bottom left corner and lets it rotate
    translate(75,525);
    image(ballImage,-ballWidth/2,-ballHeight/2);
    rotate(-angle);
    scale(arrowScale);
    image(arrow,100*cos(PI/4),-arrowWidth/2);
    popMatrix();
    
    if (keyPressed) {
      if (keyCode == LEFT) angle += 0.01;       //if left key pressed, arrow moves counterclockwise
      else if (keyCode == RIGHT) angle -= 0.01; //if right key pressed, arrow moves clockwise
      
      if (keyCode == UP) { //if up key pressed, velocity increases and arrow grows bigger
        velocity += 0.01;
        arrowScale += 0.001;
      }
      else if (keyCode == DOWN) { //if down key pressed, velocity decreases and arrow grows smaller
        velocity -= 0.01;
        arrowScale -= 0.001;
      }
      
      if (velocity < 6.7) velocity = 6.7; //restricts velocity
      else if (velocity > 11.2) velocity = 11.2;
    } //ends if (keyPressed)
    
    if (angle > PI/2) angle = PI/2;  //restricts aim range
    else if (angle < 0) angle = 0;
    
    newY = -(velocity * sin(angle)); //velocity vertical component: sin(pi/4) = velocity / newY
    newX = velocity * cos(angle);    //velocity horizontal component: cos(pi/4) = velocity / newX
    
  }
  
  void launch() {
    image(ballImage, xPos, yPos);     //draws picture of basketball
    
    xPos += newX;                     //updates x position
    
    newY += grav;                     //drags ball down
    yPos += newY;                     //updates y position
    
    if (xPos < 0 - ballWidth || xPos > width + ballWidth || yPos > height + ballHeight || yPos < 0 - ballHeight) { //if ball goes off the screen
      velocity = 9.0;
      arrowScale = 1;
      newY = -(velocity * sin(PI/4)); //resets the ball to original position
      newX = velocity * cos(PI/4);
      yPos = ballYPos;
      xPos = ballXPos;
      
      launching = false;              //ball is no longer being launched      
      aiming = true;
      
      lives -= 1;
    }

    if (xPos >= hoopLeftX+20 && xPos <= hoopRightX && yPos >= hoopY-200 && yPos <= hoopY-50) {
      dunked = true;
      scoring = true;
    }
  }
  
  void dunk() {
    if (!alreadyScored) {
      if (scoring) { //increases score once
        score += 1;
        alreadyScored = true;
      }
    }
    newX = 0; //stops ball from moving horizontally once it hits the hoop
    
    
    if (yPos > height) { //resets ball when it falls off the screen
      velocity = 9.0;
      arrowScale = 1;
      newY = -(velocity * sin(PI/4));
      newX = velocity * cos(PI/4);
      yPos = ballYPos;
      xPos = ballXPos;
      
      dunked = false;
      launching = false;
      aiming = true;
      alreadyScored = false;
    }
  }
    
}