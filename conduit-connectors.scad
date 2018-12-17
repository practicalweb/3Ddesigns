$fn=30;
piperadius=30;
wall=3;
length=100;

// connector
rotate([0,30,0]) tube();
rotate([0,-30,0]) tube();
rotate([90,0,0]) tube();

rotate([90,0,0])
cylinder(center=true, r= piperadius+ wall, h=2 * (piperadius + wall));


//bracket
translate([0, 4* piperadius,0]){
   translate([0, 0, (sin(30) * (piperadius + wall))]) rotate([0,30,0]) tube();
    translate([-(piperadius), -(piperadius + wall), 0]) 
         cube([length + piperadius*2, (piperadius + wall) * 2, piperadius]);
    translate([length, 0,(sin(30) * (piperadius + wall)) -0.4]) rotate([0,-30,0]) tube();
}
module tube(){
difference(){
cylinder(r= piperadius+ wall, h=3 * piperadius);
translate([0, 0, 1.5 * piperadius]) cylinder(r=piperadius, h=2 * piperadius);
}

}