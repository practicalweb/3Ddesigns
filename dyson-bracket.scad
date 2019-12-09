// 35mm measured - make the hole 1mm bigger so it isn't too tight
diameter=38;
radius=(diameter/2);
// 37 mm measured
tall=42;
// 2 x 2 mm measured
notch = 3;

// direct drive connector
// 27mm wide x 15mm deep
ddwidth=17;
dddepth=15;
//13mm diam measured 
ddholeradius=7.5;
ddholefromtop=20;
// wall thickness
thick=2;

// how far offset from all
extension=35;
//how thick bracket should be
extensionwidth=30;
  versionlabel = "v4";
  screwholeradius=1.5;
  
module outline() {
maincylinder();
    
extension();

translate (v=[0 , radius, 0])  cylinder(tall+thick, notch + thick,notch + thick);
translate (v=[0 ,-radius , 0])  cylinder(tall+thick, notch + thick,notch + thick);;
}


module maincylinder() {
    cylinder(h=(tall + thick),r=(radius + thick));
}
module extension(){
    
       difference(){ 
      translate (v=[0, -(extensionwidth/2), 0]) cube(size=[extension+radius, extensionwidth , tall + thick]);
    translate(v=[2*thick,0, (tall+ thick  - dddepth)]) rotate(0, 0, 90) cylinder(dddepth, 25 , 25 );

   }
   
   // add back side walls
   translate (v=[0, -(extensionwidth/2), 0]) cube(size=[extension+radius, thick , tall + thick]);
   translate (v=[0, (extensionwidth/2), 0]) cube(size=[extension+radius, thick , tall + thick]);
   

}

module space(){
// central hole
    translate(v=[-0, -0, thick]) cylinder(h=tall,r=radius);
// direct drive hole
  //  translate(v=[ddwidth - thick, -2* thick -(ddwidth/2), (tall+ thick  - dddepth)]) cube(size=[ddwidth + thick, ddwidth + 4* thick, dddepth]);

    // connector hole
    translate (v=[-(diameter/2 + thick), 0, tall +thick - ddholefromtop])  rotate(a=[0, 90, 0])   cylinder(h=thick * 3,r=ddholeradius);
    //button notch
        translate (v=[-(diameter/2 + thick), 0, tall +thick ])
      rotate(a=[0, 90, 0])  
        cylinder(h=thick * 3,r=9);
    //bottom screw hole access
        translate (v=[-(diameter/2 + thick), 0, thick * 2 + screwholeradius ])
      rotate(a=[0, 90, 0])  
        cylinder(h=thick * 3,r=4);
    
    // screw hole
    
    translate (v=[-(diameter - thick), 0, tall +thick - ddholefromtop])
      rotate(a=[0, 90, 0])  
        cylinder(h=500,r=screwholeradius);
    translate (v=[-(diameter - thick), 0, screwholeradius  +  2* thick])
      rotate(a=[0, 90, 0])  
        cylinder(h=500,r=screwholeradius);
   


    //slot
    translate(v=[-(notch/2), -(radius + notch) , thick]) 
    cube(size=[notch, (diameter + 2 * notch), tall]);
     // version label
   font = "Liberation Sans";

translate ([diameter+10,-5,tall ])  {
   linear_extrude(height = 2) {
      rotate (90, 0 , 0) text(versionlabel, font = font, size = 10);
     }
 }

}
difference(){ 
  outline();
    space();
}
