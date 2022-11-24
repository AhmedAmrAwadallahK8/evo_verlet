class Organism{
  ArrayList<Cell> cells;
  Cell head, tail;
  float score;
  float distTraveled;
  float food_consumed;
  float displacement;
  float seperation;
  //int size;
  color col;
  
  static final int minSize = 2;
  static final int maxSize = 20;
  
  
  Organism(float x, float y){
    col = color(random(255), random(255), random(255));
    cells = new ArrayList<Cell>();
    
    /* Possible color bug where the color is null*/
    head = new Cell(x, y);
    head.setColor(col);
    tail = new Cell(head);
    tail.setColor(col);
    
    cells.add(head);
    cells.add(tail);
    
    int extendCount = int(random(18));
    extendNTimes(extendCount);
    
  }
  
  Organism(float x, float y, boolean isChild){
    col = color(random(255), random(255), random(255));
    cells = new ArrayList<Cell>();
    head = new Cell(x, y);
    tail = new Cell(head);
    cells.add(head);
    cells.add(tail);
    if(isChild){

    }
    else{
      int extendCount = int(random(18));
      extendNTimes(extendCount);
    }
    setColors();
  }
  
  void setColors(){
    for(Cell c: cells){
      c.setColor(col);
    }
  }
  
  void run() {
    int counter = 0;
    //for(Cell c: cells){
    //  if(counter % 4 == 0){
    //    c.pushSelf();
    //  }
    //  counter++;
    //}
    
    head.pushSelf();
    tail.pushSelf();
    for(Cell c: cells){
      c.run();
    }
    
  }
  
  void render(){
    for(Cell c: cells){
      c.render();
    }
  }
  
  void pushHead(){
    head.pushSelf();
  }
  
  void calcSeperation(){
    float tempSeperation = 0;
    for(Cell c: cells){
      tempSeperation += c.getTimeAvgSep();
    }
    tempSeperation = tempSeperation/cells.size();
    seperation = tempSeperation;
  }
  
  void updateSeperations(){
    //for(Cell c1: cells){
    //  for(Cell c2: cells){
    //    c1.updateSeperation(c2);
    //  }
    //}
    for(Cell c1: cells){
      Cell parent;
      Cell child;
      if(c1.parentLink != null){
        parent = c1.parentLink.parent;
      }
      else{
        parent = null;
      }
      if(c1.childLink != null){
        child = c1.childLink.child;
      }
      else{
        child = null;
      }
      
      if((parent == null) && (child == null)){
        
      }
      else if(parent == null){
        c1.updateSeperation(child);
      }
      else if(child == null){
        c1.updateSeperation(parent);
      }
      else{
        c1.updateSeperation(parent);
        c1.updateSeperation(child);
      }
    }
  }
  
  /*Organism produceRandomVariant(){

  }
  
  Organism copyOrganism(){

  }*/
  
  Organism reproduceWith(Organism partner){
    //Organism child = new Organism(random(width), height/2, true); //MAKE SEP CONSTRUC
    Organism child = new Organism(width/2, height/2, false);
    int lengthChance = round(random(1));
    if(lengthChance == 0){
      int meanSize = (cells.size() + partner.cells.size())/2;
      int meanSizeChance = round(random(1));
      if(meanSizeChance == 0){
        child.extendNTimes(meanSize-2);
      }
      else{
        child.extendNTimes(meanSize-2);
      }
      
    }
    else{
      //Extend size of child to one of the parents size
      int randChance = round(random(1));
      if(randChance == 1){
        child.extendNTimes(partner.cells.size()-2);
      }
      else{
        child.extendNTimes(cells.size()-2);
      }

    }
    
    for(int i = 0; i < child.cells.size(); i++){
      if((i >= cells.size()) && (i >= partner.cells.size())){
        
      }
      else if(i >= cells.size()){
        child.cells.get(i).combineTraits(null, partner.cells.get(i));
      }
      else if(i >= partner.cells.size()){
        child.cells.get(i).combineTraits(cells.get(i), null);
      }
      else{
        child.cells.get(i).combineTraits(cells.get(i), partner.cells.get(i));
      }    
    }
    
    int chanceToExtend = round(random(100));
    //chanceToExtend = 0; //TEMP
    if(cells.size() < 20){
      if(chanceToExtend <= 2){
        child.extend();
        return child;
      }
    }
    
    int chanceToShrink = round(random(100));
    //chanceToShrink = 0; //TEMP
    if(cells.size() > 3){
      if(chanceToShrink <=2){
        child.shrink();
        return child;
        
      }
      
    }
    return child;
  }
  
  float getScore(){
    return score;
  }
  
  void calcScore(){
    calcSeperation();
    calcDisplacement();
    score = displacement - seperation*500 + cells.size()*100;
  }
  
  void calcDisplacement(){    
    float tempDisplacement = 0;
    for(Cell c: cells){
      tempDisplacement += c.getDisplacement();
    }
    tempDisplacement = tempDisplacement/cells.size();
    displacement = tempDisplacement;
  }
  
  void calcDist(){
   
  }
  
  void extend(){
    Cell newTail = new Cell(tail);
    newTail.setColor(col);
    cells.add(newTail);
    tail = newTail;
    
  }
  
  void shrink(){
    Link tailLink = tail.parentLink;
    Cell newTail = tailLink.parent;
    cells.remove(tail);
    tail = newTail;
    tail.childLink = null;
  }
  
  void extendNTimes(int n){
    for(int i = 0; i < n; i++){
      extend();
    }
  }
  
  /*int getComponentCount(){
   
  }*/
  
  
}
