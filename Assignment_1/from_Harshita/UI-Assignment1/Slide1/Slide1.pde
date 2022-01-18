import controlP5.*;

  ControlP5 cp5;
   Textlabel mainLabel;
   Textlabel line1;
   Textlabel name1;
   Textlabel name2;
   Textlabel name3;
   Textlabel instruct1;
   Textfield field1;
   Button button1;
  
  void setup(){
  size(1030,485);
  cp5 = new ControlP5(this);
      
        mainLabel=cp5.addTextlabel("label")
  
            .setText("CS6065: ASSIGNMENT 1")
            .setFont(createFont("Roboto",26))
           .setPosition(32,32)
           .setColorValue(#000000)
           .setHeight(30)
           .setWidth(269)
           .setLineHeight(30)
           ;
         line1=cp5.addTextlabel("label1")
  
            .setText("Investigating the Human Factors of Reaction Time")
            .setFont(createFont("Roboto",16))
           .setPosition(32,71)
           .setColorValue(#000000)
           .setHeight(19)
           .setWidth(356)
           .setLineHeight(19)
       
       ;
         name1=cp5.addTextlabel("label2")
  
            .setText("Harshita")
            .setFont(createFont("Roboto",18))
           .setPosition(32,120)
           .setColorValue(#000000)
           .setHeight(21)
           .setWidth(69)
           .setLineHeight(21)
       
       ;
       name2=cp5.addTextlabel("label3")
  
            .setText("Shubham")
            .setFont(createFont("Roboto",18))
           .setPosition(116,120)
           .setColorValue(#000000)
           .setHeight(21)
           .setWidth(77)
           .setLineHeight(21)
       
       ;
       name3=cp5.addTextlabel("label4")
  
            .setText("Avinaba")
            .setFont(createFont("Roboto",18))
           .setPosition(208,120)
           .setColorValue(#000000)
           .setHeight(21)
           .setWidth(77)
           .setLineHeight(21)
       
       ;
       instruct1=cp5.addTextlabel("label5")
  
            .setText("Enter the user number")
            .setFont(createFont("Roboto",18))
           .setPosition(32,305)
           .setColorValue(#000000)
           .setHeight(21)
           .setWidth(77)
           .setLineHeight(21)
       
       ;
      field1=cp5.addTextfield("textInput_1")
                .setPosition(37, 330)
                .setSize(200, 40)
                .setFont(createFont("arial", 20))
                .setColor(color(0,0,0))
                .setColorBackground(#ffffff)
               
            ;
      button1=cp5.addButton("Next:Instructions")
      .setValue(128)
      .setFont(createFont("Roboto",18))
      .setPosition(37,380)
      .setColorBackground(#5D5FEF)
      .setWidth(330)
      .setHeight(36)
      ;
        
  }
  void draw() {
  background(255,255,255);
  
}
