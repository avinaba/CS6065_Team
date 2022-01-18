import controlP5.*;
ControlP5 cp5;
Button button;
Button button1;
Button button2;
Button button3;
Button button4;
Button button5;
Button button6;
Button button7;
Button button8;

void setup(){
  size(900,600);
  cp5 = new ControlP5(this);
 
 button1=cp5.addButton(" A  ")
            
            .setFont(createFont("arial",18))
            .setPosition(166,176)
            .setColorBackground(#BEBFF9)
            .setWidth(140)
            .setHeight(36)
 ;
 button2=cp5.addButton("B ")
            
            .setFont(createFont("arial",18))
            .setPosition(166,239)
            .setColorBackground(#BEBFF9)
            .setWidth(140)
            .setHeight(36)
 ;
 button5=cp5.addButton(" E ")
            
            .setFont(createFont("arial",18))
            .setPosition(236,113)
            .setColorBackground(#BEBFF9)
            .setWidth(140)
            .setHeight(36)
 ;
 button6=cp5.addButton("F ")
            
            .setFont(createFont("arial",18))
            .setPosition(236,302)
            .setColorBackground(#BEBFF9)
            .setWidth(140)
            .setHeight(36)
 ;
  button=cp5.addButton("START")
            
            .setFont(createFont("arial",18))
            .setPosition(400,207)
            .setColorBackground(#5D5FEF)
            .setWidth(140)
            .setHeight(36)
 ;
 button3=cp5.addButton("C")
            
            .setFont(createFont("arial",18))
            .setPosition(625,176)
            .setColorBackground(#BEBFF9)
            .setWidth(140)
            .setHeight(36)
 ;
 button4=cp5.addButton("D")
            
            .setFont(createFont("arial",18))
            .setPosition(625,239)
            .setColorBackground(#BEBFF9)
            .setWidth(140)
            .setHeight(36)
 ;
 button7=cp5.addButton("G")
            
            .setFont(createFont("arial",18))
            .setPosition(555,113)
            .setColorBackground(#BEBFF9)
            .setWidth(140)
            .setHeight(36)
 ;
 button8=cp5.addButton("H")
            
            .setFont(createFont("arial",18))
            .setPosition(555,302)
            .setColorBackground(#BEBFF9)
            .setWidth(140)
            .setHeight(36)
 ;
}
void draw(){
  background(255,255,255);
}
