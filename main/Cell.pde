class Cell{
  
  Link parentLink;
  Link childLink;
  PVector startPos, pos, prevPos;
  float pForceMagX;
  float pForceFreqX;
  float pForceMagY;
  float pForceFreqY;
  float stiffness;
  float seperation;
  float sepTime;
  color col;
  
  static final float minForceFreq = 0.001;
  static final float maxForceFreq = 100;
  //static final float minForceMag = 0.001;
  //static final float maxForceMag = 0.1;
  static final float minForceMag = 0.001;
  static final float maxForceMag = 1;
  static final float minStiff = 0.00001;
  static final float maxStiff = 0.2;
  static final float radius = 5;
  static final int framesPerSimStep = 15;
  static final float sepFactor = 4.5;
  
  Cell(float x, float y, float _stiffness){
    pos = new PVector(x,y);
    prevPos = new PVector(x, y);
    startPos = new PVector(x, y);
    stiffness = _stiffness;
    pForceFreqX = random(minForceFreq,maxForceFreq);
    pForceMagX = random(minForceMag, maxForceMag);
    pForceFreqY = random(minForceFreq,maxForceFreq);
    pForceMagY = random(minForceMag, maxForceMag);
    
    seperation = 0;
    sepTime = 0;
  }
  
  
  Cell(float x, float y){
    pos = new PVector(x,y);
    prevPos = new PVector(x, y);
    startPos = new PVector(x, y);
    stiffness = random(minStiff, maxStiff);
    pForceFreqX = random(minForceFreq,maxForceFreq);
    pForceMagX = random(minForceMag, maxForceMag);
    pForceFreqY = random(minForceFreq,maxForceFreq);
    pForceMagY = random(minForceMag, maxForceMag);
    
    seperation = 0;
    sepTime = 0;
  }
  
  Cell(Cell parent){
    stiffness = parent.stiffness;
    pos = new PVector(parent.pos.x,parent.pos.y+radius*sepFactor);
    prevPos = new PVector(parent.pos.x,parent.pos.y+radius*sepFactor);
    startPos = new PVector(parent.pos.x,parent.pos.y+radius*sepFactor);
    parent.createChildLinkAndLinkChild(this);
    pForceFreqX = random(minForceFreq,maxForceFreq);
    pForceMagX = random(minForceMag, maxForceMag);
    pForceFreqY = random(minForceFreq,maxForceFreq);
    pForceMagY = random(minForceMag, maxForceMag);
    
    seperation = 0;
    sepTime = 0;
    
  }
  
  void createChildLinkAndLinkChild(Cell child){
    childLink = new Link(this, child, stiffness);
    child.attachParentLink(childLink);
  }
  
  void attachParentLink(Link _parentLink){
    parentLink = _parentLink;
  }
  
  void runPush(){
    pushSelf();
    if(childLink != null){
      childLink.constrainLen();
    }
    verlet();
  }
  
  void run(){
    if(childLink != null){
      childLink.constrainLen();
    }
    verlet();
  }
  
  void pushSelf(){
    PVector pforceX = new PVector(pForceMagX, 0);
    pforceX.mult(sin(frameCount*pForceFreqX));
    pos.add(pforceX);
    
    PVector pforceY = new PVector(0, pForceMagY);
    pforceY.mult(sin(frameCount*pForceFreqY));
    pos.add(pforceY);
  }
  
  void verlet(){
    PVector currPos = new PVector(pos.x, pos.y);
    pos.x += (pos.x - prevPos.x)*.999;
    pos.y += (pos.y - prevPos.y)*.999;
    prevPos.set(currPos);
  }
  
  void render(){
    
    if(childLink != null){
      childLink.render();
    }
    
    fill(col, 100); //fill(200,100);
    stroke(255);
    pushMatrix();
    translate(pos.x, pos.y);
    //rotate(theta);
    beginShape();
    //ellipse(0,0,radius*2,radius*2);
    endShape();
    popMatrix();
    
  }
  
  void combineTraits(Cell parent1, Cell parent2){
    if(parent1 == null){
      pForceFreqX = parent2.pForceFreqX;
      pForceMagX = parent2.pForceMagX;
      pForceFreqY = parent2.pForceFreqY;
      pForceMagY = parent2.pForceMagY;
      //stiffness = parent2.stiffness;
    }
    else if(parent2 == null){
      pForceFreqX = parent1.pForceFreqX;
      pForceMagX = parent1.pForceMagX;
      pForceFreqY = parent1.pForceFreqY;
      pForceMagY = parent1.pForceMagY;
      //stiffness = parent1.stiffness;
    }
    else{
      pForceFreqX = (parent1.pForceFreqX + parent2.pForceFreqX)/2;
      pForceMagX = (parent1.pForceMagX + parent2.pForceMagX)/2;
      pForceFreqY = (parent1.pForceFreqY + parent2.pForceFreqY)/2;
      pForceMagY = (parent1.pForceMagY + parent2.pForceMagY)/2;
      //stiffness = (parent1.stiffness + parent2.stiffness)/2;
      /*int randomSwap = round(random(0.51, 3.49));
      if(randomSwap == 1){
        pForceFreq = parent1.pForceFreq;
        pForceMag = parent2.pForceMag;
        
        stiffness = parent1.stiffness; //THINK ABOUT THIS
      }
      else if(randomSwap == 2){
        pForceFreq = parent2.pForceFreq;
        pForceMag = parent1.pForceMag;
        
        stiffness = parent2.stiffness; // THINK ABOUT THIS
      }
      else if(randomSwap == 3){
        pForceFreq = (parent1.pForceFreq + parent2.pForceFreq)/2;
        pForceMag = (parent1.pForceMag + parent2.pForceMag)/2;
        stiffness = (parent1.stiffness + parent2.stiffness)/2;
      }
      //pForceFreq = (parent1.pForceFreq + parent2.pForceFreq)/2;
      //pForceMag = (parent1.pForceMag + parent2.pForceMag)/2;*/
    }
    
    int randChance = round(random(1));
    if(randChance == 1){
      //Add some randomness
      pForceFreqX = pForceFreqX + random(-0.1, 0.1)*minForceFreq;
      pForceMagX = pForceMagX + random(-0.1, 0.1)*minForceMag;
      pForceFreqY = pForceFreqY + random(-0.1, 0.1)*minForceFreq;
      pForceMagY = pForceMagY + random(-0.1, 0.1)*minForceMag;
      //stiffness = stiffness + random(-0.1, 0.1)*minStiff;
    }  
  }
  
  float getDisplacement(){
    float displace = PVector.sub(pos, startPos).mag();
    if(displace < 0){
      return displace*-1;
      
    }
    else{
      return displace;
      
    }
  }
  
  float getTimeAvgSep(){
    return seperation/sepTime;
  }
  
  void updateSeperation(Cell other){
    float sep = PVector.sub(this.pos, other.pos).mag();
    sepTime += 1;
    if(sep < 0){
      sep = sep*-1;
      seperation += sep;
    }
    else{
      
      seperation += sep;
    }
  }
  
  void setColor(color _c){
    col = _c;
  }
  
  
  
}
