// TODO: 
// Check if CP5 is compatible with the proposed architecture [NOPE]
// Make toolbox state bool-list with feedback module [DONE] 
//  |- Shortcuts [DONE] 
//  '- Gestures [Yet to start]
// 
// Make an editor [DONE]  

long UUID;
long totalNoOfClicks;
long totalNoOfKeyPressed;
int shapesDrawnLast;


int appState = 0;
// App states 
// 0 - Start screen 
// 1 - Tutorial - Shortcut - free-form line 

int editorShapeIndex = -1;
String[] shapeOptions = {"free_form_line", "straight_line", "rectangle", "oval"};
String[] shapeOptionDisplays = {"Free-form line", "Straight line", "Rectangle", "Oval"};

int editorColourIndex = 0;
int[] colourOptions = {color(53, 53, 77),    // black
                     color(239, 93, 93),     // red 
                     color(117, 208, 126),   // green
                     color(93, 169, 239)};   // blue
                     
int[] colourOptionsAlpha = {color(53, 53, 77, 102),    // black
                     color(239, 93, 93, 102),          // red 
                     color(117, 208, 126, 102),        // green
                     color(93, 169, 239, 102)};        // blue
                     
String[] colourOptionDisplays = { "Black", "Red", "Green", "Blue" };
                     
int editorWeightIndex = 1;
int[] weightOptions = {1,  // thin
                       4,  // medium
                       8}; // thick
String[] weightOptionDisplays = {"Thin", "Medium", "Thick"};


// Already drawn list of shapes
ArrayList<PShape> drawnShapeList = new ArrayList<PShape>();

// Undo helper function
void undoLastDrawnShape(){
  // Gauard clause
    if(drawnShapeList.size() > 0){
         drawnShapeList.remove(drawnShapeList.size() - 1);
    }
}
// Flush all shapes
void clearAllDrawnShapes(){
  drawnShapeList.clear();
}


// Present shape being drawn (not necessarily added)
int strokeColour = color(0);  // Debug values 
int strokeWeight = 56;        // Debug values
int defaultShapeFillColour = color(255, 255, 255, 0); // Default unfilled shapes
PShape currentDrawnShape;

PShape currentRectangleShape;
PVector rectangleStartPoint = new PVector(0,0); // Debug values

PShape currentOvalShape;
PVector ovalStartPoint = new PVector(0,0); // Debug values



int PrimaryButtonHeight = 36;
int TextInputHeight = 36;
int defaultBorderWeight = 1;

// -Colours 
int screenBgColour = color(244, 245, 251);

int buttonPrimaryDefaultBgColour = color(93, 95, 231);
int buttonPrimaryHoverBgColour = color(125, 127, 242);
int buttonPrimaryPressedBgColour = color(65, 67, 236);
int buttonPrimaryInactiveBgColour = color(190, 191, 249);

int textFieldBgColour = color(235, 235, 235);

int textDefaultColour = color(0);
int textInactiveColour = color(148);
int textButtonPrimaryLabelColour = color(255);

int drawingAreaBgColour = color(255);
int defaultBorderColour = color(188);

// -Fonts
PFont headerPFont;
PFont captionPFont;
PFont defaultCopyPFont;
PFont boldCopyPFont;
PFont buttonLabelPFont;
PFont currentSettingsLabelPFont;

// Images
PImage checkCircleGreenImage;


// Screenwise variables 
// - Start 
int buttonNextTutorialShortcutFreeformLineBgColour = buttonPrimaryDefaultBgColour;

// - Tutorial: Free-form with Shortcut
boolean tutFreeformSelectedShortcut = false;
boolean tutFreeformDrawnShortcut = false;
int buttonNextTutorialShortcutStraightLineBgColour = buttonPrimaryInactiveBgColour;
boolean buttonNextTutorialShortcutStraightLineActivated = false;

// - Tutorial: Straight line with Shortcut
boolean tutStraightSelectedShortcut = false;
boolean tutStraightDrawnShortcut = false;
int buttonNextTutorialShortcutRectangleBgColour = buttonPrimaryInactiveBgColour;
boolean buttonNextTutorialShortcutRectangleActivated = false;

// - Tutorial: Rectangle with Shortcut
boolean tutRectangleSelectedShortcut = false;
boolean tutRectangleDrawnShortcut = false;
int buttonNextTutorialShortcutOvalBgColour = buttonPrimaryInactiveBgColour;
boolean buttonNextTutorialShortcutOvalActivated = false;

// - Tutorial: Oval with Shortcut
boolean tutOvalSelectedShortcut = false;
boolean tutOvalDrawnShortcut = false;
int buttonNextTutorialShortcutColourBgColour = buttonPrimaryInactiveBgColour;
boolean buttonNextTutorialShortcutColourActivated = false;

// - Tutorial: Colours with Shortcut
boolean tutColour1SelectedShortcut = false;
boolean tutColour2SelectedShortcut = false;
boolean tutColour3SelectedShortcut = false; 
boolean tutColour4SelectedShortcut = false; 
boolean tutAllColoursSelectedShortcut = false;

boolean tutColour1DrawnShortcut = false;
boolean tutColour2DrawnShortcut = false;
boolean tutColour3DrawnShortcut = false; 
boolean tutColour4DrawnShortcut = false; 
boolean tutDrawnWithAllColoursShortcut = false;
int buttonNextTutorialShortcutWeightBgColour = buttonPrimaryInactiveBgColour;
boolean buttonNextTutorialShortcutWeightActivated = false;

// - Tutorial: Weights with Shortcut
boolean tutWeight1SelectedShortcut = false;
boolean tutWeight2SelectedShortcut = false;
boolean tutWeight3SelectedShortcut = false; 
boolean tutAllWeightsSelectedShortcut = false;

boolean tutWeight1DrawnShortcut = false;
boolean tutWeight2DrawnShortcut = false;
boolean tutWeight3DrawnShortcut = false; 
boolean tutDrawnWithAllWeightsShortcut = false;
int buttonNextTutorialShortcutUndoBgColour = buttonPrimaryInactiveBgColour;
boolean buttonNextTutorialShortcutUndoActivated = false;

// Tutorial: Undo 
boolean tut3ShapesDrawnShortcut = false;
boolean tut3DeletedShortcut = false;
int buttonNextTutorialShortcutReviewBgColour = buttonPrimaryInactiveBgColour;
boolean buttonNextTutorialShortcutReviewActivated = false;

// - Review 
int buttonNextTask1ShortcutBgColour = buttonPrimaryDefaultBgColour;

// - Drawing Task 1
int buttonNextTask2ShortcutBgColour = buttonPrimaryDefaultBgColour;

// - Drawing Task 2
int buttonNextConclusionShortcutBgColour = buttonPrimaryDefaultBgColour;

// - Conclusion
int buttonExitBgColour = buttonPrimaryDefaultBgColour;


void setup() {
  size(800, 450);
  
  // Book-keeping
  UUID = System.currentTimeMillis();
  println("UUID: ", UUID);
  
  totalNoOfClicks = 0;
  shapesDrawnLast = 0;
  
  // To keep drawing interaction consistent 
  rectMode(CORNERS);
  // To keep drawing interaction natural
  ellipseMode(RADIUS);
  
  // -Fonts
  headerPFont = createFont("Arial Bold", 26);
  captionPFont = createFont("Arial", 16);
  defaultCopyPFont = createFont("Arial", 18);
  boldCopyPFont = createFont("Arial Bold", 18);
  buttonLabelPFont = createFont("Arial", 16);
  currentSettingsLabelPFont = createFont("Arial", 14);
  
  // -Images
  checkCircleGreenImage = loadImage("check_circle_green.png");
  
  
  // Shape specifics are manipulated in mouseDragged
  // Shape drawing ends and a new shape is initialised onMouseReleased
  
  // Debug [WORKS] 
  // println("Debug log:");
  // println(" Shapes options:");
  // println(" ", shapeOptions[0], ",", shapeOptions[1], ",", shapeOptions[2], ",", shapeOptions[3]);
  // println(" Colour options:");
  // println(" ", colourOptions[0], ",", colourOptions[1], ",", colourOptions[2], ",", colourOptions[3]);
  // println(" Weight options:");
  // println(" ", weightOptions[0], ",", weightOptions[1], ",", weightOptions[2]);
}


// App state display if-else ladder
void draw() {
  if(appState == 0) {
    startScreen();
  } else if (appState == 1) {
    tutorialShortcutFreeformlineScreen();
  } else if (appState == 2) {
    tutorialShortcutStraightlineScreen();
  } else if (appState == 3) {
    tutorialShortcutRectangleScreen();
  } else if (appState == 4) {
    tutorialShortcutOvalScreen();
  } else if (appState == 5) {
    tutorialShortcutColoursScreen();
  } else if (appState == 6) {
    tutorialShortcutWeightsScreen();
  } else if (appState == 7) {
    tutorialShortcutUndoScreen();
  } else if (appState == 8) {
    reviewKeyboardShortcutsScreen();
  } else if (appState == 9) {
    drawingTask1Screen();
  } else if (appState == 10) {
    drawingTask2Screen();
  } else if (appState == 11) {
    endingScreen();
  }
}

// Screen content

// Assignment title and user id input
void startScreen() {
  
  background(screenBgColour);
 
  fill(textDefaultColour);
  textFont(headerPFont);
  text("CS6065: Assignment 2 - Keyboard Shortcuts", 32, 58);
  
  textFont(captionPFont);
  text("Augmented Interactions: Evaluating parallel interaction schemes for memorability and usability", 32, 87);
 
  textFont(defaultCopyPFont);
  text("Harshita · Shubham · Avinaba", 32, 138);
  
  noStroke();
  fill(buttonNextTutorialShortcutFreeformLineBgColour);
  rect(32, 381, 362, 417, 4);
  
  fill(textButtonPrimaryLabelColour);
  textFont(buttonLabelPFont);
  text("Next: Free-form line", 127, 404);
  
}



// Helper functions 
void drawDrawArea(int startX, int startY, int endX, int endY){
  int borderRadius = 4;
  // TODO: Guard clauses
  
  // Draw rounded rectangle
  stroke(defaultBorderColour);
  strokeWeight(defaultBorderWeight);
  fill(drawingAreaBgColour);
  rect(startX, startY, endX, endY, borderRadius);
  
}

void drawCurrentSettings(int startX, int startY, boolean section1Active, boolean section2Active, boolean section3Active) {
  int endX = startX + 193;
  int endY = startY + 116;
  int borderRadius = 4;
  
  int separator1_Y = startY + 37;
  int separator2_Y = startY + 74;
  
  int labelX = startX + 12;
  int valueTextX = startX + 61;
  
  int label_line1_Y = startY + 11 + 14;
  int label_line2_Y = startY + 48 + 14;
  int label_line3_Y = startY + 89 + 14;
  
  
  
  // TODO: Gaurd clauses
  
  // Draw rounded rectangle 
  stroke(defaultBorderColour);
  strokeWeight(defaultBorderWeight);
  fill(screenBgColour);
  rect(startX, startY, endX, endY, borderRadius);
  
  // Draw separators
  line(startX, separator1_Y, endX, separator1_Y);
  line(startX, separator2_Y, endX, separator2_Y);
  
  
  // Populate labels
  // Sections may be turned inactive to draw participant's attention to a single mechanic
  
  // Check if section is active
  if(section1Active) {
    fill(textDefaultColour);
  } else {
    fill(textInactiveColour);
  }
  
  textFont(currentSettingsLabelPFont);
  // Selected shape 
  text("Shape:", labelX, label_line1_Y);
  // Gaurd clause
  if(editorShapeIndex >= 0 && editorShapeIndex <= 3) {
    text(shapeOptionDisplays[editorShapeIndex], valueTextX, label_line1_Y);
  } 
  // Forced unset 
  else {
    text("None", valueTextX, label_line1_Y);
  }
  
   // Check if section is active
  if(section2Active) {
    fill(textDefaultColour);
  } else {
    fill(textInactiveColour);
  }
  // Selected Colour 
  text("Colour:", labelX, label_line2_Y);
  // Gaurd clause
  if(editorColourIndex >= 0 && editorColourIndex <= 3) {
    text(colourOptionDisplays[editorColourIndex], valueTextX, label_line2_Y);
  } 
  // Forced unset 
  else {
    text("None", valueTextX, label_line2_Y);
  }
  
   // Check if section is active
  if(section3Active) {
    fill(textDefaultColour);
  } else {
    fill(textInactiveColour);
  }
  // Selected Weight 
  text("Weight:", labelX, label_line3_Y);
  // Gaurd clause
  if(editorWeightIndex >= 0 && editorWeightIndex <= 2) {
    text(weightOptionDisplays[editorWeightIndex], valueTextX, label_line3_Y);
  } 
  // Forced unset 
  else {
    text("None", valueTextX, label_line3_Y);
  }
  
}

