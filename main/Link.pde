class Link{
  
  Cell parent;
  Cell child;
  float stiffness;
  PVector head;
  PVector tail;
  PVector linkVec;
  float len;
  static final float radLen = 5;
  
  Link(Cell _parent, Cell _child, float _stiffness){
    parent = _parent;
    child = _child;
    stiffness = _stiffness;
    head = parent.pos;
    linkVec = new PVector(child.pos.x-parent.pos.x, child.pos.y-parent.pos.y);
    tail = PVector.add(head, linkVec);
    len = linkVec.mag();
  }
  
  void render(){
    PVector currLinkVec = PVector.sub(child.pos, parent.pos);
    float theta = currLinkVec.heading();
    fill(parent.col, 100); //fill(200, 100);
    stroke(parent.col); //stroke(255);
    pushMatrix();
    //translate(parent.pos.x, parent.pos.y); For line
    translate(parent.pos.x + (child.pos.x-parent.pos.x)/2, parent.pos.y + (child.pos.y-parent.pos.y)/2);
    rotate(theta);
    beginShape();
    
   
    ellipse(0,0,(child.pos.x-parent.pos.x)*cos(theta) + (child.pos.y-parent.pos.y)*sin(theta),radLen*3);
    //ellipse(0,0,10,radLen*3);
    //vertex(0, 0); For line
    //vertex(child.pos.x-parent.pos.x, child.pos.y-parent.pos.y); For line
    endShape();
    popMatrix();
  }
  
  void constrainLen(){ /* Why doesnt this update linkVec and len?*/
    PVector currLinkVec = new PVector(child.pos.x-parent.pos.x, child.pos.y-parent.pos.y);
    float currLen = currLinkVec.mag();
    float diff = ((currLen - len)/currLen);
    parent.pos.x += currLinkVec.x * (0.5 * stiffness * diff);
    parent.pos.y += currLinkVec.y * (0.5 * stiffness * diff);
    child.pos.x -= currLinkVec.x * (0.5 * stiffness * diff);
    child.pos.y -= currLinkVec.y * (0.5 * stiffness * diff);
  }
  
}
