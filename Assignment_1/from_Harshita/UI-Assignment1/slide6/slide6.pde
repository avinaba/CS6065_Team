import controlP5.*;
ControlP5 cp5;
Textlabel label1;
Textlabel label2;
Button button;

void setup(){
  size(900,600);
  cp5 = new ControlP5(this);
  label1=cp5.addTextlabel("label1")
             .setText("Block 2 out of 3, done")
             .setFont(createFont("arial Bold",26))
             .setPosition(32,32)
             .setColorValue(#000000)
             .setHeight(30)
             .setWidth(255)
             .setLineHeight(30)
             ;
  label2=cp5.addTextlabel("label2")
             .setText("You are done with a block, to begin the next click on the button below")
             .setFont(createFont("arial",18))
             .setPosition(32,102)
             .setColorValue(#000000)
             .setHeight(21)
             .setWidth(551)
             .setLineHeight(30)
             ;
  button=cp5.addButton("Next: Begin Trials")
            
            .setFont(createFont("arial",18))
            .setPosition(32,155)
            .setColorBackground(#5D5FEF)
            .setWidth(330)
            .setHeight(36)
            .setColorForeground(color(239,181,93))
         
 ;
 
}
void draw(){
  background(255,255,255);
}
