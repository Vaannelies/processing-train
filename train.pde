/* 
  THE TRAIN IMAGES ARE NOT MINE.
  I found them on reddit and I cropped them so I could use them.
  
  Credits to Vuurkip on Reddit:
  https://www.reddit.com/r/thenetherlands/comments/o0gsae/ns_intercity_trains_remade_the_old_models_and/

*/

RailSystem railSystem;

PImage train1Image;
PImage train2Image;

int x = 0;
int y = 0;

int subjectX = 0;
int subjectY = 0;
int subjectSpeedX = 0;
int subjectSpeedY = 0;
int subjectWidth = 30;
int subjectHeight = 30;

int maxRailsAmount = 200;
int railsAmount = 0;
int railHeight = 30;
int railWidth = 30;

int trainWidth = 60;
int trainHeight = 30;

ArrayList<String> cityNames;
String cityNameFrom;
String cityNameTo;
boolean cityNameFromIsVisible = false;
boolean cityNameToIsVisible = false;

boolean trainIsActive = false;

PGraphics railGraphic;
PGraphics trainGraphic;
PGraphics trainCarGraphic;

int trainRailsLocationIndex = 0;


boolean mouseIsDown = false;
boolean rideActive = false;


void setup() {
  size(1000, 500);
  
  /* I added the names of a few train stations I've visited. */
  cityNames = new ArrayList<String>();
  cityNames.add("Rotterdam Centraal");
  cityNames.add("Amsterdam Centraal");
  cityNames.add("Amsterdam Zuid");
  cityNames.add("Utrecht Centraal");
  cityNames.add("Schiphol Airport");
  cityNames.add("Blaak");
  cityNames.add("Den Haag HS");
  cityNames.add("Den Haag Laan van NOI");
  cityNames.add("Leiden Centraal");
  cityNames.add("Schiedam Centrum");
  cityNames.add("Hoofddorp");
  cityNames.add("Sassenheim");
  cityNames.add("Schiedam Centrum");
  cityNames.add("Nieuw-Vennep");
  cityNames.add("Rotterdam Alexander");
  cityNames.add("Breukelen");

  
  railSystem = new RailSystem();
  train1Image = loadImage("train1.png");
  train2Image = loadImage("train2.png");
  
  railGraphic = createGraphics(railWidth, railHeight);
  railGraphic.beginDraw();
  railGraphic.push();
  railGraphic.colorMode(RGB);
  rectMode(CENTER);
  
  railGraphic.fill(80);
  railGraphic.rect(railWidth*0.125,0, railWidth/8 - 1, railHeight-1);
  railGraphic.rect(railWidth*0.800,0, railWidth/8 - 1, railHeight-1);
  
  
  railGraphic.fill(155,155,120);
  railGraphic.rect(0,railHeight*0.066, railWidth - 1, railHeight/6);
  railGraphic.rect(0,railHeight*0.400, railWidth - 1, railHeight/6);
  railGraphic.rect(0,railHeight*0.750, railWidth - 1, railHeight/6);
  railGraphic.pop();
  railGraphic.endDraw();
  
  
  /* I replaced the train graphics with images I found on the web. */
  
  //trainGraphic = createGraphics(trainWidth, trainHeight);
  //trainGraphic.beginDraw();
  //trainGraphic.fill(255,0,0);
  //trainGraphic.rect(0,0,trainWidth, trainHeight);
  //trainGraphic.endDraw();
  
  //trainCarGraphic = createGraphics(trainWidth, trainHeight);
  //trainCarGraphic.beginDraw();
  //trainCarGraphic.fill(255,233,0);
  //trainCarGraphic.rect(0,0,trainWidth, trainHeight);
  //trainCarGraphic.endDraw();
}

