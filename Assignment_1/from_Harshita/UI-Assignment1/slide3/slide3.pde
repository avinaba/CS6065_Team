import controlP5.*;
ControlP5 cp5;
Button button;
Button button1;
Button button2;
void setup(){
  size(800,485);
  cp5 = new ControlP5(this);
  button=cp5.addButton("")
            .setValue(128)
            .setFont(createFont("arial",18))
            .setPosition(207,165)
            .setColorBackground(#BEBFF9)
            .setWidth(140)
            .setHeight(36)
 ;
 button1=cp5.addButton("START")
            .setValue(128)
            .setFont(createFont("arial",18))
            .setPosition(390,165)
            .setColorBackground(#5D5FEF)
            .setWidth(140)
            .setHeight(36)
 ;
 button2=cp5.addButton("")
            .setValue(128)
            .setFont(createFont("arial",18))
            .setPosition(573,165)
            .setColorBackground(#BEBFF9)
            .setWidth(140)
            .setHeight(36)
 ;
}
void draw(){
  background(255,255,255);
}