// Tutorial: Selecting free-form line with a shortcut key 
void tutorialShortcutFreeformlineScreen() {
  background(screenBgColour);
  
  fill(textDefaultColour);
  textFont(headerPFont);
  text("Tutorial: Draw Free-form line", 32, 58);
  
  // Check if selection task if free-form line selected
  if(editorShapeIndex == 0){
    tutFreeformSelectedShortcut = true;
  }
  // Then draw circle
  if(tutFreeformSelectedShortcut){
    image(checkCircleGreenImage, 32, 74, 18, 18);
  }
  textFont(defaultCopyPFont);
  text("Press “F” to select “Free-form line”", 58, 90);
  
  
  // Check if a single object has been drawn
  if(drawnShapeList.size() > 0){
    tutFreeformDrawnShortcut = true;
  }
  // Then draw circle
  if(tutFreeformDrawnShortcut){
    image(checkCircleGreenImage, 32, 104, 18, 18);
  }
  textFont(defaultCopyPFont);
  text("Left click and drag the pointer to draw", 58, 121);
  
  textFont(captionPFont);
  text("Drawing area", 32, 171);
  
  // Drawing area
  drawDrawArea(32, 181, 559, 365);
  
  // Display all the drawn shapes
  for(PShape drawnPShape : drawnShapeList){
    drawnPShape.setFill(defaultShapeFillColour);
    shape(drawnPShape);
  }
  
  fill(textDefaultColour);
  textFont(captionPFont);
  text("Current settings", 576, 171);
  
  // Editor status area 
  drawCurrentSettings(575, 181, true, false, false);
  
  // Update editor state for keyPresses
  // updateEditorKeyboardShortcuts();
  updateEditorKeyboardShortcutsOnlyFreeform();
  
  
  noStroke();
  
  // Check if tutorial tasks are done 
  if( tutFreeformSelectedShortcut && tutFreeformDrawnShortcut && !buttonNextTutorialShortcutStraightLineActivated) {    
    buttonNextTutorialShortcutStraightLineBgColour = buttonPrimaryDefaultBgColour;
    
    // Change colour only once, so Hover and Pressed state can work
    buttonNextTutorialShortcutStraightLineActivated = true;
  }
  
  fill(buttonNextTutorialShortcutStraightLineBgColour);
  rect(32, 381, 362, 417, 4);
  
  fill(textButtonPrimaryLabelColour);
  textFont(buttonLabelPFont);
  text("Next: Straight Line", 134, 404);
}

// Interactivity (Buttons)
// Mouse Hovers 
void mouseMoved(){
  
  // for Start screen   
  if(appState == 0) {
    //  - Hover on button: rect(32, 381, 362, 417, 4);
    if( mouseX >= 32 && mouseX <= 362 && mouseY >= 381 && mouseY <= 417 ) {
      buttonNextTutorialShortcutFreeformLineBgColour = buttonPrimaryHoverBgColour;
    } else {
      buttonNextTutorialShortcutFreeformLineBgColour = buttonPrimaryDefaultBgColour;
    }
  }
  
  // - Tutorial: Free-form with Shortcut
  else if(appState == 1) {
    //  - Hover on button: rect(32, 381, 362, 417, 4);
    if( mouseX >= 32 && mouseX <= 362 && mouseY >= 381 && mouseY <= 417 && tutFreeformSelectedShortcut && tutFreeformDrawnShortcut ) {
      buttonNextTutorialShortcutStraightLineBgColour = buttonPrimaryHoverBgColour;
    }
    else if( tutFreeformSelectedShortcut && tutFreeformDrawnShortcut ){
      buttonNextTutorialShortcutStraightLineBgColour = buttonPrimaryDefaultBgColour;
    }
  }
  
  // - Tutorial: Straight with Shortcut
  else if(appState == 2) {
    //  - Hover on button: rect(32, 381, 362, 417, 4);
    if( mouseX >= 32 && mouseX <= 362 && mouseY >= 381 && mouseY <= 417 && tutStraightSelectedShortcut && tutStraightDrawnShortcut ) {
      buttonNextTutorialShortcutRectangleBgColour = buttonPrimaryHoverBgColour;
    }
    else if( tutStraightSelectedShortcut && tutStraightDrawnShortcut ){
      buttonNextTutorialShortcutRectangleBgColour = buttonPrimaryDefaultBgColour;
    }
  }
  
  // - Tutorial: Rectangle with Shortcut
  else if(appState == 3) {
    //  - Hover on button: rect(32, 381, 362, 417, 4);
    if( mouseX >= 32 && mouseX <= 362 && mouseY >= 381 && mouseY <= 417 && tutRectangleSelectedShortcut && tutRectangleDrawnShortcut ) {
      buttonNextTutorialShortcutOvalBgColour = buttonPrimaryHoverBgColour;
    }
    else if( tutRectangleSelectedShortcut && tutRectangleDrawnShortcut ){
      buttonNextTutorialShortcutOvalBgColour = buttonPrimaryDefaultBgColour;
    }
  }
  
  
  // - Tutorial: Oval with Shortcut
  else if(appState == 4) {
    //  - Hover on button: rect(32, 381, 362, 417, 4);
    if( mouseX >= 32 && mouseX <= 362 && mouseY >= 381 && mouseY <= 417 && tutOvalSelectedShortcut && tutOvalDrawnShortcut ) {
      buttonNextTutorialShortcutColourBgColour = buttonPrimaryHoverBgColour;
    }
    else if( tutRectangleSelectedShortcut && tutRectangleDrawnShortcut ){
      buttonNextTutorialShortcutColourBgColour = buttonPrimaryDefaultBgColour;
    }
  }
  
  // - Tutorial: Colours with Shortcut
  else if(appState == 5) {
    //  - Hover on button: rect(32, 381, 362, 417, 4);
    if( mouseX >= 32 && mouseX <= 362 && mouseY >= 381 && mouseY <= 417 && tutAllColoursSelectedShortcut && tutDrawnWithAllColoursShortcut ) {
      buttonNextTutorialShortcutWeightBgColour = buttonPrimaryHoverBgColour;
    }
    else if( tutAllColoursSelectedShortcut && tutDrawnWithAllColoursShortcut ){
      buttonNextTutorialShortcutWeightBgColour = buttonPrimaryDefaultBgColour;
    }
  }
  
  // - Tutorial: Weights with Shortcut
  else if(appState == 6) {
    //  - Hover on button: rect(32, 381, 362, 417, 4);
    if( mouseX >= 32 && mouseX <= 362 && mouseY >= 381 && mouseY <= 417 && tutAllWeightsSelectedShortcut && tutDrawnWithAllWeightsShortcut ) {
      buttonNextTutorialShortcutUndoBgColour = buttonPrimaryHoverBgColour;
    }
    else if( tutAllWeightsSelectedShortcut && tutDrawnWithAllWeightsShortcut ){
      buttonNextTutorialShortcutUndoBgColour = buttonPrimaryDefaultBgColour;
    }
  }
  
  // - Tutorial: Undo
  else if(appState == 7) {
    //  - Hover on button: rect(32, 381, 362, 417, 4);
    if( mouseX >= 32 && mouseX <= 362 && mouseY >= 381 && mouseY <= 417 && tut3ShapesDrawnShortcut && tut3DeletedShortcut ) {
      buttonNextTutorialShortcutReviewBgColour = buttonPrimaryHoverBgColour;
    }
    else if( tutAllWeightsSelectedShortcut && tutDrawnWithAllWeightsShortcut ){
      buttonNextTutorialShortcutReviewBgColour = buttonPrimaryDefaultBgColour;
    }
  }
  
  // - Review: Keyboard Shortcuts 
  else if(appState == 8) {
    //  - Hover on button: rect(32, 381, 362, 417, 4);
    if( mouseX >= 32 && mouseX <= 362 && mouseY >= 381 && mouseY <= 417 ) {
      buttonNextTask1ShortcutBgColour = buttonPrimaryHoverBgColour;
    } else {
      buttonNextTask1ShortcutBgColour = buttonPrimaryDefaultBgColour;
    }
  }

  // - Drawing Task 1 
  else if(appState == 9) {
    //  - Hover on button: rect(32, 381, 362, 417, 4);
    if( mouseX >= 32 && mouseX <= 362 && mouseY >= 381 && mouseY <= 417 ) {
      buttonNextTask2ShortcutBgColour = buttonPrimaryHoverBgColour;
    } else {
      buttonNextTask2ShortcutBgColour = buttonPrimaryDefaultBgColour;
    }
  }
  
  // - Drawing Task 2 
  else if(appState == 10) {
    //  - Hover on button: rect(32, 381, 362, 417, 4);
    if( mouseX >= 32 && mouseX <= 362 && mouseY >= 381 && mouseY <= 417 ) {
      buttonNextConclusionShortcutBgColour = buttonPrimaryHoverBgColour;
    } else {
      buttonNextConclusionShortcutBgColour = buttonPrimaryDefaultBgColour;
    }
  }
  
  // - Conclusion
  else if(appState == 11) {
    //  - Hover on button: rect(32, 381, 362, 417, 4);
    if( mouseX >= 32 && mouseX <= 362 && mouseY >= 381 && mouseY <= 417 ) {
      buttonExitBgColour = buttonPrimaryHoverBgColour;
    } else {
      buttonExitBgColour = buttonPrimaryDefaultBgColour;
    }
  }
  
}

