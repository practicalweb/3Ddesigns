//include</usr/share/openscad/libraries/MCAD/gears.scad>
//demo_3d_gears();
include</usr/share/openscad/libraries/MCAD/lego_compatibility.scad>
block(2,1,1/3,axle_hole=false,circular_hole=true,reinforcement=true,hollow_knob=true,flat_top=true);

translate([50,-10,0])
        block(1,2,1/3,axle_hole=false,circular_hole=true,reinforcement=false,hollow_knob=true,flat_top=true);

translate([10,0,0])
        block(2,2,1/3,axle_hole=false,circular_hole=true,reinforcement=true,hollow_knob=true,flat_top=true);
translate([30,0,0])
        block(2,2,1/3,axle_hole=false,circular_hole=true,reinforcement=true,hollow_knob=false,flat_top=false);
translate([50,0,0])
        block(2,2,1/3,axle_hole=false,circular_hole=true,reinforcement=true,hollow_knob=true,flat_top=false);
translate([0,20,0])
        block(3,2,2/3,axle_hole=false,circular_hole=true,reinforcement=true,hollow_knob=true,flat_top=false);
translate([20,20,0])
        block(3,2,1,axle_hole=true,circular_hole=false,reinforcement=true,hollow_knob=false,flat_top=false);
translate([40,20,0])
        block(3,2,1/3,axle_hole=false,circular_hole=false,reinforcement=false,hollow_knob=false,flat_top=false);
translate([0,-10,0])
        block(1,5,1/3,axle_hole=true,circular_hole=false,reinforcement=true,hollow_knob=false,flat_top=false);
translate([0,-20,0])
        block(1,5,1/3,axle_hole=true,circular_hole=false,reinforcement=true,hollow_knob=true,flat_top=false);
translate([0,-30,0])
        block(1,5,1/3,axle_hole=true,circular_hole=false,reinforcement=true,hollow_knob=true,flat_top=true);
