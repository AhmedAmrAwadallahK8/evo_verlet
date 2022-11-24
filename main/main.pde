Universe sim;
Organism o;

void setup(){
  size(1800,1000);
  sim = new Universe();
  sim.addNRandomlyPlacedOrganisms(50);
  fill(0, 255); //200,140
  rect(-2,-2,width+2,height+2);
}
 
void draw(){
  //fill(0, 140); //200,140
  //rect(-2,-2,width+2,height+2);
  sim.run();
}
 
void mouseDragged(){
  //sim.addOrganism(new Organism(mouseX, mouseY, true));
}
 
void mousePressed(){
  //sim.addOrganism(new Organism(mouseX, mouseY, true));
}
