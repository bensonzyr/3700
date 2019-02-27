/**
Super simple processing sketch that sends Mouse x, y and click to localhost port 6000
**/

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress server;

PFont f;

void setup() {
  f = createFont("Courier", 16);
  textFont(f);

  size(640, 480, P2D);
  noStroke();
  
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,12000);
  server = new NetAddress("127.0.0.1",6000);
  
}

void draw() {
  background(0);
  fill(255);
  ellipse(mouseX, mouseY, 10, 10);
  if(frameCount % 2 == 0) {
    // send mouse position every 2 frames
    sendMouseXY();
  }
  text("Continuously sends mouse x and y position (2 inputs)\nto localhost:6000", 10, 30);
  text("x=" + mouseX + ", y=" + mouseY, 10, 80);
}

void sendMouseXY() {
  OscMessage msg = new OscMessage("/input/mouse/position");
  msg.add((float)mouseX); 
  msg.add((float)mouseY);
  oscP5.send(msg, server);
}

void mousePressed() {
  OscMessage msg = new OscMessage("/input/mouse/click");
  msg.add(1); 
  oscP5.send(msg, server);
}