// Mouse Pressed  
void mousePressed(){
  
  // for Start screen   
  if(appState == 0) {
    //  - Press on button: rect(32, 381, 362, 417, 4);
    if( mouseX >= 32 && mouseX <= 362 && mouseY >= 381 && mouseY <= 417 ) {
      buttonNextTutorialShortcutFreeformLineBgColour = buttonPrimaryPressedBgColour;
    } else {
      buttonNextTutorialShortcutFreeformLineBgColour = buttonPrimaryDefaultBgColour;
    }
  }
  
  // - Tutorial: Free-form with Shortcut
  else if(appState == 1) {
    //  - Press on button: rect(32, 381, 362, 417, 4);
    if( mouseX >= 32 && mouseX <= 362 && mouseY >= 381 && mouseY <= 417 && tutFreeformSelectedShortcut && tutFreeformDrawnShortcut ) {
      buttonNextTutorialShortcutStraightLineBgColour = buttonPrimaryPressedBgColour;
    } else if( tutFreeformSelectedShortcut && tutFreeformDrawnShortcut ){
      buttonNextTutorialShortcutStraightLineBgColour = buttonPrimaryDefaultBgColour;
    }
   }
   
  // - Tutorial: Straight with Shortcut
  else if(appState == 2) {
    //  - Press on button: rect(32, 381, 362, 417, 4);
    if( mouseX >= 32 && mouseX <= 362 && mouseY >= 381 && mouseY <= 417 && tutStraightSelectedShortcut && tutStraightDrawnShortcut ) {
      buttonNextTutorialShortcutRectangleBgColour = buttonPrimaryPressedBgColour;
    } else if( tutFreeformSelectedShortcut && tutFreeformDrawnShortcut ){
      buttonNextTutorialShortcutRectangleBgColour = buttonPrimaryDefaultBgColour;
    }
    
    // Drawing subclauses
    if(mouseButton == LEFT){
      // - Draw on drawing area: drawDrawArea(32, 181, 559, 365);
      if(mouseX >= 32 && mouseY >= 181 && mouseX <= 559 && mouseY <= 365) {
        // Set stroke colour and weight for a shape still being drawn
        if(editorColourIndex >= 0 && editorColourIndex <= 3) { strokeColour =  colourOptions[editorColourIndex]; } 
        if(editorWeightIndex >= 0 && editorWeightIndex <= 2) { strokeWeight =  weightOptions[editorWeightIndex]; }
        
        // For shape: Straight line drawing (first point)
        if(editorShapeIndex == 1){
          currentDrawnShape.vertex(mouseX, mouseY);
          
          // Debug
          // println("SL Vertex pair added:", mouseX, mouseY);
          // println("SL Vertex count:", currentDrawnShape.getVertexCount());
          }
        
        }
      }
    
   }
   
  // - Tutorial: Rectangle with Shortcut
  else if(appState == 3) {
    //  - Press on button: rect(32, 381, 362, 417, 4);
    if( mouseX >= 32 && mouseX <= 362 && mouseY >= 381 && mouseY <= 417 && tutRectangleSelectedShortcut && tutRectangleDrawnShortcut ) {
      buttonNextTutorialShortcutOvalBgColour = buttonPrimaryPressedBgColour;
    } else if( tutRectangleSelectedShortcut && tutRectangleDrawnShortcut ){
      buttonNextTutorialShortcutOvalBgColour = buttonPrimaryDefaultBgColour;
    }
    
    // Drawing subclauses
    if(mouseButton == LEFT){
      // - Draw on drawing area: drawDrawArea(32, 181, 559, 365);
      if(mouseX >= 32 && mouseY >= 181 && mouseX <= 559 && mouseY <= 365) {
        // Set stroke colour and weight for a shape still being drawn
        if(editorColourIndex >= 0 && editorColourIndex <= 3) { strokeColour =  colourOptions[editorColourIndex]; } 
        if(editorWeightIndex >= 0 && editorWeightIndex <= 2) { strokeWeight =  weightOptions[editorWeightIndex]; }
        
        // For shape: Rectangle drawing (save first point)
        if(editorShapeIndex == 2){
          
          rectangleStartPoint = new PVector(mouseX, mouseY); 
          // Debug
          // println("Rec Vertex pair saved:", mouseX, mouseY);
          }
        
        }
      }
    
   }
   
   // - Tutorial: Oval with Shortcut
  else if(appState == 4) {
    //  - Press on button: rect(32, 381, 362, 417, 4);
    if( mouseX >= 32 && mouseX <= 362 && mouseY >= 381 && mouseY <= 417 && tutOvalSelectedShortcut && tutOvalDrawnShortcut ) {
      buttonNextTutorialShortcutColourBgColour = buttonPrimaryPressedBgColour;
    } else if( tutOvalSelectedShortcut && tutOvalDrawnShortcut ){
      buttonNextTutorialShortcutColourBgColour = buttonPrimaryDefaultBgColour;
    }
    
    // Drawing subclauses
    if(mouseButton == LEFT){
      // - Draw on drawing area: drawDrawArea(32, 181, 559, 365);
      if(mouseX >= 32 && mouseY >= 181 && mouseX <= 559 && mouseY <= 365) {
        // Set stroke colour and weight for a shape still being drawn
        if(editorColourIndex >= 0 && editorColourIndex <= 3) { strokeColour =  colourOptions[editorColourIndex]; } 
        if(editorWeightIndex >= 0 && editorWeightIndex <= 2) { strokeWeight =  weightOptions[editorWeightIndex]; }
        
        // For shape: Oval drawing (save first point)
        if(editorShapeIndex == 3){
          
          ovalStartPoint = new PVector(mouseX, mouseY); 
          // Debug
          // println("Oval Vertex pair saved:", mouseX, mouseY);
          }
        
        }
      }
    
   }
   
  // - Tutorial: Coloured Rectangles with Shortcut
  else if(appState == 5) {
    //  - Press on button: rect(32, 381, 362, 417, 4);
    if( mouseX >= 32 && mouseX <= 362 && mouseY >= 381 && mouseY <= 417 && tutAllColoursSelectedShortcut && tutDrawnWithAllColoursShortcut ) {
      buttonNextTutorialShortcutWeightBgColour = buttonPrimaryPressedBgColour;
    } else if( tutAllColoursSelectedShortcut && tutDrawnWithAllColoursShortcut ){
      buttonNextTutorialShortcutWeightBgColour = buttonPrimaryDefaultBgColour;
    }
    
    // Drawing subclauses
    if(mouseButton == LEFT){
      // - Draw on drawing area: drawDrawArea(32, 181, 559, 365);
      if(mouseX >= 32 && mouseY >= 181 && mouseX <= 559 && mouseY <= 365) {
        // Set stroke colour and weight for a shape still being drawn
        if(editorColourIndex >= 0 && editorColourIndex <= 3) { strokeColour =  colourOptions[editorColourIndex]; } 
        if(editorWeightIndex >= 0 && editorWeightIndex <= 2) { strokeWeight =  weightOptions[editorWeightIndex]; }
        
        // For shape: Rectangle drawing (save first point)
        if(editorShapeIndex == 2){
          
          rectangleStartPoint = new PVector(mouseX, mouseY); 
          // Debug
          // println("Rec Vertex pair saved:", mouseX, mouseY);
          }
        
        }
      }
    
   }
   
   // - Tutorial: Weighted Ovals lines with Shortcut
  else if(appState == 6) {
    //  - Press on button: rect(32, 381, 362, 417, 4);
    if( mouseX >= 32 && mouseX <= 362 && mouseY >= 381 && mouseY <= 417 && tutAllWeightsSelectedShortcut && tutDrawnWithAllWeightsShortcut ) {
      buttonNextTutorialShortcutUndoBgColour = buttonPrimaryPressedBgColour;
    } else if( tutAllWeightsSelectedShortcut && tutDrawnWithAllWeightsShortcut ){
      buttonNextTutorialShortcutUndoBgColour = buttonPrimaryDefaultBgColour;
    }
    
    // Drawing subclauses
    if(mouseButton == LEFT){
      // - Draw on drawing area: drawDrawArea(32, 181, 559, 365);
      if(mouseX >= 32 && mouseY >= 181 && mouseX <= 559 && mouseY <= 365) {
        // Set stroke colour and weight for a shape still being drawn
        if(editorColourIndex >= 0 && editorColourIndex <= 3) { strokeColour =  colourOptions[editorColourIndex]; } 
        if(editorWeightIndex >= 0 && editorWeightIndex <= 2) { strokeWeight =  weightOptions[editorWeightIndex]; }
        
        // For shape: Oval drawing (save first point)
        if(editorShapeIndex == 3){
          
          ovalStartPoint = new PVector(mouseX, mouseY); 
          // Debug
          // println("Oval Vertex pair saved:", mouseX, mouseY);
          }
        
        }
      }
    
   }
   
   // Tutorial: Undo
  else if(appState == 7) {
    //  - Press on button: rect(32, 381, 362, 417, 4);
    if( mouseX >= 32 && mouseX <= 362 && mouseY >= 381 && mouseY <= 417 && tut3ShapesDrawnShortcut && tut3DeletedShortcut ) {
      buttonNextTutorialShortcutReviewBgColour = buttonPrimaryPressedBgColour;
    } else if (tut3ShapesDrawnShortcut && tut3DeletedShortcut){
      buttonNextTutorialShortcutReviewBgColour = buttonPrimaryDefaultBgColour;
    }
    // Drawing subclauses
    if(mouseButton == LEFT){
      // - Draw on drawing area: drawDrawArea(32, 181, 559, 365)
      if(mouseX >= 32 && mouseY >= 181 && mouseX <= 559 && mouseY <= 365) {
        // Set stroke colour and weight for a shape still being drawn
        if(editorColourIndex >= 0 && editorColourIndex <= 3) { strokeColour =  colourOptions[editorColourIndex]; } 
        if(editorWeightIndex >= 0 && editorWeightIndex <= 2) { strokeWeight =  weightOptions[editorWeightIndex]; }
        
        // For shape: Straight line drawing (add first point)
        if(editorShapeIndex == 1){
          currentDrawnShape.vertex(mouseX, mouseY);
        }

        // For shape: Rectangle drawing (save first point)
        else if(editorShapeIndex == 2){
          rectangleStartPoint = new PVector(mouseX, mouseY); 

        }
        // For shape: Oval drawing (save center)
        else if(editorShapeIndex == 3){          
          ovalStartPoint = new PVector(mouseX, mouseY); 
        }
        
      }
    }
  }
   
   // for Review: Keyboard Shortcuts   
  else if(appState == 8) {
    //  - Press on button: rect(32, 381, 362, 417, 4);
    if( mouseX >= 32 && mouseX <= 362 && mouseY >= 381 && mouseY <= 417 ) {
      buttonNextTask1ShortcutBgColour = buttonPrimaryPressedBgColour;
    } else {
      buttonNextTask1ShortcutBgColour = buttonPrimaryDefaultBgColour;
    }
  }
  
  // Drawing Task 1
  else if(appState == 9) {
    //  - Press on button: rect(32, 381, 362, 417, 4);
    if( mouseX >= 32 && mouseX <= 362 && mouseY >= 381 && mouseY <= 417 ) {
      buttonNextTask2ShortcutBgColour = buttonPrimaryPressedBgColour;
    } else {
      buttonNextTask2ShortcutBgColour = buttonPrimaryDefaultBgColour;
    }
    // Drawing subclauses
    if(mouseButton == LEFT){
      // - Draw on drawing area: drawDrawArea(32, 98, 559, 365)
      if(mouseX >= 32 && mouseY >= 98 && mouseX <= 559 && mouseY <= 365) {
        // Set stroke colour and weight for a shape still being drawn
        if(editorColourIndex >= 0 && editorColourIndex <= 3) { strokeColour =  colourOptions[editorColourIndex]; } 
        if(editorWeightIndex >= 0 && editorWeightIndex <= 2) { strokeWeight =  weightOptions[editorWeightIndex]; }
        
        // For shape: Straight line drawing (add first point)
        if(editorShapeIndex == 1){
          currentDrawnShape.vertex(mouseX, mouseY);
        }

        // For shape: Rectangle drawing (save first point)
        else if(editorShapeIndex == 2){
          rectangleStartPoint = new PVector(mouseX, mouseY); 

        }
        // For shape: Oval drawing (save center)
        else if(editorShapeIndex == 3){          
          ovalStartPoint = new PVector(mouseX, mouseY); 
        }
        
      }
    }
  }
  
  // Drawing Task 2
  else if(appState == 10) {
    //  - Press on button: rect(32, 381, 362, 417, 4);
    if( mouseX >= 32 && mouseX <= 362 && mouseY >= 381 && mouseY <= 417 ) {
      buttonNextConclusionShortcutBgColour = buttonPrimaryPressedBgColour;
    } else {
      buttonNextConclusionShortcutBgColour = buttonPrimaryDefaultBgColour;
    }
    // Drawing subclauses
    if(mouseButton == LEFT){
      // - Draw on drawing area: drawDrawArea(32, 98, 559, 365)
      if(mouseX >= 32 && mouseY >= 98 && mouseX <= 559 && mouseY <= 365) {
        // Set stroke colour and weight for a shape still being drawn
        if(editorColourIndex >= 0 && editorColourIndex <= 3) { strokeColour =  colourOptions[editorColourIndex]; } 
        if(editorWeightIndex >= 0 && editorWeightIndex <= 2) { strokeWeight =  weightOptions[editorWeightIndex]; }
        
        // For shape: Straight line drawing (add first point)
        if(editorShapeIndex == 1){
          currentDrawnShape.vertex(mouseX, mouseY);
        }

        // For shape: Rectangle drawing (save first point)
        else if(editorShapeIndex == 2){
          rectangleStartPoint = new PVector(mouseX, mouseY); 

        }
        // For shape: Oval drawing (save center)
        else if(editorShapeIndex == 3){          
          ovalStartPoint = new PVector(mouseX, mouseY); 
        }
        
      }
    }
  }
  // Conclusion screen
  else if(appState == 11) {
    //  - Press on button: rect(32, 381, 362, 417, 4);
    if( mouseX >= 32 && mouseX <= 362 && mouseY >= 381 && mouseY <= 417 ) {
      buttonExitBgColour = buttonPrimaryPressedBgColour;
    } else {
      buttonExitBgColour = buttonPrimaryDefaultBgColour;
    }
  }

}

