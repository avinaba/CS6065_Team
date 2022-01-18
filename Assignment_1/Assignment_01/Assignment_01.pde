/**
 * Authors: 
 * Harshita, Shubham, Avinaba
 *
 * ControlP5 examples provided by Andreas Schlegel, 2012, LGPL-2.1 License 
 * https://github.com/sojamo/controlp5
 *
 */

// Book-keeping values 
int START_TIME = millis();
String USER_ID = null; 
int TOTAL_TRIALS_IN_BLOCK = 3;
int BLOCK_NO = -1; 
int TRIAL_NO = -1;
int COUNT_ERRORS = -1;
 
 
import controlP5.*;

ControlP5 cp5;

// Static setup variables
// -Layout
// final int ScreenWidth = 800;
// final int ScreenHeight = 450;
int PrimaryButtonHeight = 36;
int TextInputHeight = 36;

// -Colours 
int screenBgColour = color(255,255,255);
int buttonPrimaryDefaultBgColour = color(93, 95, 231);

int buttonAltPrimaryDefaultBgColour = color(239, 181, 93);
int buttonAltPrimaryHoverBgColour = color(255, 210, 143);
int buttonAltPrimaryPressedBgColour = color(232, 164, 62);

int buttonPrimaryLockedBgColour = color(190, 191, 249);


int textFieldBgColour = color(235, 235, 235);


int textDefaultColour = color(0);
int horizontalRuleColour = color(196, 196, 196);

// - Control support 
boolean enableNextToInstructionButton = false;
boolean enableNextToTrialOneButton = false;
boolean enableStartTrialOneButton = false;

// - Aesthetic support 
Textlabel horizontalRuleLabel;

