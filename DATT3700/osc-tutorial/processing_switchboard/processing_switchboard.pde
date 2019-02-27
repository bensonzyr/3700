/**
 * oscP5sendreceive by andreas schlegel
 * example shows how to send and receive osc messages.
 * oscP5 website at http://www.sojamo.de/oscP5
 */
 
import oscP5.*;
import netP5.*;
  
OscP5 oscP5;
NetAddress pd;

float r = 0, g = 0, b = 0;
float x = 0, y = 0;

void setup() {
  size(640, 480);

  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,6000);
  
  /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
   * an ip address and a port number. myRemoteLocation is used as parameter in
   * oscP5.send() when sending osc packets to another computer, device, 
   * application. usage see below. for testing purposes the listening port
   * and the port of the remote location address are the same, hence you will
   * send messages back to this sketch.
   */
  pd = new NetAddress("127.0.0.1",6010);
}


void draw() {
  fill(255);
  background(r, g, b);
  ellipse(x, y, 10, 10); 
}

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  if(theOscMessage.checkAddrPattern("/input/mouse/position")==true) {
    /* check if the typetag is the right one. */
    if(theOscMessage.checkTypetag("ff")) {
      /* parse theOscMessage and extract the values from the osc message arguments. */
      float firstValue = theOscMessage.get(0).floatValue();  
      float secondValue = theOscMessage.get(1).floatValue();
      print("### received an osc message /test with typetag ifs.");
      println(" values: " + firstValue+", " + secondValue);

      x = firstValue;
      y = secondValue;
      
      float xNormalized = map(x, 0, width, 0, 1);
      float yNormalized = map(y, 0, height, 0, 1);
      
      OscMessage msg = new OscMessage("/sound/xy");
      msg.add((float)xNormalized);
      msg.add((float)yNormalized);
      oscP5.send(msg, pd);

      return;
    }  
  } else if (theOscMessage.checkAddrPattern("/input/mouse/click")==true) {
    println("CLICK");
    r = random(255);
    g = random(255);
    b = random(255);
    
      OscMessage msg = new OscMessage("/sound/click");
      oscP5.send(msg, pd);
    
    return;
  }
}