// Mouse Clicked  
void mouseClicked(){
  // Book-keeping
  totalNoOfClicks += 1;
  // for Start screen   
  if(appState == 0) {
    //  - Hover on button: rect(32, 381, 362, 417, 4);
    if( mouseX >= 32 && mouseX <= 362 && mouseY >= 381 && mouseY <= 417 ) {
      
      // Book-keeping
      println("Time till Screen changed to Free-form line Tutorial: ", millis(), 
      ", total Clicks: ", totalNoOfClicks, 
      ", total KeyPresses: ", totalNoOfKeyPressed, 
      ", shapes Drawn in last screen: ", shapesDrawnLast
      );
      
      // change app state
      appState = 1;
    }
  }
  // - Tutorial: Free-form with Shortcut
  else if(appState == 1) {
    //  - Hover on button: rect(32, 381, 362, 417, 4);
    if( mouseX >= 32 && mouseX <= 362 && mouseY >= 381 && mouseY <= 417 && tutFreeformSelectedShortcut && tutFreeformDrawnShortcut ) {
      
      // Book-keeping
      println("Time till Screen changed to Straight line Tutorial: ", millis(), 
      ", total Clicks: ", totalNoOfClicks, 
      ", total KeyPresses: ", totalNoOfKeyPressed, 
      ", shapes Drawn in last screen: ", shapesDrawnLast
      );
      
      // Clear all shapes
      clearAllDrawnShapes();
      shapesDrawnLast = 0;
      
      // change app state
      appState = 2;
    }
  }
  // - Tutorial: Straight-line with Shortcut
  else if(appState == 2) {
    //  - Hover on button: rect(32, 381, 362, 417, 4);
    if( mouseX >= 32 && mouseX <= 362 && mouseY >= 381 && mouseY <= 417 && tutStraightSelectedShortcut && tutStraightDrawnShortcut ) {
      // Book-keeping
      println("Time till Screen changed to Rectangle Tutorial: ", millis(), 
      ", total Clicks: ", totalNoOfClicks, 
      ", total KeyPresses: ", totalNoOfKeyPressed, 
      ", shapes Drawn in last screen: ", shapesDrawnLast
      );
      
      // Clear all shapes
      clearAllDrawnShapes();
      shapesDrawnLast = 0;
      
      // change app state
      appState = 3;
    }
  }
  
  // - Tutorial: Rectangle with Shortcut
  else if(appState == 3) {
    //  - Hover on button: rect(32, 381, 362, 417, 4);
    if( mouseX >= 32 && mouseX <= 362 && mouseY >= 381 && mouseY <= 417 && tutRectangleSelectedShortcut && tutRectangleDrawnShortcut ) {
      // Book-keeping
      println("Time till Screen changed to Oval Tutorial: ", millis(), 
      ", total Clicks: ", totalNoOfClicks, 
      ", total KeyPresses: ", totalNoOfKeyPressed, 
      ", shapes Drawn in last screen: ", shapesDrawnLast
      );
      
      // Clear all shapes
      clearAllDrawnShapes();
      shapesDrawnLast = 0;
      
      // change app state
      appState = 4;
    }
  }
  
  // - Tutorial: Oval with Shortcut
  else if(appState == 4) {
    //  - Hover on button: rect(32, 381, 362, 417, 4);
    if( mouseX >= 32 && mouseX <= 362 && mouseY >= 381 && mouseY <= 417 && tutOvalSelectedShortcut && tutOvalDrawnShortcut ) {
      // Book-keeping
      println("Time till Screen changed to Colours Tutorial: ", millis(), 
      ", total Clicks: ", totalNoOfClicks, 
      ", total KeyPresses: ", totalNoOfKeyPressed, 
      ", shapes Drawn in last screen: ", shapesDrawnLast
      );
      
      // Clear all shapes
      clearAllDrawnShapes();
      shapesDrawnLast = 0;
      
      // Set Colours to Null value
      editorColourIndex = -1;
      
      // Set Shape to Rectangle
      editorShapeIndex = 2;
      
      // change app state
      appState = 5;
    }
  }
  
  // - Tutorial: Coloured Rectangles with Shortcut
  else if(appState == 5) {
    //  - Hover on button: rect(32, 381, 362, 417, 4);
    if( mouseX >= 32 && mouseX <= 362 && mouseY >= 381 && mouseY <= 417 && tutAllColoursSelectedShortcut && tutDrawnWithAllColoursShortcut ) {
      // Book-keeping
      println("Time till Screen changed to Weights Tutorial: ", millis(), 
      ", total Clicks: ", totalNoOfClicks, 
      ", total KeyPresses: ", totalNoOfKeyPressed, 
      ", shapes Drawn in last screen: ", shapesDrawnLast
      );
      
      // Clear all shapes
      clearAllDrawnShapes();
      shapesDrawnLast = 0;
      
      // Set Weight to Null value
      editorWeightIndex = -1;
      
      // Set Shape to Oval
      editorShapeIndex = 3;
      
      // change app state
      appState = 6;
    }
  }
  
  // - Tutorial: Weighted Ovals with Shortcut
  else if(appState == 6) {
    //  - Hover on button: rect(32, 381, 362, 417, 4);
    if( mouseX >= 32 && mouseX <= 362 && mouseY >= 381 && mouseY <= 417 && tutAllWeightsSelectedShortcut && tutDrawnWithAllWeightsShortcut ) {
      // Book-keeping
      println("Time till Screen changed to Undo Tutorial: ", millis(), 
      ", total Clicks: ", totalNoOfClicks, 
      ", total KeyPresses: ", totalNoOfKeyPressed, 
      ", shapes Drawn in last screen: ", shapesDrawnLast
      );
      
      
      // Clear all shapes
      clearAllDrawnShapes();
      shapesDrawnLast = 0;
      
      // change app state
      appState = 7;
    }
  }
  
  // - Tutorial: Undo
  else if(appState == 7) {
    //  - Hover on button: rect(32, 381, 362, 417, 4);
    if( mouseX >= 32 && mouseX <= 362 && mouseY >= 381 && mouseY <= 417 && tut3ShapesDrawnShortcut && tut3DeletedShortcut ) {
      // Book-keeping
      println("Time till Screen changed to Review of Shortcuts: ", millis(), 
      ", total Clicks: ", totalNoOfClicks, 
      ", total KeyPresses: ", totalNoOfKeyPressed, 
      ", shapes Drawn in last screen: ", shapesDrawnLast
      );
      
      // Clear all shapes
      clearAllDrawnShapes();
      shapesDrawnLast = 0;
      
      // change app state
      appState = 8;
    }
  }
  
  // for Review Keyboard shortcut screen   
  else if(appState == 8) {
    //  - Hover on button: rect(32, 381, 362, 417, 4);
    if( mouseX >= 32 && mouseX <= 362 && mouseY >= 381 && mouseY <= 417 ) {
      // Book-keeping
      println("Time till Screen changed to Drawing Task 1: ", millis(), 
      ", total Clicks: ", totalNoOfClicks, 
      ", total KeyPresses: ", totalNoOfKeyPressed, 
      ", shapes Drawn in last screen: ", shapesDrawnLast
      );
      
      // change app state
      appState = 9;
    }
  }
  
  // for Drawing Task 1   
  else if(appState == 9) {
    //  - Hover on button: rect(32, 381, 362, 417, 4);
    if( mouseX >= 32 && mouseX <= 362 && mouseY >= 381 && mouseY <= 417 ) {
      // Book-keeping
      println("Time till Screen changed to Drawing Task 2: ", millis(), 
      ", total Clicks: ", totalNoOfClicks, 
      ", total KeyPresses: ", totalNoOfKeyPressed, 
      ", shapes Drawn in last screen: ", shapesDrawnLast
      );
      
      // Clear all shapes
      clearAllDrawnShapes();
      shapesDrawnLast = 0;
      
      // change app state
      appState = 10;
    }
  }
  
  // Drawing Task 2
  else if(appState == 10) {
    //  - Hover on button: rect(32, 381, 362, 417, 4);
    if( mouseX >= 32 && mouseX <= 362 && mouseY >= 381 && mouseY <= 417 ) {
      // Book-keeping
      println("Time till Screen changed to Ending Screen: ", millis(), 
      ", total Clicks: ", totalNoOfClicks, 
      ", total KeyPresses: ", totalNoOfKeyPressed, 
      ", shapes Drawn in last screen: ", shapesDrawnLast
      );
    
      
      // Clear all shapes
      clearAllDrawnShapes();
      shapesDrawnLast = 0;
      
      // change app state
      appState = 11;
    }
  }
  
  // Thank you - and contact us screen
  else if(appState == 11) {
    //  - Hover on button: rect(32, 381, 362, 417, 4);
    if( mouseX >= 32 && mouseX <= 362 && mouseY >= 381 && mouseY <= 417 ) {
      // Book-keeping
      println("Time till Exit: ", millis(), 
      ", total Clicks: ", totalNoOfClicks, 
      ", total KeyPresses: ", totalNoOfKeyPressed, 
      ", shapes Drawn in last screen: ", shapesDrawnLast
      );
      
      
      // Close app
      exit();
    }
  }
  
}


