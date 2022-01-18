import controlP5.*;
ControlP5 cp5;
Textlabel label1;
Textlabel label2;
Textlabel label3;
Textlabel label4;
Textlabel label5;
Textlabel label6;
Textlabel label7;
Button button1;
 void setup(){
  size(1030,485);
  cp5 = new ControlP5(this);
   label1=cp5.addTextlabel("label")
  
             .setText("Instructions")
             .setFont(createFont("arial",26))
             .setPosition(32,32)
             .setColorValue(#000000)
             .setHeight(30)
             .setWidth(141)
             .setLineHeight(30)
           ;
   label2=cp5.addTextlabel("label1")
             .setText("Step1")
             .setFont(createFont("arial",16))
             .setPosition(32,102)
             .setColorValue(#000000)
             .setHeight(18)
             .setWidth(45)
             .setLineHeight(30)
             ;
   label3=cp5.addTextlabel("label2")
             .setText("Click on the “start” button at the center of the next screen to begin a “trial”")
             .setFont(createFont("arial",18))
             .setPosition(32,122)
             .setColorValue(#000000)
             .setHeight(21)
             .setWidth(588)
             .setLineHeight(30)
             ;
   label4=cp5.addTextlabel("label3")
  
             .setText("Step2")
             .setFont(createFont("arial",16))
             .setPosition(32,175)
             .setColorValue(#000000)
             .setHeight(18)
             .setWidth(45)
             .setLineHeight(30)
             ;
           ;
   label5=cp5.addTextlabel("label4")
             .setText("Click on the “illuminated” button as fast as you can. E.g: ")
             .setFont(createFont("arial",18))
             .setPosition(32,195)
             .setColorValue(#000000)
             .setHeight(21)
             .setWidth(444)
             .setLineHeight(21)
             ;
   button1=cp5.addButton("")
            .setValue(128)
            .setFont(createFont("arial",18))
            .setPosition(482,195)
            .setColorBackground(#EFB55D)
            .setWidth(161)
            .setHeight(36)
      ;
   label6=cp5.addTextlabel("label5")
  
             .setText("Step3")
             .setFont(createFont("arial",16))
             .setPosition(32,248)
             .setColorValue(#000000)
             .setHeight(18)
             .setWidth(45)
             .setLineHeight(30)
             ;
                      ;
   label7=cp5.addTextlabel("label6")
             .setText("Repeat Step 1 and 2 for 20 times, thrice to complete the exercise ")
             .setFont(createFont("arial",18))
             .setPosition(32,268)
             .setColorValue(#000000)
             .setHeight(21)
             .setWidth(516)
             .setLineHeight(21)
             
           ;
    button1=cp5.addButton("Next:Begin Trials")
            .setValue(128)
            .setFont(createFont("arial",18))
            .setPosition(37,380)
            .setColorBackground(#5D5FEF)
            .setWidth(330)
            .setHeight(36)
      ;
  
}
void draw() {
  background(255,255,255);
  
}
