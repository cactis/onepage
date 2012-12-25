alert('hi load');

int prevX, prevY = 0;
float xoff = 0.0;

void setup(){
  size(644, 400);
  background(0);
  smooth();
}

void draw(){
  if ( mousePressed == true) {
    mydrawline(2, 255, mouseX, mouseY, prevX, prevY);
  } else {

  }

  prevX = mouseX;
  prevY = mouseY;
}

void mydrawline(weight, color, x1, y1, x2, y2, offset){
  float xoff = 0.0;
  float n = noise(xoff);
  myline(1, 200, x1, y1, x2, y2, n + 0.2);
  myline(2, 220, x1, y1, x2, y2, 0);
  myline(1, 200, x1, y1, x2, y2, n - 0.2);
}

void myline(weight, color, x1, y1, x2, y2, n){
  strokeWeight(weight);
  stroke(color);
  line(x1, y1 + n, x2 + n + n, y2 + n);
}