// Mouse Dragged (pressed and moved) 
void mouseDragged(){
  
  // println("Invoked - mouseDragged"); // [WORKS] 
  
  // for Start screen   
  if(appState == 0) {
  }
  // Tutorial: Free-form line with Shortcut
  else if(appState == 1) {
    // println("Invoked - mouseDragged - at Tutotrial free-form"); // [WORKS]
    if(mouseButton == LEFT){
      // println("Invoked - Left - mouseDragged - at Tutotrial free-form", mouseX, mouseY, millis()); //[WORKS]
      
      // - Draw on drawing area: drawDrawArea(32, 181, 559, 365);
      if(mouseX >= 32 && mouseY >= 181 && mouseX <= 559 && mouseY <= 365) {
        
        // println("Invoked - Bounded - Left - mouseDragged - at Tutotrial free-form", mouseX, mouseY, millis()); //[WORKS]
        
        // Set stroke colour and weight for a shape still being drawn
        if(editorColourIndex >= 0 && editorColourIndex <= 3) { strokeColour =  colourOptions[editorColourIndex]; } 
        if(editorWeightIndex >= 0 && editorWeightIndex <= 2) { strokeWeight =  weightOptions[editorWeightIndex]; } 
        
        
        // For shape: free-form line 
        if(editorShapeIndex == 0){
          currentDrawnShape.stroke(strokeColour);
          currentDrawnShape.strokeWeight(strokeWeight);
          // println("Invoked - found free-form line"); //[WORKS]         
          // If dragged within the drawing-area keep added new vertices
          // while(mousePressed == true   &&  mouseX >= 32 && mouseY >= 181 && mouseX <= 559 && mouseY <= 365){
            // currentDrawnShape.vertex(pmouseX, pmouseY);
            // currentDrawnShape.vertex(mouseX, mouseY);
            // println("Vertex added:", mouseX, mouseY);
          // } 
          // println("Vertex added:", mouseX, mouseY);
          currentDrawnShape.vertex(mouseX, mouseY);
          
          // Preview with Alpha
          currentDrawnShape.stroke(colourOptionsAlpha[editorColourIndex]);
          shape(currentDrawnShape);
          // Revert to final Colour
          currentDrawnShape.stroke(colourOptions[editorColourIndex]);
        }
        
      }
    }
    
  }
  
  // Tutorial: Straight line with Shortcut
  else if(appState == 2) {
    if(mouseButton == LEFT){
      // - Draw on drawing area: drawDrawArea(32, 181, 559, 365);
      if(mouseX >= 32 && mouseY >= 181 && mouseX <= 559 && mouseY <= 365) {
        // Set stroke colour and weight for a shape still being drawn
        if(editorColourIndex >= 0 && editorColourIndex <= 3) { strokeColour =  colourOptions[editorColourIndex]; } 
        if(editorWeightIndex >= 0 && editorWeightIndex <= 2) { strokeWeight =  weightOptions[editorWeightIndex]; } 
        
        // For shape: straight line
        if(editorShapeIndex == 1){
          currentDrawnShape.stroke(strokeColour);
          currentDrawnShape.strokeWeight(strokeWeight);
          // println("No of vertices in this SL:", currentDrawnShape.getVertexCount());
          
          // Guard clause
          if(currentDrawnShape.getVertexCount() == 1){
              // Debug
              PVector startVertex = currentDrawnShape.getVertex(0);
              // println("Start point: ", startVertex.x, startVertex.y);
              // println("Mouse point: ", mouseX, mouseY);
              
              // Preview with Alpha
              stroke(colourOptionsAlpha[editorColourIndex]);
              strokeWeight(strokeWeight);
              line(startVertex.x, startVertex.y, mouseX, mouseY);
              // Revert to final Colour
              stroke(colourOptions[editorColourIndex]);
           }
          
        }
      }
    }
    
  }
  
  // Tutorial: Rectangle with Shortcut
  else if(appState == 3) {
    if(mouseButton == LEFT){
      // - Draw on drawing area: drawDrawArea(32, 181, 559, 365);
      if(mouseX >= 32 && mouseY >= 181 && mouseX <= 559 && mouseY <= 365) {
        // Set stroke colour and weight for a shape still being drawn
        if(editorColourIndex >= 0 && editorColourIndex <= 3) { strokeColour =  colourOptions[editorColourIndex]; } 
        if(editorWeightIndex >= 0 && editorWeightIndex <= 2) { strokeWeight =  weightOptions[editorWeightIndex]; } 
        
        // For shape: rectangle
        if(editorShapeIndex == 2){
            // currentDrawnShape.stroke(strokeColour);
            // currentDrawnShape.strokeWeight(strokeWeight);
            // println("No of vertices in this SL:", currentDrawnShape.getVertexCount());
        

            // println("Start point: ", startVertex.x, startVertex.y);
            // println("Mouse point: ", mouseX, mouseY);
            
            // Preview with Alpha
            stroke(colourOptionsAlpha[editorColourIndex]);
            strokeWeight(strokeWeight);
            fill(defaultShapeFillColour);
            rect(rectangleStartPoint.x, rectangleStartPoint.y, mouseX, mouseY);
            // Revert to final Colour
            stroke(colourOptions[editorColourIndex]);
           
          
        }
      }
    }
    
  }
  
  // Tutorial: Oval with Shortcut
  else if(appState == 4) {
    if(mouseButton == LEFT){
      // - Draw on drawing area: drawDrawArea(32, 181, 559, 365);
      if(mouseX >= 32 && mouseY >= 181 && mouseX <= 559 && mouseY <= 365) {
        // Set stroke colour and weight for a shape still being drawn
        if(editorColourIndex >= 0 && editorColourIndex <= 3) { strokeColour =  colourOptions[editorColourIndex]; } 
        if(editorWeightIndex >= 0 && editorWeightIndex <= 2) { strokeWeight =  weightOptions[editorWeightIndex]; } 
        
        // For shape: Oval
        if(editorShapeIndex == 3){
            // Preview with Alpha
            stroke(colourOptionsAlpha[editorColourIndex]);
            strokeWeight(strokeWeight);
            fill(defaultShapeFillColour);
            float radiusX = dist(ovalStartPoint.x, 0, mouseX, 0);
            float radiusY = dist(0, ovalStartPoint.y, 0, mouseY);
            ellipse(ovalStartPoint.x, ovalStartPoint.y, radiusX, radiusY);
            // ellipse(ovalStartPoint.x, ovalStartPoint.y, mouseX, mouseY);
            // Revert to final Colour
            stroke(colourOptions[editorColourIndex]);
           
          
        }
      }
    }
    
  }
  
  // Tutorial: Coloured Rectangles with Shortcut
  else if(appState == 5) {
    if(mouseButton == LEFT){
      // - Draw on drawing area: drawDrawArea(32, 181, 559, 365);
      if(mouseX >= 32 && mouseY >= 181 && mouseX <= 559 && mouseY <= 365) {
        // Set stroke colour and weight for a shape still being drawn
        if(editorColourIndex >= 0 && editorColourIndex <= 3) { strokeColour =  colourOptions[editorColourIndex]; } 
        if(editorWeightIndex >= 0 && editorWeightIndex <= 2) { strokeWeight =  weightOptions[editorWeightIndex]; } 
        
        // For shape: rectangle
        if(editorShapeIndex == 2){
            
            // Guard clause
            if(editorColourIndex >= 0) {
            
              // Preview with Alpha
              stroke(colourOptionsAlpha[editorColourIndex]);
              strokeWeight(strokeWeight);
              fill(defaultShapeFillColour);
              rect(rectangleStartPoint.x, rectangleStartPoint.y, mouseX, mouseY);
              // Revert to final Colour
              stroke(colourOptions[editorColourIndex]);
            }
           
          
        }
      }
    }    
  }
  
  // Tutorial: Weighted Ovals with Shortcut
  else if(appState == 6) {
    if(mouseButton == LEFT){
      // - Draw on drawing area: drawDrawArea(32, 181, 559, 365);
      if(mouseX >= 32 && mouseY >= 181 && mouseX <= 559 && mouseY <= 365) {
        // Set stroke colour and weight for a shape still being drawn
        if(editorColourIndex >= 0 && editorColourIndex <= 3) { strokeColour =  colourOptions[editorColourIndex]; } 
        if(editorWeightIndex >= 0 && editorWeightIndex <= 2) { strokeWeight =  weightOptions[editorWeightIndex]; } 
        
        // For shape: Oval
        if(editorShapeIndex == 3){
          
          // Guard clause
            if(editorWeightIndex >= 0) {
              // Preview with Alpha
              stroke(colourOptionsAlpha[editorColourIndex]);
              strokeWeight(strokeWeight);
              fill(defaultShapeFillColour);
              float radiusX = dist(ovalStartPoint.x, 0, mouseX, 0);
              float radiusY = dist(0, ovalStartPoint.y, 0, mouseY);
              ellipse(ovalStartPoint.x, ovalStartPoint.y, radiusX, radiusY);
              // ellipse(ovalStartPoint.x, ovalStartPoint.y, mouseX, mouseY);
              // Revert to final Colour
              stroke(colourOptions[editorColourIndex]);
            }
        }
      }
    }  
  }
  
  // Tutorial: Undo
  else if(appState == 7) {
    if(mouseButton == LEFT){
      // - Draw on drawing area: drawDrawArea(32, 181, 559, 365);
      if(mouseX >= 32 && mouseY >= 181 && mouseX <= 559 && mouseY <= 365) {
       // Set stroke colour and weight for a shape still being drawn
        if(editorColourIndex >= 0 && editorColourIndex <= 3) { strokeColour =  colourOptions[editorColourIndex]; } 
        if(editorWeightIndex >= 0 && editorWeightIndex <= 2) { strokeWeight =  weightOptions[editorWeightIndex]; } 
        
        // For shape: free-form line 
        if(editorShapeIndex == 0){
          currentDrawnShape.stroke(strokeColour);
          currentDrawnShape.strokeWeight(strokeWeight);
          currentDrawnShape.vertex(mouseX, mouseY);
          
          // Preview with Alpha
          currentDrawnShape.stroke(colourOptionsAlpha[editorColourIndex]);
          shape(currentDrawnShape);
          // Revert to final Colour
          currentDrawnShape.stroke(colourOptions[editorColourIndex]);
        }
        
        // For shape: straight line
        else if(editorShapeIndex == 1){
          currentDrawnShape.stroke(strokeColour);
          currentDrawnShape.strokeWeight(strokeWeight);
 
          // Guard clause
          if(currentDrawnShape.getVertexCount() == 1){
              // Debug
              PVector startVertex = currentDrawnShape.getVertex(0);
              
              // Preview with Alpha
              stroke(colourOptionsAlpha[editorColourIndex]);
              strokeWeight(strokeWeight);
              line(startVertex.x, startVertex.y, mouseX, mouseY);
              // Revert to final Colour
              stroke(colourOptions[editorColourIndex]);
           }
          
        }
        
        // For shape: rectangle
        else if(editorShapeIndex == 2){
            
            // Preview with Alpha
            stroke(colourOptionsAlpha[editorColourIndex]);
            strokeWeight(strokeWeight);
            fill(defaultShapeFillColour);
            rect(rectangleStartPoint.x, rectangleStartPoint.y, mouseX, mouseY);
            // Revert to final Colour
            stroke(colourOptions[editorColourIndex]);
           
          
        }
        
        // For shape: Oval
        else if(editorShapeIndex == 3){
            // Preview with Alpha
            stroke(colourOptionsAlpha[editorColourIndex]);
            strokeWeight(strokeWeight);
            fill(defaultShapeFillColour);
            float radiusX = dist(ovalStartPoint.x, 0, mouseX, 0);
            float radiusY = dist(0, ovalStartPoint.y, 0, mouseY);
            ellipse(ovalStartPoint.x, ovalStartPoint.y, radiusX, radiusY);
            // ellipse(ovalStartPoint.x, ovalStartPoint.y, mouseX, mouseY);
            // Revert to final Colour
            stroke(colourOptions[editorColourIndex]);
           
          
        }
        
      }
    }
    
  }
  
  // Drawing task 1
  else if(appState == 9) {
    if(mouseButton == LEFT){
      // - Draw on drawing area: drawDrawArea(32, 98, 559, 365);
      if(mouseX >= 32 && mouseY >= 98 && mouseX <= 559 && mouseY <= 365) {
       // Set stroke colour and weight for a shape still being drawn
        if(editorColourIndex >= 0 && editorColourIndex <= 3) { strokeColour =  colourOptions[editorColourIndex]; } 
        if(editorWeightIndex >= 0 && editorWeightIndex <= 2) { strokeWeight =  weightOptions[editorWeightIndex]; } 
        
        // For shape: free-form line 
        if(editorShapeIndex == 0){
          currentDrawnShape.stroke(strokeColour);
          currentDrawnShape.strokeWeight(strokeWeight);
          currentDrawnShape.vertex(mouseX, mouseY);
          
          // Preview with Alpha
          currentDrawnShape.stroke(colourOptionsAlpha[editorColourIndex]);
          shape(currentDrawnShape);
          // Revert to final Colour
          currentDrawnShape.stroke(colourOptions[editorColourIndex]);
        }
        
        // For shape: straight line
        else if(editorShapeIndex == 1){
          currentDrawnShape.stroke(strokeColour);
          currentDrawnShape.strokeWeight(strokeWeight);
 
          // Guard clause
          if(currentDrawnShape.getVertexCount() == 1){
              // Debug
              PVector startVertex = currentDrawnShape.getVertex(0);
              
              // Preview with Alpha
              stroke(colourOptionsAlpha[editorColourIndex]);
              strokeWeight(strokeWeight);
              line(startVertex.x, startVertex.y, mouseX, mouseY);
              // Revert to final Colour
              stroke(colourOptions[editorColourIndex]);
           }
          
        }
        
        // For shape: rectangle
        else if(editorShapeIndex == 2){
            
            // Preview with Alpha
            stroke(colourOptionsAlpha[editorColourIndex]);
            strokeWeight(strokeWeight);
            fill(defaultShapeFillColour);
            rect(rectangleStartPoint.x, rectangleStartPoint.y, mouseX, mouseY);
            // Revert to final Colour
            stroke(colourOptions[editorColourIndex]);
           
          
        }
        
        // For shape: Oval
        else if(editorShapeIndex == 3){
            // Preview with Alpha
            stroke(colourOptionsAlpha[editorColourIndex]);
            strokeWeight(strokeWeight);
            fill(defaultShapeFillColour);
            float radiusX = dist(ovalStartPoint.x, 0, mouseX, 0);
            float radiusY = dist(0, ovalStartPoint.y, 0, mouseY);
            ellipse(ovalStartPoint.x, ovalStartPoint.y, radiusX, radiusY);
            // ellipse(ovalStartPoint.x, ovalStartPoint.y, mouseX, mouseY);
            // Revert to final Colour
            stroke(colourOptions[editorColourIndex]);
           
          
        }
        
      }
    }
    
  }
  
  // Drawing task 2
  else if(appState == 10) {
    if(mouseButton == LEFT){
      // - Draw on drawing area: drawDrawArea(32, 98, 559, 365);
      if(mouseX >= 32 && mouseY >= 98 && mouseX <= 559 && mouseY <= 365) {
       // Set stroke colour and weight for a shape still being drawn
        if(editorColourIndex >= 0 && editorColourIndex <= 3) { strokeColour =  colourOptions[editorColourIndex]; } 
        if(editorWeightIndex >= 0 && editorWeightIndex <= 2) { strokeWeight =  weightOptions[editorWeightIndex]; } 
        
        // For shape: free-form line 
        if(editorShapeIndex == 0){
          currentDrawnShape.stroke(strokeColour);
          currentDrawnShape.strokeWeight(strokeWeight);
          currentDrawnShape.vertex(mouseX, mouseY);
          
          // Preview with Alpha
          currentDrawnShape.stroke(colourOptionsAlpha[editorColourIndex]);
          shape(currentDrawnShape);
          // Revert to final Colour
          currentDrawnShape.stroke(colourOptions[editorColourIndex]);
        }
        
        // For shape: straight line
        else if(editorShapeIndex == 1){
          currentDrawnShape.stroke(strokeColour);
          currentDrawnShape.strokeWeight(strokeWeight);
 
          // Guard clause
          if(currentDrawnShape.getVertexCount() == 1){
              // Debug
              PVector startVertex = currentDrawnShape.getVertex(0);
              
              // Preview with Alpha
              stroke(colourOptionsAlpha[editorColourIndex]);
              strokeWeight(strokeWeight);
              line(startVertex.x, startVertex.y, mouseX, mouseY);
              // Revert to final Colour
              stroke(colourOptions[editorColourIndex]);
           }
          
        }
        
        // For shape: rectangle
        else if(editorShapeIndex == 2){
            
            // Preview with Alpha
            stroke(colourOptionsAlpha[editorColourIndex]);
            strokeWeight(strokeWeight);
            fill(defaultShapeFillColour);
            rect(rectangleStartPoint.x, rectangleStartPoint.y, mouseX, mouseY);
            // Revert to final Colour
            stroke(colourOptions[editorColourIndex]);
           
          
        }
        
        // For shape: Oval
        else if(editorShapeIndex == 3){
            // Preview with Alpha
            stroke(colourOptionsAlpha[editorColourIndex]);
            strokeWeight(strokeWeight);
            fill(defaultShapeFillColour);
            float radiusX = dist(ovalStartPoint.x, 0, mouseX, 0);
            float radiusY = dist(0, ovalStartPoint.y, 0, mouseY);
            ellipse(ovalStartPoint.x, ovalStartPoint.y, radiusX, radiusY);
            // ellipse(ovalStartPoint.x, ovalStartPoint.y, mouseX, mouseY);
            // Revert to final Colour
            stroke(colourOptions[editorColourIndex]);
           
          
        }
        
      }
    }
    
  }
  
}

