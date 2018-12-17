width=10;
length=26;
height=15;
thickness=3;
winglength=15;

module wing() {
    difference(){
        union(){
            translate(v=[(length /2),0,0]) cube(size=[winglength,width,thickness] );
            translate(v=[winglength +(length /2),width/2,0]) cylinder(h=thickness,r=width/2);
        }
        //holes
        translate(v=[winglength + (length/2) ,width/2,0]) cylinder(h=thickness,r=width/12);
    }


        

    // top
    translate([0,0,height]) cube([(length /2),width,thickness]);
    translate([(length /2),0,height]) rotate(a=[-90, 90,0]) fillet();
    translate([(length /2), 0, height]) corner();
    
    //vertical
    translate(v=[(length /2),0,0]) cube([thickness,width,height]);    
    translate([(length /2)+ thickness,0,thickness]) rotate(a=[-90, -90,0]) fillet();
 
}

  //  wing(); 
rotate(a=[90, 0, 0]) { 
    wing(); 
    mirror() wing();
}


module fillet () {
difference()  {
    cube(size=[thickness, thickness, width]);
    translate([thickness, thickness, 0]) cylinder(h=width, r=thickness  );
    }
}    

module corner () {
    intersection() {
       translate(v=[0,width,0]) rotate(a=[90,0,0]) cylinder(h=width, r=thickness);
       cube([thickness, width, thickness]);
    }
}
    
    