void setup() {
  size(800, 450);
  noStroke();
  cp5 = new ControlP5(this);
  
  // -Fonts
  ControlFont headerControlFont = new ControlFont(createFont("Arial Bold", 26));
  ControlFont captionControlFont = new ControlFont(createFont("Arial", 16));
  ControlFont defaultCopyControlFont = new ControlFont(createFont("Arial", 18));
  
  ControlFont buttonLabelControlFont = new ControlFont(createFont("Arial Bold", 16));
  
  Group scene1 = cp5.addGroup("scene1");
  // Screen 1 
  {
  cp5.addTextlabel("headerScene1")
     .setText("CS6065: Assignment 1")
     .setFont(headerControlFont)
     .setColor(textDefaultColour)
     .setPosition(32, 32)
     .setGroup(scene1)
     ;
  
  cp5.addTextlabel("subHeaderScene1")
     .setText("Investigating the Human Factors of Reaction Time")
     .setFont(captionControlFont)
     .setColor(textDefaultColour)
     .setPosition(32, 71)
     .setGroup(scene1)
     ;
     
  cp5.addTextlabel("authorsScene1")
     .setText("Harshita · Shubham · Avinaba")
     .setFont(defaultCopyControlFont)
     .setColor(textDefaultColour)
     .setPosition(32, 120)
     .setGroup(scene1)
     ;
  
  cp5.addTextlabel("inputUserIdCaption")
     .setText("Enter your user number")
     .setFont(captionControlFont)
     .setColor(textDefaultColour)
     .setPosition(32, 305)
     .setGroup(scene1)
     ;
     
  cp5.addTextfield("userIdInput")
     .setCaptionLabel("") 
     .setPosition(32, 335)
     .setSize(330, TextInputHeight)
     .setFont(defaultCopyControlFont)
     .setColor(textDefaultColour)
     .setColorBackground(textFieldBgColour)
     .setColorCursor(textDefaultColour)
     .setAutoClear(false)
     .setFocus(true)
     .setGroup(scene1)
     ;
  
  cp5.addButton("nextToInstructions")
     .setCaptionLabel("Next: Instructions")
     .setValue(0)
     .setPosition(32, 381)
     .setSize(330, PrimaryButtonHeight)
     .setColorBackground(buttonPrimaryDefaultBgColour)
     .setFont(buttonLabelControlFont)
     .setGroup(scene1)
     ;
     
  }
  
  Group scene2 = cp5.addGroup("scene2");
  // Screen 2 
  {
    cp5.addTextlabel("headerScene2")
     .setText("Instructions")
     .setFont(headerControlFont)
     .setColor(textDefaultColour)
     .setPosition(32, 32)
     .setGroup(scene2)
     ;
  
  cp5.addTextlabel("step1Caption")
     .setText("Step 1")
     .setFont(captionControlFont)
     .setColor(textDefaultColour)
     .setPosition(32, 102)
     .setGroup(scene2)
     ;
     
  cp5.addTextlabel("step1Text")
     .setText("Click on the “START” button at the center of the next screen to begin a “trial”")
     .setFont(defaultCopyControlFont)
     .setColor(textDefaultColour)
     .setPosition(32, 122)
     .setGroup(scene2)
     ;
  
  cp5.addTextlabel("step2Caption")
     .setText("Step 2")
     .setFont(captionControlFont)
     .setColor(textDefaultColour)
     .setPosition(32, 175)
     .setGroup(scene2)
     ;
     
  cp5.addTextlabel("step2Text")
     .setText("Click on the “illuminated” button as fast as you can. E.g: ")
     .setFont(defaultCopyControlFont)
     .setColor(textDefaultColour)
     .setPosition(32, 195)
     .setGroup(scene2)
     ;
     
  cp5.addButton("demoEndButton")
     .setCaptionLabel(" ")
     .setValue(0)
     .setPosition(482, 180)
     .setSize(160, PrimaryButtonHeight)
     .setColorBackground(buttonAltPrimaryDefaultBgColour)
     .setColorForeground(buttonAltPrimaryHoverBgColour)
     .setColorActive(buttonAltPrimaryPressedBgColour)
     .setFont(buttonLabelControlFont)
     .setGroup(scene2)
     ;
  
  cp5.addTextlabel("step3Caption")
     .setText("Step 3")
     .setFont(captionControlFont)
     .setColor(textDefaultColour)
     .setPosition(32, 248)
     .setGroup(scene2)
     ;
     
  cp5.addTextlabel("step3Text")
     .setText("Repeat Step 1 and 2 for 20 times, thrice to complete the exercise")
     .setFont(defaultCopyControlFont)
     .setColor(textDefaultColour)
     .setPosition(32, 268)
     .setGroup(scene2)
     ;
   
   cp5.addButton("nextToTrialOne")
     .setCaptionLabel("Next: Begin Trial")
     .setValue(0)
     .setPosition(32, 381)
     .setSize(330, PrimaryButtonHeight)
     .setColorBackground(buttonPrimaryDefaultBgColour)
     .setFont(buttonLabelControlFont)
     .setGroup(scene2)
     ;
     
    // Hide Scene 2 elements
    scene2.hide();
  }
  
  Group scene3 = cp5.addGroup("scene3");
  // Screen 3
  {
    cp5.addButton("startTrialOne")
     .setCaptionLabel("Start")
     .setValue(0)
     .setPosition(330, 207)
     .setSize(140, PrimaryButtonHeight)
     .setColorBackground(buttonPrimaryDefaultBgColour)
     .setFont(buttonLabelControlFont)
     .setGroup(scene3)
     ;
     
     cp5.addButton("buttonLeftBlock1")
     .setCaptionLabel(" ")
     .setValue(0)
     .setPosition(165, 207)
     .setSize(140, PrimaryButtonHeight)
     .setColorBackground(buttonPrimaryLockedBgColour)
     .setFont(buttonLabelControlFont)
     .lock()
     .setGroup(scene3)
     ;
     
     cp5.addButton("buttonRightBlock1")
     .setCaptionLabel(" ")
     .setValue(0)
     .setPosition(495, 207)
     .setSize(140, PrimaryButtonHeight)
     .setColorBackground(buttonPrimaryLockedBgColour)
     .setFont(buttonLabelControlFont)
     .lock()
     .setGroup(scene3)
     ;
     
     cp5.addButton("buttonTargetBlock1")
     .setCaptionLabel(" ")
     .setValue(0)
     .setPosition(495, 267)
     .setSize(140, PrimaryButtonHeight)
     .setColorBackground(buttonAltPrimaryDefaultBgColour)
     .setColorForeground(buttonAltPrimaryHoverBgColour)
     .setColorActive(buttonAltPrimaryPressedBgColour)
     .setFont(buttonLabelControlFont)
     //.lock()
     .setGroup(scene3)
     ;
    
    // Hide Scene 3 elements
    scene3.hide();
  }
 

}

