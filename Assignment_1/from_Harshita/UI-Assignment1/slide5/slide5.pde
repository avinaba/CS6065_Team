import controlP5.*;
ControlP5 cp5;
Button button;
Button button1;
Button button2;
Button button3;
Button button4;
void setup(){
  size(900,600);
  cp5 = new ControlP5(this);
 
 button1=cp5.addButton("   ")
            
            .setFont(createFont("arial",18))
            .setPosition(139,165)
            .setColorBackground(#5D5FEF)
            .setWidth(140)
            .setHeight(36)
 ;
 button2=cp5.addButton(" ")
            
            .setFont(createFont("arial",18))
            .setPosition(615,207)
            .setColorBackground(#BEBFF9)
            .setWidth(140)
            .setHeight(36)
 ;
  button=cp5.addButton("START")
            
            .setFont(createFont("arial",18))
            .setPosition(330,207)
            .setColorBackground(#BEBFF9)
            .setWidth(140)
            .setHeight(36)
 ;
 button3=cp5.addButton("START")
            
            .setFont(createFont("arial",18))
            .setPosition(390,207)
            .setColorBackground(#5D5FEF)
            .setWidth(140)
            .setHeight(36)
 ;
 button4=cp5.addButton(" ")
            
            .setFont(createFont("arial",18))
            .setPosition(615,207)
            .setColorBackground(#BEBFF9)
            .setWidth(140)
            .setHeight(36)
 ;
}
void draw(){
  background(255,255,255);
}
