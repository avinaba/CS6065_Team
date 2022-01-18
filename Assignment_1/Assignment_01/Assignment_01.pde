/**
 * Authors: 
 * Harshita, Avinaba, Shubham
 *
 * ControlP5 examples provided by Andreas Schlegel, 2012, LGPL-2.1 License 
 * https://github.com/sojamo/controlp5
 *
 */

// Book-keeping values 
int START_TIME = millis();
String USER_ID = null; 
int TOTAL_TRIALS_IN_BLOCK = 20;
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
boolean enableTargetBlock1Button = false;

boolean enableNextToTrialTwoButton = false;
boolean enableStartTrialTwoButton = false;
boolean enableTargetBlock2Button = false;

boolean enableNextToTrialThreeButton = false;
boolean enableStartTrialThreeButton = false;
boolean enableTargetBlock3Button = false;

boolean enableExitButton = false;


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
     .setPosition(-200, -200)
     //.setPosition(495, 267)
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
  
  Group scene4 = cp5.addGroup("scene4");
  // Screen 4 
  {
    cp5.addTextlabel("headerScene4")
     .setText("Block 1 out of 3, done")
     .setFont(headerControlFont)
     .setColor(textDefaultColour)
     .setPosition(32, 32)
     .setGroup(scene4)
     ;
     
  cp5.addTextlabel("block1DoneText")
     .setText("You are done with a block, to begin the next click on the button below")
     .setFont(defaultCopyControlFont)
     .setColor(textDefaultColour)
     .setPosition(32, 102)
     .setGroup(scene4)
     ;
     
     cp5.addButton("nextToTrialTwo")
     .setCaptionLabel("Next: Begin Trial")
     .setValue(0)
     .setPosition(32, 155)
     .setSize(330, PrimaryButtonHeight)
     .setColorBackground(buttonPrimaryDefaultBgColour)
     .setFont(buttonLabelControlFont)
     .setGroup(scene4)
     ;
     
    // Hide Scene 4 elements
    scene4.hide();
  }
  
  Group scene5 = cp5.addGroup("scene5");
  // Screen 5
  {
    cp5.addButton("startTrialTwo")
     .setCaptionLabel("Start")
     .setValue(0)
     .setPosition(330, 207)
     .setSize(140, PrimaryButtonHeight)
     .setColorBackground(buttonPrimaryDefaultBgColour)
     .setFont(buttonLabelControlFont)
     .setGroup(scene5)
     ;
     
     cp5.addButton("buttonTopLeftBlock2")
     .setCaptionLabel(" ")
     .setValue(0)
     .setPosition(165, 139)
     .setSize(140, PrimaryButtonHeight)
     .setColorBackground(buttonPrimaryLockedBgColour)
     .setFont(buttonLabelControlFont)
     .lock()
     .setGroup(scene5)
     ;
     
     cp5.addButton("buttonBottomLeftBlock2")
     .setCaptionLabel(" ")
     .setValue(0)
     .setPosition(165, 275)
     .setSize(140, PrimaryButtonHeight)
     .setColorBackground(buttonPrimaryLockedBgColour)
     .setFont(buttonLabelControlFont)
     .lock()
     .setGroup(scene5)
     ;
     
     cp5.addButton("buttonTopRightBlock2")
     .setCaptionLabel(" ")
     .setValue(0)
     .setPosition(495, 139)
     .setSize(140, PrimaryButtonHeight)
     .setColorBackground(buttonPrimaryLockedBgColour)
     .setFont(buttonLabelControlFont)
     .lock()
     .setGroup(scene5)
     ;
     
     cp5.addButton("buttonBottomRightBlock2")
     .setCaptionLabel(" ")
     .setValue(0)
     .setPosition(495, 275)
     .setSize(140, PrimaryButtonHeight)
     .setColorBackground(buttonPrimaryLockedBgColour)
     .setFont(buttonLabelControlFont)
     .lock()
     .setGroup(scene5)
     ;
     
     cp5.addButton("buttonTargetBlock2")
     .setCaptionLabel(" ")
     .setValue(0)
     .setPosition(-200, -200)
     //.setPosition(495, 267)
     .setSize(140, PrimaryButtonHeight)
     .setColorBackground(buttonAltPrimaryDefaultBgColour)
     .setColorForeground(buttonAltPrimaryHoverBgColour)
     .setColorActive(buttonAltPrimaryPressedBgColour)
     .setFont(buttonLabelControlFont)
     //.lock()
     .setGroup(scene5)
     ;
    
    // Hide Scene 5 elements
    scene5.hide();
  }
  
  Group scene6 = cp5.addGroup("scene6");
  // Screen 6 
  {
    cp5.addTextlabel("headerScene6")
     .setText("Block 2 out of 3, done")
     .setFont(headerControlFont)
     .setColor(textDefaultColour)
     .setPosition(32, 32)
     .setGroup(scene6)
     ;
     
  cp5.addTextlabel("block2DoneText")
     .setText("You are done with another block, to begin the next click on the button below")
     .setFont(defaultCopyControlFont)
     .setColor(textDefaultColour)
     .setPosition(32, 102)
     .setGroup(scene6)
     ;
     
     cp5.addButton("nextToTrialThree")
     .setCaptionLabel("Next: Begin Trial")
     .setValue(0)
     .setPosition(32, 155)
     .setSize(330, PrimaryButtonHeight)
     .setColorBackground(buttonPrimaryDefaultBgColour)
     .setFont(buttonLabelControlFont)
     .setGroup(scene6)
     ;
     
    // Hide Scene 6 elements
    scene6.hide();
  }

  Group scene7 = cp5.addGroup("scene7");
  // Screen 7
  {
    cp5.addButton("startTrialThree")
     .setCaptionLabel("Start")
     .setValue(0)
     .setPosition(330, 207)
     .setSize(140, PrimaryButtonHeight)
     .setColorBackground(buttonPrimaryDefaultBgColour)
     .setFont(buttonLabelControlFont)
     .setGroup(scene7)
     ;
     
     cp5.addButton("buttonTopTopLeftBlock3")
     .setCaptionLabel(" ")
     .setValue(0)
     .setPosition(236, 113)
     .setSize(140, PrimaryButtonHeight)
     .setColorBackground(buttonPrimaryLockedBgColour)
     .setFont(buttonLabelControlFont)
     .lock()
     .setGroup(scene7)
     ;
     
     cp5.addButton("buttonTopLeftBlock3")
     .setCaptionLabel(" ")
     .setValue(0)
     .setPosition(116, 176)
     .setSize(140, PrimaryButtonHeight)
     .setColorBackground(buttonPrimaryLockedBgColour)
     .setFont(buttonLabelControlFont)
     .lock()
     .setGroup(scene7)
     ;
     
     cp5.addButton("buttonBottomLeftBlock3")
     .setCaptionLabel(" ")
     .setValue(0)
     .setPosition(116, 239)
     .setSize(140, PrimaryButtonHeight)
     .setColorBackground(buttonPrimaryLockedBgColour)
     .setFont(buttonLabelControlFont)
     .lock()
     .setGroup(scene7)
     ;
     
     cp5.addButton("buttonBottomBottomLeftBlock3")
     .setCaptionLabel(" ")
     .setValue(0)
     .setPosition(236, 302)
     .setSize(140, PrimaryButtonHeight)
     .setColorBackground(buttonPrimaryLockedBgColour)
     .setFont(buttonLabelControlFont)
     .lock()
     .setGroup(scene7)
     ;
     
      cp5.addButton("buttonTopTopRightBlock3")
     .setCaptionLabel(" ")
     .setValue(0)
     .setPosition(415, 113)
     .setSize(140, PrimaryButtonHeight)
     .setColorBackground(buttonPrimaryLockedBgColour)
     .setFont(buttonLabelControlFont)
     .lock()
     .setGroup(scene7)
     ;
     
     cp5.addButton("buttonTopRightBlock3")
     .setCaptionLabel(" ")
     .setValue(0)
     .setPosition(545, 176)
     .setSize(140, PrimaryButtonHeight)
     .setColorBackground(buttonPrimaryLockedBgColour)
     .setFont(buttonLabelControlFont)
     .lock()
     .setGroup(scene7)
     ;
     
     cp5.addButton("buttonBottomRightBlock3")
     .setCaptionLabel(" ")
     .setValue(0)
     .setPosition(545, 239)
     .setSize(140, PrimaryButtonHeight)
     .setColorBackground(buttonPrimaryLockedBgColour)
     .setFont(buttonLabelControlFont)
     .lock()
     .setGroup(scene7)
     ;
     
     cp5.addButton("buttonBottomBottomRightBlock3")
     .setCaptionLabel(" ")
     .setValue(0)
     .setPosition(415, 302)
     .setSize(140, PrimaryButtonHeight)
     .setColorBackground(buttonPrimaryLockedBgColour)
     .setFont(buttonLabelControlFont)
     .lock()
     .setGroup(scene7)
     ;
     
     cp5.addButton("buttonTargetBlock3")
     .setCaptionLabel(" ")
     .setValue(0)
     .setPosition(-200, -200)
     //.setPosition(495, 267)
     .setSize(140, PrimaryButtonHeight)
     .setColorBackground(buttonAltPrimaryDefaultBgColour)
     .setColorForeground(buttonAltPrimaryHoverBgColour)
     .setColorActive(buttonAltPrimaryPressedBgColour)
     .setFont(buttonLabelControlFont)
     //.lock()
     .setGroup(scene7)
     ;
    
    // Hide Scene 7 elements
    scene7.hide();
  }
  
  Group sceneEnd = cp5.addGroup("sceneEnd");
  // Screen End 
  {
    cp5.addTextlabel("headerSceneEnd")
     .setText("Thank you for participating in the assignment!")
     .setFont(headerControlFont)
     .setColor(textDefaultColour)
     .setPosition(32, 32)
     .setGroup(sceneEnd)
     ;
     
  cp5.addTextlabel("block3DoneText")
     .setText("Please copy the console output and send it to us via Teams or Email")
     .setFont(defaultCopyControlFont)
     .setColor(textDefaultColour)
     .setPosition(32, 102)
     .setGroup(sceneEnd)
     ;
     
     cp5.addButton("exitButton")
     .setCaptionLabel("Exit")
     .setValue(0)
     .setPosition(32, 155)
     .setSize(330, PrimaryButtonHeight)
     .setColorBackground(buttonPrimaryDefaultBgColour)
     .setFont(buttonLabelControlFont)
     .setGroup(sceneEnd)
     ;
     
    // Hide Scene elements
    sceneEnd.hide();
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
    
    // Set up the header row of output
    print("User_Id" + "\t" +  "Block_no" + "\t" + "Trial_no" + "\t" + "Elapsed_time" + "\t" + "Error_count"  + "\n");
    
    
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

// Increment error count every time a mouseclick happens
void mouseClicked() {
  COUNT_ERRORS += 1;
}

int[] trialOnePosX = {165, 495};
int[] trialOnePosY = {207, 207};
int NO_OF_TARGETS_BLOCK_1 = 2;

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
    int position_index =  floor(random(NO_OF_TARGETS_BLOCK_1));
    
    // Set the target button to the random position and bring to front
    ((Button)cp5.getController("buttonTargetBlock1")).setPosition( trialOnePosX[position_index], trialOnePosY[position_index]);    
    ((Button)cp5.getController("buttonTargetBlock1")).bringToFront();  
    
    // Start the timer 
    START_TIME = millis();
    
    // Refresh the error count 
    COUNT_ERRORS = -1; // one for clicking target
}
  
  // Enable on first loop 
  if(enableStartTrialOneButton == false) {
    enableStartTrialOneButton = true;
  }
}