void draw() {
  x = mouseX;
  y = mouseY;
  
  background(100, 185, 100);
  
  textSize(16);
  text("Drag your mouse to create a new track for NS!", 24,48);
  text("Release mouse to start the train :)", 24,72);
  text("Press R key to restart train on the same track", 24,96);


  
  railSystem.update();
  imageMode(CENTER);
  for (int i = 0; i < railSystem.rails.size(); i++) {

    Rail rail = railSystem.rails.get(i);
    int railX = rail.x;
    int railY = rail.y;

    pushMatrix();
    translate(railX, railY);
    rotate(rail.rotation); 
    image(railGraphic, railWidth/2, railHeight/2);

    popMatrix();  
    noStroke();
    
    /* "Spawn" location names */
    if(i == 0 && cityNameFromIsVisible) {
      rect(railX, railY - railHeight/1.5, 1, 70);
      text(cityNameFrom, railX + 16, railY - railHeight*2);
    }
    
    if(i == railSystem.rails.size() - 1 && cityNameToIsVisible) {
      rect(railX, railY - railHeight/1.5, 1, 70);
      text(cityNameTo, railX + 16, railY - railHeight*2);
    }
  }  
  
  if(trainIsActive) {
    trainDrive();
  }
}

void keyPressed() {
  if((key == 'r') && railSystem.rails.size() > 0) {
    this.trainIsActive = true;
    this.trainRailsLocationIndex = 0;
  }
}

void mousePressed() {
  if(!mouseIsDown) {
    /* handle generating new random location names and reset the tracks */
    cityNameToIsVisible = false;
    resetTracks();
    ArrayList<String> cityNamesCopy = new ArrayList<String>(cityNames);
    int indexFrom = round(random(1, cityNamesCopy.size()-1));
    cityNameFrom = cityNamesCopy.get(indexFrom);
    cityNamesCopy.remove(indexFrom);
    int indexTo = round(random(1, cityNamesCopy.size()-1));
    cityNameTo = cityNamesCopy.get(indexTo);
  }
  mouseIsDown = true;
  cityNameFromIsVisible = true;
}

void mouseReleased() {
  trainIsActive = true;
  mouseIsDown = false;
  cityNameToIsVisible = true;
}

void trainDrive() {

  /* the last train car should be the bottom layer, hence this one is created first */
  if(trainRailsLocationIndex > 4) {
    pushMatrix();
    translate(railSystem.rails.get(trainRailsLocationIndex - 4).x, railSystem.rails.get(trainRailsLocationIndex - 4).y);
    rotate(railSystem.rails.get(trainRailsLocationIndex - 4).rotation - PI/2); 
    image(train2Image, railWidth/2, railHeight/2, trainWidth, trainHeight);
    //image(trainCarGraphic, railWidth/2, railHeight/2);
    popMatrix();  
  }
  
  /* then the middle train car */
  if(trainRailsLocationIndex > 2) {
    pushMatrix();
    translate(railSystem.rails.get(trainRailsLocationIndex - 2).x, railSystem.rails.get(trainRailsLocationIndex - 2).y);
    rotate(railSystem.rails.get(trainRailsLocationIndex - 2).rotation - PI/2); 
    image(train2Image, railWidth/2, railHeight/2, trainWidth, trainHeight);
    //image(trainCarGraphic, railWidth/2, railHeight/2);
    popMatrix();  
  }
  
  /* and finally, the train */
  pushMatrix();
  translate(railSystem.rails.get(trainRailsLocationIndex).x, railSystem.rails.get(trainRailsLocationIndex).y);
  rotate(railSystem.rails.get(trainRailsLocationIndex).rotation - PI/2); 
  image(train1Image, railWidth/2, railHeight/2, trainWidth, trainHeight);
  //image(trainGraphic, railWidth/2, railHeight/2);
  popMatrix();  
  

  delay(50);
  
  
  if(trainRailsLocationIndex < railSystem.rails.size() - 1) {
    trainRailsLocationIndex++;
  } else {
    trainIsActive = false;
  }
}

void resetTracks() {
  trainIsActive = false;
  trainRailsLocationIndex = 0;
  railSystem.rails = new ArrayList<Rail>();
}
