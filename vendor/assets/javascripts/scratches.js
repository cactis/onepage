alert('hi loadxxxxxxxxx');

  int prevX, prevY = 0;
  float xoff = 0.0;

  void setup(){
  size(644, 400);
  background(0);
  smooth();
  bg_noise();
  }

  void draw(){
  float n = noise(xoff + 3);
  if ( mousePressed == true) {
  stroke(245);
  strokeWeight(2);
  line(mouseX, mouseY, prevX, prevY);

  strokeWeight(1);
  stroke(240);
  line(mouseX + n, mouseY + n, prevX + n, prevY + n);
  n += 0.5;

  strokeWeight(1);
  stroke(180);
  line(mouseX + n, mouseY + n, prevX + n, prevY + n);

  strokeWeight(1);
  stroke(165);
  line(mouseX + n, mouseY + n, prevX + n, prevY + n);
  n += 0.5;

  strokeWeight(1);
  stroke(140);
  line(mouseX + n, mouseY + n, prevX + n, prevY + n);

  } else {
  cursor(ARROW);
  }
  prevX = mouseX;
  prevY = mouseY;
  }

  void bg_noise(){
  stroke(100);
  strokeWeight(3);
  point(10, 10);
  }