public void buttonTargetBlock1(int theValue) {
  
  if(enableTargetBlock1Button){
    
    // Assignment data points
    print(USER_ID + "\t" +  BLOCK_NO + "\t" + TRIAL_NO + "\t" + (millis() - START_TIME) + "\t" + COUNT_ERRORS + "\n");
    
    // Enable the start button 
    ((Button)cp5.getController("startTrialOne")).unlock();
    ((Button)cp5.getController("startTrialOne")).setColorBackground(buttonPrimaryDefaultBgColour);
    
    // Enable other buttons and bring to front
    ((Button)cp5.getController("buttonRightBlock1")).lock();
    ((Button)cp5.getController("buttonRightBlock1")).setColorBackground(buttonPrimaryLockedBgColour);
    ((Button)cp5.getController("buttonRightBlock1")).bringToFront(); 
    
    ((Button)cp5.getController("buttonLeftBlock1")).lock();
    ((Button)cp5.getController("buttonLeftBlock1")).setColorBackground(buttonPrimaryLockedBgColour);
    ((Button)cp5.getController("buttonRightBlock1")).bringToFront(); 
    
    // Hackfix for rendering error 
    // Set the target button to the out of screen position\
    ((Button)cp5.getController("buttonTargetBlock1")).setPosition( -200, -200);  
    
    // Increment the trial counter 
    TRIAL_NO += 1;
        
    // Check if no. of trials are elapsed, move to next scene
    if(TRIAL_NO > TOTAL_TRIALS_IN_BLOCK)  {
      print("-----" + "\t" +  "-----" + "\t" + "-----" + "\t" + "-----" + "\t" + "-----"  + "\n");
      
      // Hide Scene 3 elements
      cp5.getGroup("scene3").hide();
      
      // Show Scene 4 elements
      cp5.getGroup("scene4").show();
    }
  }
  
  // Enable on the first loop 
  if(enableTargetBlock1Button == false) {
    enableTargetBlock1Button = true;
  }
}
//============================ END OF BLOCK 1 LOGIC ==========================// 