// Mouse Released 
void mouseReleased(){
  // for Start screen   
  if(appState == 0) {
  }
  // Tutorial: Free-form line and beyond
  else if(appState >= 1) {
    if(mouseButton == LEFT){
      
      // Guard clauses
      // TODO: Need to refine the bounding box
      if(editorShapeIndex >= 0 && editorShapeIndex <= 3 && (mouseX >= 32 && mouseY >= 98 && mouseX <= 559 && mouseY <= 365)){
        
        // Freeze the free-form line so far
        if((appState == 1 || appState == 7 || appState == 9 || appState == 10) && editorShapeIndex == 0 && editorColourIndex >=0 && editorWeightIndex >=0) {
          // When left button is released, last shape is complete
          currentDrawnShape.endShape();
          // println("Free-form line shape ended");
          
          // Add to saved list of Shapes 
          drawnShapeList.add(currentDrawnShape);
          
          // Book-keeping
          shapesDrawnLast += 1;
        }
        
        // Add the last vertex for editorShapeIndex: 1 (straight-line)
        else if( (appState == 2 || appState == 7 || appState == 9 || appState == 10) && editorShapeIndex == 1 && editorColourIndex >=0 && editorWeightIndex >=0) {
          currentDrawnShape.vertex(mouseX, mouseY);
          // When left button is released, last shape is complete
          currentDrawnShape.endShape();
          // println("Straight line shape ended");
          
          // Add to saved list of Shapes 
          drawnShapeList.add(currentDrawnShape);
          
          // Book-keeping
          shapesDrawnLast += 1;
        }
         
        // Construct full rectangle for editorShapeIndex: 2 (rectangle)
        else if((appState == 3 || appState == 5 || appState == 7 || appState == 9 || appState == 10) && editorShapeIndex == 2 && editorColourIndex >=0 && editorWeightIndex >=0) {
          // println("Creating new rectangle shape with: ", rectangleStartPoint.x, rectangleStartPoint.y, mouseX, mouseY);
          
          stroke(strokeColour);
          strokeWeight(strokeWeight);
          fill(defaultShapeFillColour);
          currentRectangleShape = createShape(RECT, rectangleStartPoint.x, rectangleStartPoint.y, mouseX, mouseY);
          
          // Add to saved list of Shapes 
          drawnShapeList.add(currentRectangleShape);
          
          // Book-keeping
          shapesDrawnLast += 1;
        }
        
        // Construct full oval for editorShapeIndex: 3 (oval)
        else if( (appState == 4 || appState == 6 || appState == 7 || appState == 9 || appState == 10) && editorShapeIndex == 3 && editorColourIndex >=0 && editorWeightIndex >=0) {
          // println("Creating new oval shape with: ", ovalStartPoint.x, ovalStartPoint.y, mouseX, mouseY);
          
          stroke(strokeColour);
          strokeWeight(strokeWeight);
          fill(defaultShapeFillColour);
          float radiusX = dist(ovalStartPoint.x, 0, mouseX, 0);
          float radiusY = dist(0, ovalStartPoint.y, 0, mouseY);
          currentOvalShape = createShape(ELLIPSE, ovalStartPoint.x, ovalStartPoint.y, radiusX, radiusY);
          
          // Add to saved list of Shapes 
          drawnShapeList.add(currentOvalShape);
          
          // Book-keeping
          shapesDrawnLast += 1;
        }
        
        
        // Re-initialise for Free-form line and Straight line
        if((appState == 1 || appState == 7 || appState == 9 || appState == 10) && editorShapeIndex == 0) {
          // println("Begin new free-form line shape");
          currentDrawnShape = createShape();    
          currentDrawnShape.setFill(defaultShapeFillColour);
          
          currentDrawnShape.beginShape();
          currentDrawnShape.stroke(strokeColour);
          currentDrawnShape.strokeWeight(strokeWeight);
        }
        
        else if((appState == 2 || appState == 7 || appState == 9 || appState == 10) && editorShapeIndex == 1) {
          // println("Begin new straight line shape");
          currentDrawnShape = createShape();    
          currentDrawnShape.setFill(defaultShapeFillColour);
          
          currentDrawnShape.beginShape();
          currentDrawnShape.stroke(strokeColour);
          currentDrawnShape.strokeWeight(strokeWeight);
        }
        
        // Debug
        // println("No. of shapes drawn so far: ", drawnShapeList.size());
      }
    }
  }
}


// Keyboard helper functions - Author prince_polka, 2017
// Ref: https://forum.processing.org/two/discussion/13928/reading-ctrl-z-in-keypressed.html

// bitmap for all keys held together. Will definitely fail with very high nunmber of keypresses
boolean[] keysHeld = new boolean[512];

// Populate bitmap entry for any key-press
void keyPressed(){ 
  keysHeld[keyCode] = true; 
  /* println(keyCode); */
  
  // Book-keeping
  totalNoOfKeyPressed += 1;
} 

// Flush when a key is released 
void keyReleased(){ 
  keysHeld[keyCode] = false; 
  
  // Hack-fixing undo via keyCode == 8, "Backspace"
  if(keyCode == 8){
    // println("Undo invoked - single key");
    undoLastDrawnShape();
  }
}

// Check if a combination of keys are pressed simultaneously 
boolean keyCombo(int...k){
  for (int i=0; i<k.length; i++)
  { if (!keysHeld[k[i]]){ return false;} }
  return true;
}

// Full-shortcut suite
// =============================================
// Keycode,  Actual Key,  Action
// -------+------------+------------------------
// 70,       "F"          Select Free-form line
// 83,       "S"          Select Straight line
// 82,       "R"          Select Rectangle 
// 79,       "O"          Select Oval
//..............................................
// 17, 49,   "Ctrl" + "1" Select Black colour
// 17, 50,   "Ctrl" + "2" Select Red colour
// 17, 51,   "Ctrl" + "3" Select Green colour
// 17, 52,   "Ctrl" + "4" Select Blue colour 
//..............................................
// 49,       "1"          Select Thin weight
// 50,       "2"          Select Medium weight
// 51,       "3"          Select Thick weight
// 17, 90,   "Ctrl" + "Z" Delete last drawn shape  --- Abandonning this implementation
// 8,        "Backspace"  Delete last drawn shape
//----------------------------------------------

void updateEditorKeyboardShortcuts(){
  
  // Comobination shortcuts 
  
  // Undo-combination: Invoked multiple time, abandon this implementation 
  // if(keyCombo(17, 90)) { println("Undo invoked - combination"); }
  
  // Colour Options
  if(keyCombo(17, 49)) { editorColourIndex = 0; }
  else if(keyCombo(17, 50)) { editorColourIndex = 1; }
  else if(keyCombo(17, 51)) { editorColourIndex = 2; }
  else if(keyCombo(17, 52)) { editorColourIndex = 3; }
  
  
  // Single key shortcuts 
  // Shape Options
  // |- Free-form
  else if(keyCombo(70)) { 
    
    // Initial setup for the interactive shape being drawn
    // println("Begin new free-form shape");
    currentDrawnShape = createShape();
    currentDrawnShape.setFill(defaultShapeFillColour);
    
    currentDrawnShape.beginShape();
    currentDrawnShape.stroke(strokeColour);
    currentDrawnShape.strokeWeight(strokeWeight);
    
    // Update current editor status 
    editorShapeIndex = 0; 
  }
  // |- Straight line 
  else if(keyCombo(83)) { 
    
    // Initial setup for the interactive shape being drawn
    // println("Begin new straight-line shape");
    currentDrawnShape = createShape();
    currentDrawnShape.setFill(defaultShapeFillColour);
    
    currentDrawnShape.beginShape();
    currentDrawnShape.stroke(strokeColour);
    currentDrawnShape.strokeWeight(strokeWeight);
    
    // Update editor status 
    editorShapeIndex = 1; 
  }
  // |- Rectangle 
  else if(keyCombo(82)) { 
    // Update editor status 
    editorShapeIndex = 2; 
  } 
  // '- Oval
  else if(keyCombo(79)) { editorShapeIndex = 3; }
  
  // Weight Options 
  else if(keyCombo(49)) { editorWeightIndex = 0; }
  else if(keyCombo(50)) { editorWeightIndex = 1; }
  else if(keyCombo(51)) { editorWeightIndex = 2; }
  
  // Undo-single key: Invoked multiple time, abandon this implementation 
  // else if(keyCombo(8)) { println("Undo invoked - single key"); }
}


