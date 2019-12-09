

thick = 3;
module panel() { 
  
cube(size=[105, 90, thick], center=true); 

}

module usbhole() {
    cylinder(h = thick, r1 = 15.5,  r2 = 15.5, center = true);
}

module switchhole() {
    radius=10.4;
    union() {
        cylinder(h = thick, r1 = radius,  r2 = radius, center = true);
        cube(size=[3, radius*2 + 3, thick], center=true);
     }
}

module screwhole() {
    cylinder(h = thick, r1 = 2,  r2 = 2, center = true);
}
    
difference() {
    screwholeinset = 5;
    panel();
    translate([20,0,0]) usbhole();
    translate([-25,20,0]) switchhole();
    translate([-25,-20,0]) switchhole();
    translate([(105/2) -screwholeinset ,(90 / 2) -screwholeinset,0]) screwhole();
    translate([(105/2) -screwholeinset , - (90 / 2) + screwholeinset,0]) screwhole();
    translate([ -(105/2) +screwholeinset ,(90 / 2) -screwholeinset,0]) screwhole();
    translate([ -(105/2) +screwholeinset ,- (90 / 2) + screwholeinset,0]) screwhole();
}