public void nextToTrialTwo(int theValue){
  
  if(enableNextToTrialTwoButton) {
    
    // Set up first block of trials 
    BLOCK_NO = 2; 
    TRIAL_NO = 1;
    
    // Hide Scene 4 elements
    cp5.getGroup("scene4").hide();
    
    // Show Scene 5 elements
    cp5.getGroup("scene5").show();
    
  }
  
  // Enable on first loop 
  if(enableNextToTrialTwoButton == false) {
    enableNextToTrialTwoButton = true;
  }
}

int[] trialTwoPosX = {165, 165, 495, 495};
int[] trialTwoPosY = {139, 275, 139, 275};
int NO_OF_TARGETS_BLOCK_2 = 4;

public void startTrialTwo(int theValue) {
  
  if(enableStartTrialTwoButton) {
    // Disable the start button 
    ((Button)cp5.getController("startTrialTwo")).lock();
    ((Button)cp5.getController("startTrialTwo")).setColorBackground(buttonPrimaryLockedBgColour);
    
    // Enable other buttons
    ((Button)cp5.getController("buttonTopLeftBlock2")).unlock();
    ((Button)cp5.getController("buttonTopLeftBlock2")).setColorBackground(buttonPrimaryDefaultBgColour);
    
    ((Button)cp5.getController("buttonBottomLeftBlock2")).unlock();
    ((Button)cp5.getController("buttonBottomLeftBlock2")).setColorBackground(buttonPrimaryDefaultBgColour);
    
    
    ((Button)cp5.getController("buttonTopRightBlock2")).unlock();
    ((Button)cp5.getController("buttonTopRightBlock2")).setColorBackground(buttonPrimaryDefaultBgColour);
    
    ((Button)cp5.getController("buttonBottomRightBlock2")).unlock();
    ((Button)cp5.getController("buttonBottomRightBlock2")).setColorBackground(buttonPrimaryDefaultBgColour);
    
    // Choose a random position 
    int position_index =  floor(random(NO_OF_TARGETS_BLOCK_2));
    
    // Set the target button to the random position and bring to front
    ((Button)cp5.getController("buttonTargetBlock2")).setPosition( trialTwoPosX[position_index], trialTwoPosY[position_index]);    
    ((Button)cp5.getController("buttonTargetBlock2")).bringToFront();  
    
    // Start the timer 
    START_TIME = millis();
    
    // Refresh the error count 
    COUNT_ERRORS = -1; // one for clicking target
}
  
  // Enable on first loop 
  if(enableStartTrialTwoButton == false) {
    enableStartTrialTwoButton = true;
  }
}