void updateEditorKeyboardShortcutsOnlyFreeform(){

  if(keyCombo(70)) { 
    
    // Initial setup for the interactive shape being drawn
    // println("Begin new free-form shape");
    currentDrawnShape = createShape();
    currentDrawnShape.setFill(defaultShapeFillColour);
    
    currentDrawnShape.beginShape();
    currentDrawnShape.stroke(strokeColour);
    currentDrawnShape.strokeWeight(strokeWeight);
    
    // Update current editor status 
    editorShapeIndex = 0; 
  }
}

void updateEditorKeyboardShortcutsOnlyStraight(){
  if(keyCombo(83)) { 
    
    // Initial setup for the interactive shape being drawn
    // println("Begin new straight-line shape");
    currentDrawnShape = createShape();
    currentDrawnShape.setFill(defaultShapeFillColour);
    
    currentDrawnShape.beginShape();
    currentDrawnShape.stroke(strokeColour);
    currentDrawnShape.strokeWeight(strokeWeight);
    
    // Update editor status 
    editorShapeIndex = 1; 
  }
}

void updateEditorKeyboardShortcutsOnlyRectangle(){
  // |- Rectangle 
  if(keyCombo(82)) { 
    // Update editor status 
    editorShapeIndex = 2; 
  } 
}

void updateEditorKeyboardShortcutsOnlyOval(){
  // '- Oval
  if(keyCombo(79)) { editorShapeIndex = 3; }
}

void updateEditorKeyboardShortcutsOnlyColours(){
  
  // Comobination shortcuts 
  // Colour Options
  if(keyCombo(17, 49)) { editorColourIndex = 0; }
  else if(keyCombo(17, 50)) { editorColourIndex = 1; }
  else if(keyCombo(17, 51)) { editorColourIndex = 2; }
  else if(keyCombo(17, 52)) { editorColourIndex = 3; }
}

void updateEditorKeyboardShortcutsOnlyWeights(){
  
  // To-override 
  // Comobination shortcuts 
  // Colour Options
  if(keyCombo(17, 49)) { /* DO NOTHING */ }
  else if(keyCombo(17, 50)) { /* DO NOTHING */ }
  else if(keyCombo(17, 51)) { /* DO NOTHING */ }
  else if(keyCombo(17, 52)) { /* DO NOTHING */ }
  
  // Weight Options 
  else if(keyCombo(49)) { editorWeightIndex = 0; }
  else if(keyCombo(50)) { editorWeightIndex = 1; }
  else if(keyCombo(51)) { editorWeightIndex = 2; }

}


// ----  Screen UI follows ----------------------------------------------------------------------------------------------------------------------------------------------------------------------

// Tutorial: Selecting and drawing straight line with a shortcut key 
void tutorialShortcutStraightlineScreen() {
  background(screenBgColour);
  fill(textDefaultColour);
  textFont(headerPFont);
  text("Tutorial: Draw Straight line", 32, 58);
  
  // Check if selection task if free-form line selected
  if(editorShapeIndex == 1){
    tutStraightSelectedShortcut = true;
  }
  // Then draw circle
  if(tutStraightSelectedShortcut){
    image(checkCircleGreenImage, 32, 74, 18, 18);
  }
  textFont(defaultCopyPFont);
  text("Press “S” to select “Straight line”", 58, 90);
  
  
  // Check if a single object has been drawn
  if(drawnShapeList.size() > 0){
    tutStraightDrawnShortcut = true;
  }
  // Then draw circle
  if(tutStraightDrawnShortcut){
    image(checkCircleGreenImage, 32, 104, 18, 18);
  }
  textFont(defaultCopyPFont);
  text("Left click and drag the pointer to draw", 58, 121);
  
  textFont(captionPFont);
  text("Drawing area", 32, 171);
  
  // Drawing area
  drawDrawArea(32, 181, 559, 365);

  // Display all the drawn shapes
  for(PShape drawnPShape : drawnShapeList){
    drawnPShape.setFill(defaultShapeFillColour);
    shape(drawnPShape);
  }
  
  fill(textDefaultColour);
  textFont(captionPFont);
  text("Current settings", 576, 171);
  
  // Editor status area 
  drawCurrentSettings(575, 181, true, false, false);
  
  // Update editor state for keyPresses
  // updateEditorKeyboardShortcuts();
  updateEditorKeyboardShortcutsOnlyStraight();
  
  
  noStroke();
  
  // Check if tutorial tasks are done 
  if( tutStraightSelectedShortcut && tutStraightDrawnShortcut && !buttonNextTutorialShortcutRectangleActivated) {    
    buttonNextTutorialShortcutRectangleBgColour = buttonPrimaryDefaultBgColour;
    
    // Change colour only once, so Hover and Pressed state can work
    buttonNextTutorialShortcutRectangleActivated = true;
  }
  
  fill(buttonNextTutorialShortcutRectangleBgColour);
  rect(32, 381, 362, 417, 4);
  
  fill(textButtonPrimaryLabelColour);
  textFont(buttonLabelPFont);
  text("Next: Rectangle", 141, 404);
}

// Tutorial: Selecting and drawing Rectangle with a shortcut key 
void tutorialShortcutRectangleScreen() {
  background(screenBgColour);
  fill(textDefaultColour);
  textFont(headerPFont);
  text("Tutorial: Draw Rectangle", 32, 58);
  
  // Check if selection task if free-form line selected
  if(editorShapeIndex == 2){
    tutRectangleSelectedShortcut = true;
  }
  // Then draw circle
  if(tutRectangleSelectedShortcut){
    image(checkCircleGreenImage, 32, 74, 18, 18);
  }
  textFont(defaultCopyPFont);
  text("Press “R” to select “Rectangle”", 58, 90);
  
  
  // Check if a single object has been drawn
  if(drawnShapeList.size() > 0){
    tutRectangleDrawnShortcut = true;
  }
  // Then draw circle
  if(tutRectangleDrawnShortcut){
    image(checkCircleGreenImage, 32, 104, 18, 18);
  }
  textFont(defaultCopyPFont);
  text("Left click and drag the pointer to draw from top-left corner to bottom-right corner", 58, 121);
  
  textFont(captionPFont);
  text("Drawing area", 32, 171);
  
  // Drawing area
  drawDrawArea(32, 181, 559, 365);

  // Display all the drawn shapes
  for(PShape drawnPShape : drawnShapeList){
    drawnPShape.setFill(defaultShapeFillColour);
    shape(drawnPShape);
  }
  
  fill(textDefaultColour);
  textFont(captionPFont);
  text("Current settings", 576, 171);
  
  // Editor status area 
  drawCurrentSettings(575, 181, true, false, false);
  
  // Update editor state for keyPresses
  // updateEditorKeyboardShortcuts();
  updateEditorKeyboardShortcutsOnlyRectangle();
  
  
  noStroke();
  
  // Check if tutorial tasks are done 
  if( tutRectangleSelectedShortcut && tutRectangleDrawnShortcut && !buttonNextTutorialShortcutOvalActivated) {    
    buttonNextTutorialShortcutOvalBgColour = buttonPrimaryDefaultBgColour;
    
    // Change colour only once, so Hover and Pressed state can work
    buttonNextTutorialShortcutOvalActivated = true;
  }
  
  fill(buttonNextTutorialShortcutOvalBgColour);
  rect(32, 381, 362, 417, 4);
  
  fill(textButtonPrimaryLabelColour);
  textFont(buttonLabelPFont);
  text("Next: Oval", 161, 404);
}


// Tutorial: Selecting and drawing Oval with a shortcut key 
void tutorialShortcutOvalScreen() {
  background(screenBgColour);
  fill(textDefaultColour);
  textFont(headerPFont);
  text("Tutorial: Draw Oval", 32, 58);
  
  // Check if selection task if free-form line selected
  if(editorShapeIndex == 3){
    tutOvalSelectedShortcut = true;
  }
  // Then draw circle
  if(tutOvalSelectedShortcut){
    image(checkCircleGreenImage, 32, 74, 18, 18);
  }
  textFont(defaultCopyPFont);
  text("Press “O” to select “Oval”", 58, 90);
  
  
  // Check if a single object has been drawn
  if(drawnShapeList.size() > 0){
    tutOvalDrawnShortcut = true;
  }
  // Then draw circle
  if(tutOvalDrawnShortcut){
    image(checkCircleGreenImage, 32, 104, 18, 18);
  }
  textFont(defaultCopyPFont);
  text("Left click and drag the pointer to draw from top-left corner to bottom-right corner", 58, 121);
  
  textFont(captionPFont);
  text("Drawing area", 32, 171);
  
  // Drawing area
  drawDrawArea(32, 181, 559, 365);

  // Display all the drawn shapes
  for(PShape drawnPShape : drawnShapeList){
    drawnPShape.setFill(defaultShapeFillColour);
    shape(drawnPShape);
  }
  
  fill(textDefaultColour);
  textFont(captionPFont);
  text("Current settings", 576, 171);
  
  // Editor status area 
  drawCurrentSettings(575, 181, true, false, false);
  
  // Update editor state for keyPresses
  // updateEditorKeyboardShortcuts();
  updateEditorKeyboardShortcutsOnlyOval();
  
  noStroke();
  
  // Check if tutorial tasks are done 
  if( tutOvalSelectedShortcut && tutOvalDrawnShortcut && !buttonNextTutorialShortcutColourActivated) {    
    buttonNextTutorialShortcutColourBgColour = buttonPrimaryDefaultBgColour;
    
    // Change colour only once, so Hover and Pressed state can work
    buttonNextTutorialShortcutColourActivated = true;
  }
  
  fill(buttonNextTutorialShortcutColourBgColour);
  rect(32, 381, 362, 417, 4);
  
  fill(textButtonPrimaryLabelColour);
  textFont(buttonLabelPFont);
  text("Next: Colours", 149, 404);
}



// Tutorial: Selecting colours and drawing with each using shortcut key 
void tutorialShortcutColoursScreen() {
  background(screenBgColour);
  fill(textDefaultColour);
  textFont(headerPFont);
  text("Tutorial: Change line colours", 32, 58);
  
  if(keyCombo(17, 49)) { tutColour1SelectedShortcut = true; }
  if(keyCombo(17, 50)) { tutColour2SelectedShortcut = true; }
  if(keyCombo(17, 51)) { tutColour3SelectedShortcut = true; }
  if(keyCombo(17, 52)) { tutColour4SelectedShortcut = true; }
  
  // Check if selection task if free-form line selected
  if(tutColour1SelectedShortcut && tutColour2SelectedShortcut && tutColour3SelectedShortcut && tutColour4SelectedShortcut){
    tutAllColoursSelectedShortcut = true;
  }
  // Then draw circle
  if(tutAllColoursSelectedShortcut){
    image(checkCircleGreenImage, 32, 74, 18, 18);
  }
  textFont(defaultCopyPFont);
  text("Press “Ctrl” + “1”, “2”, “3” and “4” to select the available colours", 58, 90);
  
  // Check if at least one shape with each colour has been drawn
  if(tutColour1DrawnShortcut && tutColour2DrawnShortcut && tutColour3DrawnShortcut && tutColour4DrawnShortcut){
    tutDrawnWithAllColoursShortcut = true;
  }
  // Then draw circle
  if(tutDrawnWithAllColoursShortcut){
    image(checkCircleGreenImage, 32, 104, 18, 18);
  }
  textFont(defaultCopyPFont);
  text("Draw one rectangle of each colour", 58, 121);
  
  textFont(captionPFont);
  text("Drawing area", 32, 171);
  
  // Drawing area
  drawDrawArea(32, 181, 559, 365);


  // Display all the drawn shapes
  for(PShape drawnPShape : drawnShapeList){
    drawnPShape.setFill(defaultShapeFillColour);
    shape(drawnPShape);
    
    // Check if each colour is used
    if(drawnPShape.getStroke(0) == colourOptions[0]) { tutColour1DrawnShortcut = true; }
    if(drawnPShape.getStroke(0) == colourOptions[1]) { tutColour2DrawnShortcut = true; }
    if(drawnPShape.getStroke(0) == colourOptions[2]) { tutColour3DrawnShortcut = true; }
    if(drawnPShape.getStroke(0) == colourOptions[3]) { tutColour4DrawnShortcut = true; }
  }
  
  fill(textDefaultColour);
  textFont(captionPFont);
  text("Current settings", 576, 171);
  
  // Editor status area 
  drawCurrentSettings(575, 181, false, true, false);
  
  // Update editor state for keyPresses
  // updateEditorKeyboardShortcuts();
  updateEditorKeyboardShortcutsOnlyColours();
  
  
  noStroke();
  
  // Check if tutorial tasks are done 
  if( tutAllColoursSelectedShortcut && tutDrawnWithAllColoursShortcut && !buttonNextTutorialShortcutWeightActivated) {    
    buttonNextTutorialShortcutWeightBgColour = buttonPrimaryDefaultBgColour;
    
    // Change colour only once, so Hover and Pressed state can work
    buttonNextTutorialShortcutWeightActivated = true;
  }
  
  fill(buttonNextTutorialShortcutWeightBgColour);
  rect(32, 381, 362, 417, 4);
  
  fill(textButtonPrimaryLabelColour);
  textFont(buttonLabelPFont);
  text("Next: Weights", 148, 404);
}


