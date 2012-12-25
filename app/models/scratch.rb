# -*- encoding : utf-8 -*-
class Scratch < Snippet

  def content
    read_attribute(:content) ||
<<-eos
void draw(){
  // ellipse(width / 2, height / 2, width, height);
}

void setup(){
  initial();
}

void initial(){
  size(sizeW, sizeH);
  background(0);
  frameRate(30);
  smooth();
  //noLoop();
  stroke(255);
}

float sizeW = 500.0;
flaot sizeH = 500.0;
float centerX = sizeW / 2;
float centerY = sizeH / 2;
eos
  end

end