public void buttonTargetBlock2(int theValue) {
  
  if(enableTargetBlock2Button){
    
    // Assignment data points
    print(USER_ID + "\t" +  BLOCK_NO + "\t" + TRIAL_NO + "\t" + (millis() - START_TIME) + "\t" + COUNT_ERRORS + "\n");
    
    // Enable the start button 
    ((Button)cp5.getController("startTrialTwo")).unlock();
    ((Button)cp5.getController("startTrialTwo")).setColorBackground(buttonPrimaryDefaultBgColour);
    
    
    // Enable other buttons and bring to front
    ((Button)cp5.getController("buttonTopLeftBlock2")).lock();
    ((Button)cp5.getController("buttonTopLeftBlock2")).setColorBackground(buttonPrimaryLockedBgColour);
    ((Button)cp5.getController("buttonTopLeftBlock2")).bringToFront(); 
    
    ((Button)cp5.getController("buttonBottomLeftBlock2")).lock();
    ((Button)cp5.getController("buttonBottomLeftBlock2")).setColorBackground(buttonPrimaryLockedBgColour);
    ((Button)cp5.getController("buttonBottomLeftBlock2")).bringToFront(); 
    
    ((Button)cp5.getController("buttonTopRightBlock2")).lock();
    ((Button)cp5.getController("buttonTopRightBlock2")).setColorBackground(buttonPrimaryLockedBgColour);
    ((Button)cp5.getController("buttonTopRightBlock2")).bringToFront(); 
    
    ((Button)cp5.getController("buttonBottomRightBlock2")).lock();
    ((Button)cp5.getController("buttonBottomRightBlock2")).setColorBackground(buttonPrimaryLockedBgColour);
    ((Button)cp5.getController("buttonBottomRightBlock2")).bringToFront(); 
    
    
    // Hackfix for rendering error 
    // Set the target button to the out of screen position\
    ((Button)cp5.getController("buttonTargetBlock2")).setPosition( -200, -200);  
    
    // Increment the trial counter 
    TRIAL_NO += 1;
        
    // Check if no. of trials are elapsed, move to next scene
    if(TRIAL_NO > TOTAL_TRIALS_IN_BLOCK)  {
      print("-----" + "\t" +  "-----" + "\t" + "-----" + "\t" + "-----" + "\t" + "-----"  + "\n");
      
      // Hide Scene 5 elements
      cp5.getGroup("scene5").hide();
      
      // Show Scene 6 elements
      cp5.getGroup("scene6").show();
    }
  }
  
  // Enable on the first loop 
  if(enableTargetBlock2Button == false) {
    enableTargetBlock2Button = true;
  }
}
//============================ END OF BLOCK 2 LOGIC ==========================// 




