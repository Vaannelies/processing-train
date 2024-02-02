class RailSystem {
  ArrayList<Rail> rails;

  
  RailSystem() {
    rails = new ArrayList<Rail>();
  }

  void addNewRail() {
    if(rails.size() > maxRailsAmount) {
      rails.remove(0);
    }
    float rotation = 1;
    if(rails.size() > 1) {
       Rail previousRail = rails.get(rails.size() - 1);
       int prX = previousRail.x;
       int prY = previousRail.y;
       /* I now realize that I probably also could have calculated the direction 
        using mouseX and pmouseX etc. but I already wrote this code so 
        I will keep it. */
       rotation = direction(x, y, prX, prY);
    }
    rails.add(new Rail(x, y, rotation));
    delay(20); 
  }

  void update() {
    if(mousePressed) {
      addNewRail();
    }  
  }
  
  float direction(int newX, int newY, int oldX, int oldY) {
    float angle = atan2(newY - oldY, newX - oldX);
    
    return angle + HALF_PI;
  
  }
}