// Tutorial: Selecting weights and drawing with each using shortcut key 
void tutorialShortcutWeightsScreen() {
  background(screenBgColour);
  fill(textDefaultColour);
  textFont(headerPFont);
  text("Tutorial: Change line weights", 32, 58);
  
  if(keyCombo(49)) { tutWeight1SelectedShortcut = true; }
  if(keyCombo(50)) { tutWeight2SelectedShortcut = true; }
  if(keyCombo(51)) { tutWeight3SelectedShortcut = true; }
  
  // Check if selection task of all line weights are done
  if(tutWeight1SelectedShortcut && tutWeight2SelectedShortcut && tutWeight3SelectedShortcut ){
    tutAllWeightsSelectedShortcut = true;
  }
  // Then draw circle
  if(tutAllWeightsSelectedShortcut){
    image(checkCircleGreenImage, 32, 74, 18, 18);
  }
  textFont(defaultCopyPFont);
  text("Press “1”, “2” and “3” to select thin, medium and thick line weights respectively", 58, 90);
  
  // Check if at least one shape with each weight has been drawn
  if(tutWeight1DrawnShortcut && tutWeight2DrawnShortcut && tutWeight3DrawnShortcut){
    tutDrawnWithAllWeightsShortcut = true;
  }
  // Then draw circle
  if(tutDrawnWithAllWeightsShortcut){
    image(checkCircleGreenImage, 32, 104, 18, 18);
  }
  textFont(defaultCopyPFont);
  text("Draw one oval of each weight", 58, 121);
  
  textFont(captionPFont);
  text("Drawing area", 32, 171);
  
  // Drawing area
  drawDrawArea(32, 181, 559, 365);


  // Display all the drawn shapes
  for(PShape drawnPShape : drawnShapeList){
    drawnPShape.setFill(defaultShapeFillColour);
    shape(drawnPShape);
    
    // Check if each weight is used
    if(drawnPShape.getStrokeWeight(0) == (float) weightOptions[0]) { tutWeight1DrawnShortcut = true; }
    if(drawnPShape.getStrokeWeight(0) == (float) weightOptions[1]) { tutWeight2DrawnShortcut = true; }
    if(drawnPShape.getStrokeWeight(0) == (float) weightOptions[2]) { tutWeight3DrawnShortcut = true; }
  }
  
  fill(textDefaultColour);
  textFont(captionPFont);
  text("Current settings", 576, 171);
  
  // Editor status area 
  drawCurrentSettings(575, 181, false, false, true);
  
  // Update editor state for keyPresses
  updateEditorKeyboardShortcutsOnlyWeights();
  
  
  noStroke();
  
  // Check if tutorial tasks are done 
  if( tutAllWeightsSelectedShortcut && tutDrawnWithAllWeightsShortcut && !buttonNextTutorialShortcutUndoActivated) {    
    buttonNextTutorialShortcutUndoBgColour = buttonPrimaryDefaultBgColour;
    
    // Change colour only once, so Hover and Pressed state can work
    buttonNextTutorialShortcutUndoActivated = true;
  }
  
  fill(buttonNextTutorialShortcutUndoBgColour);
  rect(32, 381, 362, 417, 4);
  
  fill(textButtonPrimaryLabelColour);
  textFont(buttonLabelPFont);
  text("Next: Undo", 158, 404);
}

// Tutorial: Undo
void tutorialShortcutUndoScreen() {
  background(screenBgColour);
  fill(textDefaultColour);
  textFont(headerPFont);
  text("Tutorial: Undo", 32, 58);
  
  // Check if three shapes have been drawn
  if(drawnShapeList.size() == 3){
    tut3ShapesDrawnShortcut = true;
  }
  // Then draw circle
  if(tut3ShapesDrawnShortcut){
    image(checkCircleGreenImage, 32, 74, 18, 18);
  }
  textFont(defaultCopyPFont);
  text("Draw at least 3 shapes", 58, 90);
  
  
  // Check if a three shapes have been deleated
  if(drawnShapeList.size() == 0 && tut3ShapesDrawnShortcut){
    tut3DeletedShortcut = true;
  }
  // Then draw circle
  if(tut3DeletedShortcut){
    image(checkCircleGreenImage, 32, 104, 18, 18);
  }
  textFont(defaultCopyPFont);
  text("Press “Backspace” to undo back to blank drawing area", 58, 121);
  
  textFont(captionPFont);
  text("Drawing area", 32, 171);
  
  // Drawing area
  drawDrawArea(32, 181, 559, 365);

  // Display all the drawn shapes
  for(PShape drawnPShape : drawnShapeList){
    drawnPShape.setFill(defaultShapeFillColour);
    shape(drawnPShape);
  }
  
  fill(textDefaultColour);
  textFont(captionPFont);
  text("Current settings", 576, 171);
  
  // Editor status area 
  drawCurrentSettings(575, 181, true, true, true);
  
  // Update editor state for keyPresses
  updateEditorKeyboardShortcuts();
  
  noStroke();
  
  // Check if tutorial tasks are done 
  if( tut3ShapesDrawnShortcut && tut3DeletedShortcut && !buttonNextTutorialShortcutReviewActivated) {    
    buttonNextTutorialShortcutReviewBgColour = buttonPrimaryDefaultBgColour;
    
    // Change colour only once, so Hover and Pressed state can work
    buttonNextTutorialShortcutReviewActivated = true;
  }
  
  fill(buttonNextTutorialShortcutReviewBgColour);
  rect(32, 381, 362, 417, 4);
  
  fill(textButtonPrimaryLabelColour);
  textFont(buttonLabelPFont);
  text("Next: Review", 151, 404);
}

// Review Keyboard Shortcuts Screen
void reviewKeyboardShortcutsScreen() {
  
  background(screenBgColour);
  
  // Draw vertical separators 
  stroke(defaultBorderColour);
  strokeWeight(defaultBorderWeight);
  line(230, 94, 230, 199);
  line(523, 94, 523, 199);
 
  fill(textDefaultColour);
  textFont(headerPFont);
  text("Review: All Shortcuts", 32, 58);
  
  // All Key combinations
  textFont(boldCopyPFont);
  text("F", 32, 112);
  text("S", 32, 140);
  text("R", 32, 168);
  text("O", 32, 196);
  
  text("Ctrl + 1", 289, 112);
  text("Ctrl + 2", 289, 140);
  text("Ctrl + 3", 289, 168);
  text("Ctrl + 4", 289, 196);
  
  text("1", 572, 112);
  text("2", 572, 140);
  text("3", 572, 168);
  
  text("Backspace", 32, 255);
  
  
  // All descriptions 
  textFont(defaultCopyPFont);
  text("Free-form line", 61, 112);
  text("Straight line", 61, 140);
  text("Rectangle", 61, 168);
  text("Oval", 61, 196);
  
  text("Black colour", 372, 112);
  text("Red colour", 372, 140);
  text("Green colour", 372, 168);
  text("Blue colour", 372, 196);
  
  text("Thin line weight", 601, 112);
  text("Medium line weight", 601, 140);
  text("Thick line weight", 601, 168);
  
  text("Undo last drawn shape", 135, 255);
  
  noStroke();
  fill(buttonNextTask1ShortcutBgColour);
  rect(32, 381, 362, 417, 4);
  
  fill(textButtonPrimaryLabelColour);
  textFont(buttonLabelPFont);
  text("Next: Drawing Task 1", 122, 404);
  
}

// Drawing task 1: Abstract / Canonical forms
void drawingTask1Screen() {
  background(screenBgColour);
  
  fill(textDefaultColour);
  textFont(headerPFont);
  text("Drawing Task 1", 32, 58);
  
  textFont(defaultCopyPFont);
  text("Draw a tree and move on to the next task", 228, 57);
  
  textFont(captionPFont);
  text("Drawing area", 32, 88);
  
  // Drawing area
  drawDrawArea(32, 98, 559, 365); 
  
  // Display all the drawn shapes
  for(PShape drawnPShape : drawnShapeList){
    drawnPShape.setFill(defaultShapeFillColour);
    shape(drawnPShape);
  }
  
  fill(textDefaultColour);
  textFont(captionPFont);
  text("Current settings", 576, 88);
  
  // Editor status area 
  drawCurrentSettings(575, 98, true, true, true);
  
  // Update editor state for keyPresses
  updateEditorKeyboardShortcuts();

  noStroke();
  fill(buttonNextTask2ShortcutBgColour);
  rect(32, 381, 362, 417, 4);
  
  fill(textButtonPrimaryLabelColour);
  textFont(buttonLabelPFont);
  text("Next: Drawing Task 2", 122, 404);
  
}

// Drawing task 2: Drawing known form
void drawingTask2Screen() {
  background(screenBgColour);
  
  fill(textDefaultColour);
  textFont(headerPFont);
  text("Drawing Task 2", 32, 58);
  
  textFont(defaultCopyPFont);
  text("Draw a flow diagram of a conditional statement", 228, 57);
  
  textFont(captionPFont);
  text("Drawing area", 32, 88);
  
  // Drawing area
  drawDrawArea(32, 98, 559, 365); 
  
  // Display all the drawn shapes
  for(PShape drawnPShape : drawnShapeList){
    drawnPShape.setFill(defaultShapeFillColour);
    shape(drawnPShape);
  }
  
  fill(textDefaultColour);
  textFont(captionPFont);
  text("Current settings", 576, 88);
  
  // Editor status area 
  drawCurrentSettings(575, 98, true, true, true);
  
  // Update editor state for keyPresses
  updateEditorKeyboardShortcuts();

  noStroke();
  fill(buttonNextConclusionShortcutBgColour);
  rect(32, 381, 362, 417, 4);
  
  fill(textButtonPrimaryLabelColour);
  textFont(buttonLabelPFont);
  text("Next: Conclude", 143, 404);
  
}

// Concluding screen: Appreciate and ask for outputs
void endingScreen() {
  
  background(screenBgColour);
 
  fill(textDefaultColour);
  textFont(headerPFont);
  text("Thank you for participating in the assignment!", 32, 58);
  
  textFont(defaultCopyPFont);
  text("Please copy the generated outputs and send it to us via Teams or Email", 32, 112);
  
  noStroke();
  fill(buttonExitBgColour);
  rect(32, 381, 362, 417, 4);
  
  fill(textButtonPrimaryLabelColour);
  textFont(buttonLabelPFont);
  text("Exit", 184, 404);
  
}