public void nextToTrialThree(int theValue){
  
  if(enableNextToTrialThreeButton) {
    
    // Set up first block of trials 
    BLOCK_NO = 3; 
    TRIAL_NO = 1;
    
    // Hide Scene 6 elements
    cp5.getGroup("scene6").hide();
    
    // Show Scene 7 elements
    cp5.getGroup("scene7").show();
    
  }
  
  // Enable on first loop 
  if(enableNextToTrialThreeButton == false) {
    enableNextToTrialThreeButton = true;
  }
}

int[] trialThreePosX = {236, 116, 116, 236, 415, 545, 545, 415};
int[] trialThreePosY = {113, 176, 239, 302, 113, 176, 239, 302};
int NO_OF_TARGETS_BLOCK_3 = 8;

public void startTrialThree(int theValue) {
  
  if(enableStartTrialThreeButton) {
    // Disable the start button 
    ((Button)cp5.getController("startTrialThree")).lock();
    ((Button)cp5.getController("startTrialThree")).setColorBackground(buttonPrimaryLockedBgColour);
    
    // Enable other buttons
    ((Button)cp5.getController("buttonTopTopLeftBlock3")).unlock();
    ((Button)cp5.getController("buttonTopTopLeftBlock3")).setColorBackground(buttonPrimaryDefaultBgColour);
    
    ((Button)cp5.getController("buttonTopLeftBlock3")).unlock();
    ((Button)cp5.getController("buttonTopLeftBlock3")).setColorBackground(buttonPrimaryDefaultBgColour);
    
    ((Button)cp5.getController("buttonBottomLeftBlock3")).unlock();
    ((Button)cp5.getController("buttonBottomLeftBlock3")).setColorBackground(buttonPrimaryDefaultBgColour);
    
    ((Button)cp5.getController("buttonBottomBottomLeftBlock3")).unlock();
    ((Button)cp5.getController("buttonBottomBottomLeftBlock3")).setColorBackground(buttonPrimaryDefaultBgColour);
    
    
    ((Button)cp5.getController("buttonTopTopRightBlock3")).unlock();
    ((Button)cp5.getController("buttonTopTopRightBlock3")).setColorBackground(buttonPrimaryDefaultBgColour);
    
    ((Button)cp5.getController("buttonTopRightBlock3")).unlock();
    ((Button)cp5.getController("buttonTopRightBlock3")).setColorBackground(buttonPrimaryDefaultBgColour);
    
    ((Button)cp5.getController("buttonBottomRightBlock3")).unlock();
    ((Button)cp5.getController("buttonBottomRightBlock3")).setColorBackground(buttonPrimaryDefaultBgColour);
    
    ((Button)cp5.getController("buttonBottomBottomRightBlock3")).unlock();
    ((Button)cp5.getController("buttonBottomBottomRightBlock3")).setColorBackground(buttonPrimaryDefaultBgColour);
    
    // Choose a random position 
    int position_index =  floor(random(NO_OF_TARGETS_BLOCK_3));
    
    // Set the target button to the random position and bring to front
    ((Button)cp5.getController("buttonTargetBlock3")).setPosition( trialThreePosX[position_index], trialThreePosY[position_index]);    
    ((Button)cp5.getController("buttonTargetBlock3")).bringToFront();  
    
    // Start the timer 
    START_TIME = millis();
    
    // Refresh the error count 
    COUNT_ERRORS = -1; // one for clicking target
  }
  
  // Enable on first loop 
  if(enableStartTrialThreeButton == false) {
    enableStartTrialThreeButton = true;
  }
}

