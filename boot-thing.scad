//6.5mm hole

module thingy() {
 
    //string holder
cylinder(r=5, h=2); 
 //center pin      
    translate([0,0,2]) cylinder(r=3.5, h=8);

 //stop
translate([0,0,2]) cylinder(r=0, r2=5, h=6);

// point (blunted)
translate([0,0,10]) {
    difference() {
    cylinder(r1=4, r2=0, h=7);
        translate([0,0,8]) cube([8,8,8], center=true);
    }
}
}

module slot(){
    translate([0,0,11]) cube([20, 1, 6], center=true);
}

difference(){ 
    thingy();
    slot(); 
}