void draw() {
  background(screenBgColour);

}

// Logic: 
// Each button selectively shows and hides each scene and removes overlapping control elements 
// Eg. "Next: Instructions" hides all of first scene and shows all of "Instruction" (screen 2)

//Button b1 = ((Button)cp5.getController("nextToInstructions"));

//b1.onRelease(new CallbackListener() {
//  public void controlEvent(CallbackEvent theEvent) {
    
//    //println("'Next: Instructions' clicked!");
//  }
//});

public void nextToInstructions(int theValue){
  if(enableNextToInstructionButton){
    
    // Set unique user id
    USER_ID = cp5.get(Textfield.class, "userIdInput").getText();
    

    // Hide Scene 1 elements
    cp5.getGroup("scene1").hide();
    
    // Show Scene 2 elements
    cp5.getGroup("scene2").show();
    
    // Remove Scene 1 elements 
    // cp5.getGroup("scene1").remove();    
  }
  
  // Enable on first loop
  if(enableNextToInstructionButton == false) {
    // println("'Next: Instruction' button enabled");
    enableNextToInstructionButton = true;
  }
}

public void nextToTrialOne(int theValue){
  
  if(enableNextToTrialOneButton) {
    // println("User id: " + USER_ID);
    // println("Time elapsed since execution began: " + int(millis() - START_TIME));
    
    // Set up first block of trials 
    BLOCK_NO = 1; 
    TRIAL_NO = 1;
    COUNT_ERRORS = 1;
    
    
    // Hide Scene 2 elements
    cp5.getGroup("scene2").hide();
    
    // Show Scene 3 elements
    cp5.getGroup("scene3").show();
    
  }
  
  // Enable on first loop 
  if(enableNextToTrialOneButton == false) {
    // println("'Next: Begin Trial' button enabled");
    enableNextToTrialOneButton = true;
  }
}

int[] trialOnePosX = {165, 495};
int[] trialOnePosY = {207, 207};
int NO_OF_TARGETS = 2;

public void startTrialOne(int theValue) {
  
  if(enableStartTrialOneButton) {
    // Disable the start button 
    ((Button)cp5.getController("startTrialOne")).lock();
    ((Button)cp5.getController("startTrialOne")).setColorBackground(buttonPrimaryLockedBgColour);
    
    // Enable other buttons
    ((Button)cp5.getController("buttonRightBlock1")).unlock();
    ((Button)cp5.getController("buttonRightBlock1")).setColorBackground(buttonPrimaryDefaultBgColour);
    
    ((Button)cp5.getController("buttonLeftBlock1")).unlock();
    ((Button)cp5.getController("buttonLeftBlock1")).setColorBackground(buttonPrimaryDefaultBgColour);
    
    // Choose a random position 
    int position_index =  floor(random(NO_OF_TARGETS));
    
    // Set the target button to the random position and bring to front
    ((Button)cp5.getController("buttonTargetBlock1")).setPosition( trialOnePosX[position_index], trialOnePosY[position_index]);    
    ((Button)cp5.getController("buttonTargetBlock1")).bringToFront();  
    
    // Start the timer 
    START_TIME = millis();
}
  
  // Enable on first loop 
  if(enableStartTrialOneButton == false) {
    enableStartTrialOneButton = true;
  }
}