public void buttonTargetBlock3(int theValue) {
  
  if(enableTargetBlock3Button){
    
    // Assignment data points
    print(USER_ID + "\t" +  BLOCK_NO + "\t" + TRIAL_NO + "\t" + (millis() - START_TIME) + "\t" + COUNT_ERRORS + "\n");
    
    // Enable the start button 
    ((Button)cp5.getController("startTrialThree")).unlock();
    ((Button)cp5.getController("startTrialThree")).setColorBackground(buttonPrimaryDefaultBgColour);
    
    
    // Enable other buttons and bring to front
    ((Button)cp5.getController("buttonTopTopLeftBlock3")).lock();
    ((Button)cp5.getController("buttonTopTopLeftBlock3")).setColorBackground(buttonPrimaryLockedBgColour);
    ((Button)cp5.getController("buttonTopTopLeftBlock3")).bringToFront(); 
    
    ((Button)cp5.getController("buttonTopLeftBlock3")).lock();
    ((Button)cp5.getController("buttonTopLeftBlock3")).setColorBackground(buttonPrimaryLockedBgColour);
    ((Button)cp5.getController("buttonTopLeftBlock3")).bringToFront(); 
    
    ((Button)cp5.getController("buttonBottomLeftBlock3")).lock();
    ((Button)cp5.getController("buttonBottomLeftBlock3")).setColorBackground(buttonPrimaryLockedBgColour);
    ((Button)cp5.getController("buttonBottomLeftBlock3")).bringToFront(); 
    
    ((Button)cp5.getController("buttonBottomBottomLeftBlock3")).lock();
    ((Button)cp5.getController("buttonBottomBottomLeftBlock3")).setColorBackground(buttonPrimaryLockedBgColour);
    ((Button)cp5.getController("buttonBottomBottomLeftBlock3")).bringToFront(); 
    
    
    ((Button)cp5.getController("buttonTopTopRightBlock3")).lock();
    ((Button)cp5.getController("buttonTopTopRightBlock3")).setColorBackground(buttonPrimaryLockedBgColour);
    ((Button)cp5.getController("buttonTopTopRightBlock3")).bringToFront(); 
    
    ((Button)cp5.getController("buttonTopRightBlock3")).lock();
    ((Button)cp5.getController("buttonTopRightBlock3")).setColorBackground(buttonPrimaryLockedBgColour);
    ((Button)cp5.getController("buttonTopRightBlock3")).bringToFront(); 
    
    ((Button)cp5.getController("buttonBottomRightBlock3")).lock();
    ((Button)cp5.getController("buttonBottomRightBlock3")).setColorBackground(buttonPrimaryLockedBgColour);
    ((Button)cp5.getController("buttonBottomRightBlock3")).bringToFront(); 
    
    ((Button)cp5.getController("buttonBottomBottomRightBlock3")).lock();
    ((Button)cp5.getController("buttonBottomBottomRightBlock3")).setColorBackground(buttonPrimaryLockedBgColour);
    ((Button)cp5.getController("buttonBottomBottomRightBlock3")).bringToFront(); 
    
    
    // Hackfix for rendering error 
    // Set the target button to the out of screen position\
    ((Button)cp5.getController("buttonTargetBlock3")).setPosition( -200, -200);  
    
    // Increment the trial counter 
    TRIAL_NO += 1;
        
    // Check if no. of trials are elapsed, move to next scene
    if(TRIAL_NO > TOTAL_TRIALS_IN_BLOCK)  {
      print("-----" + "\t" +  "-----" + "\t" + "-----" + "\t" + "-----" + "\t" + "-----"  + "\n");
      
      // Hide Scene 7 elements
      cp5.getGroup("scene7").hide();
      
      // Show Ending Scene elements
      cp5.getGroup("sceneEnd").show();
    }
  }
  
  // Enable on the first loop 
  if(enableTargetBlock3Button == false) {
    enableTargetBlock3Button = true;
  }
}
//============================ END OF BLOCK 3 LOGIC ==========================// 


public void exitButton(int theValue){
  
  if(enableExitButton) {
    exit();
  }
  
  // Enable on first loop 
  if(enableExitButton == false) {
    enableExitButton = true;
  }
}
