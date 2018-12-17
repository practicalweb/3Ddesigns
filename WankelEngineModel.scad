//===========================================
//   Public Wankel Engine Model in OpenSCAD
//   version 1.0
//   by Matt Moses, 2011, mmoses152@gmail.com
//   http://www.thingiverse.com/thing:8069
//
//   This file is public domain.  Use it for any purpose, including commercial
//   applications.  Attribution would be nice, but is not required.  There is
//   no warranty of any kind, including its correctness, usefulness, or safety.
//
//---------------------------------
//   For more info on the geometry of the engine, see these sources:
//
//   http://en.wikipedia.org/wiki/Wankel_engine
//
//   Chapter 3 (page 29 specifically) of the book 
//   The Wankel Rotary Engine: A History
//   by John B. Hege
//
//   and also try an internet search for "wanke enginel gear ratio"
//---------------------------------
//
//   This file uses code appropriated from 
//   Leemon Baird's PublicDomainGearV1.1.scad
//   which can be found here:
//   http://www.thingiverse.com/thing:5505
//
//===========================================


//===========================================
// General stuff
pi = 3.1415926;
$fn = 60; // facet resolution
alpha = 360 * $t; // for animation
//===========================================


//===========================================
// These parameters are common to both gears
//
hole_diameter = 0;
twist = 0;
teeth_to_hide = 0;
pressure_angle = 28;
clearance = 0.3;
backlash = 0.2;
//===========================================


//===========================================
//
//   We set the following parameters to determine the engine:
//
//   R_triangle - radius of rotor
//   R_rotor_gear - pitch radius of rotor gear
//   n_stator_gear - teeth on stator, must be an even number
//   flatness - varies from 0 to very large. 0 = circular rotor, infinite = triangular
//   thickness - rotor thickness
//
//===========================================

R_triangle = 40; // radius of the rotor
R_rotor_gear = 17; // This is the pitch radius of the gear in the rotor
n_stator_gear = 14; // Number of teeth in stator.  Must be even number!!
flatness = 50; // for large flatness $fn will need to be higher
thickness = 8;

//===========================================
//
//   Given the above parameters, we can determine the rest of the rotor and housing geometry
//
//   Eccentricity is the offset distance of the crank (the crank is also known as the "eccentric").  
//   Eccentricity is also the difference in pitch radii of the two gears.
// 
//===========================================

ecc = R_rotor_gear / 3;
echo(str("Eccentricity is ",ecc," mm"));
n_rotor_gear = 3/2 * n_stator_gear; 
mm_per_tooth = 2 * pi * R_rotor_gear / n_rotor_gear;
echo(str("mm_per_tooth is ",mm_per_tooth," mm"));
rotor_gear_outer_radius =  mm_per_tooth * n_rotor_gear / pi / 2 + mm_per_tooth / pi + mm_per_tooth/2;
housing_hole_rad = 0.6 * mm_per_tooth * n_stator_gear / pi / 2;

//===========================================
//   OK, now we can assemble the engine
//
// This part adds the rotor
//
translate([ecc*sin(alpha), -ecc*cos(alpha), thickness/2]){
	rotate([0, 0, alpha/3]){
		wankelRotor (mm_per_tooth,
				n_rotor_gear, thickness,
				hole_diameter, twist, teeth_to_hide, pressure_angle,
				R_triangle, flatness, 
				rotor_gear_outer_radius);
	}
}


// This part adds the housing
//
housing(mm_per_tooth, n_stator_gear, thickness, 
			hole_diameter, twist, teeth_to_hide,   
			pressure_angle, clearance, backlash,
			R_triangle, ecc, housing_hole_rad);

// This adds the eccentric shaft
//
rotate([0, 0, alpha])
eccentric(thickness, ecc, rotor_gear_outer_radius, housing_hole_rad);

//
//===========================================


//===========================================
// This section places individual parts so they can be 
// easily exported as STL.  Comment or uncomment each 
// sub-section as needed.

//// Rotor
//translate([0,0,thickness/2])
//wankelRotor (mm_per_tooth,
//				n_rotor_gear, thickness,
//				hole_diameter, twist, teeth_to_hide, pressure_angle,
//				R_triangle, flatness, 
//				rotor_gear_outer_radius);

//// Housing
//translate([0,0,thickness/2])
//housing(mm_per_tooth, n_stator_gear, thickness, 
//			hole_diameter, twist, teeth_to_hide,   
//			pressure_angle, clearance, backlash,
//			R_triangle, ecc, housing_hole_rad);

//// Eccentric Shaft
//rotate([0,180,0])
//	translate([0,0,-thickness])
//		eccentric(thickness, ecc, rotor_gear_outer_radius, housing_hole_rad);

//===========================================


//===========================================
// Wankel Rotor
//
module wankelRotor (mm_per_tooth,
				n_rotor_gear, thickness,
				hole_diameter, twist, teeth_to_hide, pressure_angle,
				R_triangle, flatness, 
				rotor_gear_outer_radius) {


union() {
	translate([0,0,-thickness/4])
	internal_gear ( mm_per_tooth, n_rotor_gear, thickness/2,  
				hole_diameter, twist, teeth_to_hide,   
				pressure_angle, 0, 0);
	difference() {
		bulgieTriangle(R_triangle, flatness, thickness);
		cylinder(r = 0.99 * rotor_gear_outer_radius, h = 1.1*thickness, center = true);
	}

}
}
//===========================================


//===========================================
// Housing
//
module housing(mm_per_tooth, n_stator_gear, thickness, 
			hole_diameter, twist, teeth_to_hide,   
			pressure_angle, clearance, backlash,
			R_triangle, ecc, housing_hole_rad){

housing_clearance = 1.01;

echo(str("housing length is ",2.6*R_triangle," mm"));

difference() {
	union() {
		difference() {
		translate([0, 0, thickness/4])
			cube([2*R_triangle, 2.6*R_triangle, 3/2*thickness], center = true);
		epitrochoidLinear(housing_clearance*2/3*R_triangle,
					 housing_clearance*1/3*R_triangle, 
					ecc, 40, 40, 3/2*thickness, 0);
		}
		gear ( mm_per_tooth, n_stator_gear, thickness,  
			hole_diameter, twist, teeth_to_hide,   
			pressure_angle, clearance, backlash);
	}
	cylinder(r = housing_hole_rad, h = 4*thickness, center = true);
}
}
//===========================================


//===========================================
// Eccentric
//
module eccentric(thickness, ecc, rotor_gear_outer_radius, housing_hole_rad){
union(){
translate([0,0,-thickness/2])
cylinder(r = 0.98 * housing_hole_rad, h = 2*thickness, center = true);
translate([0, -ecc, 3/4*thickness])
	cylinder(r = 0.98 * 0.99 * rotor_gear_outer_radius, h = thickness/2, center = true);
}
}
//===========================================


//===========================================
// Bulgie Triangle Module
// 
module bulgieTriangle(bt_R, bt_flatness, bt_thickness) {
r_bigCirc = sqrt(bt_R*bt_R + bt_R*bt_flatness + bt_flatness*bt_flatness);
rotate([0, 0, 30])
intersection() {
	translate([bt_flatness, 0, 0])
		cylinder(r = r_bigCirc, h = bt_thickness, center = true);
	translate([- 0.5 * bt_flatness, sin(60) * bt_flatness, 0])
		cylinder(r = r_bigCirc, h = bt_thickness, center = true);
	translate([- 0.5 * bt_flatness, -sin(60) * bt_flatness, 0])
		cylinder(r = r_bigCirc, h = bt_thickness, center = true);
}
}
//===========================================


//===========================================
// Epitrochoid Wedge, Linear Extrude
//
module epitrochoidLinear(R, r, d, n, p, thickness, twist) {
	dth = 360/n;
	linear_extrude(height = thickness, convexity = 10, twist = twist) {
	union() {
	for ( i = [0:p-1] ) {
			polygon(points = [[0, 0], 
			[(R+r)*cos(dth*i) - d*cos((R+r)/r*dth*i), (R+r)*sin(dth*i) - d*sin((R+r)/r*dth*i)], 
			[(R+r)*cos(dth*(i+1)) - d*cos((R+r)/r*dth*(i+1)), (R+r)*sin(dth*(i+1)) - d*sin((R+r)/r*dth*(i+1))]], 
			paths = [[0, 1, 2]], convexity = 10); 
	}
	}
	}
}
//===========================================


//===========================================
// This is just a quick edit of Leemon's gear() module to make an internal gear.  -MM
//
module internal_gear (
	mm_per_tooth    = 3,    //this is the "circular pitch", the circumference of the pitch circle divided by the number of teeth
	number_of_teeth = 11,   //total number of teeth around the entire perimeter
	thickness       = 6,    //thickness of gear in mm
	hole_diameter   = 3,    //diameter of the hole in the center, in mm
	twist           = 0,    //teeth rotate this many degrees from bottom of gear to top.  360 makes the gear a screw with each thread going around once
	teeth_to_hide   = 0,    //number of teeth to delete to make this only a fraction of a circle
	pressure_angle  = 28,   //Controls how straight or bulged the tooth sides are. In degrees.
	clearance       = 0.0,  //gap between top of a tooth on one gear and bottom of valley on a meshing gear (in millimeters)
	backlash        = 0.0   //gap between two meshing teeth, in the direction along the circumference of the pitch circle
) {
	assign(pi = 3.1415926)
	assign(p  = mm_per_tooth * number_of_teeth / pi / 2)  //radius of pitch circle
	assign(c  = p + mm_per_tooth / pi - clearance)        //radius of outer circle
	assign(b  = p*cos(pressure_angle))                    //radius of base circle
	assign(r  = p-(c-p)-clearance)                        //radius of root circle
	assign(t  = mm_per_tooth/2-backlash/2)                //tooth thickness at pitch circle
	assign(k  = -iang(b, p) - t/2/p/pi*180) {             //angle to where involute meets base circle on each side of tooth
		difference() {
			for (i = [0:number_of_teeth-teeth_to_hide-1] )
				rotate([0,0,i*360/number_of_teeth])
					linear_extrude(height = thickness, center = true, convexity = 10, twist = twist)
						polygon(
							points=[
								polar(c + mm_per_tooth/2, -181/number_of_teeth),
								polar(r, -181/number_of_teeth),
								polar(r, r<b ? k : -180/number_of_teeth),
								q7(0/5,r,b,c,k, 1),q7(1/5,r,b,c,k, 1),q7(2/5,r,b,c,k, 1),q7(3/5,r,b,c,k, 1),q7(4/5,r,b,c,k, 1),q7(5/5,r,b,c,k, 1),
								q7(5/5,r,b,c,k,-1),q7(4/5,r,b,c,k,-1),q7(3/5,r,b,c,k,-1),q7(2/5,r,b,c,k,-1),q7(1/5,r,b,c,k,-1),q7(0/5,r,b,c,k,-1),
								polar(r, r<b ? -k : 180/number_of_teeth),
								polar(r, 181/number_of_teeth),
								polar(c + mm_per_tooth/2, 181/number_of_teeth)
							],
							paths=[[17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0]]
						);
			cylinder(h=2*thickness+1, r=hole_diameter/2, center=true, $fn=20);
		}
	}
};	
//===========================================


//===========================================
//   This gear() module is from 
//   Leemon Baird's PublicDomainGearV1.1.scad
//   which can be found here:
//   http://www.thingiverse.com/thing:5505
//An involute spur gear, with reasonable defaults for all the parameters.
//Normally, you should just choose the first 4 parameters, and let the rest be default values.
//Meshing gears must match in mm_per_tooth, pressure_angle, and twist,
//and be separated by the sum of their pitch radii, which can be found with pitch_radius().
module gear (
	mm_per_tooth    = 3,    //this is the "circular pitch", the circumference of the pitch circle divided by the number of teeth
	number_of_teeth = 11,   //total number of teeth around the entire perimeter
	thickness       = 6,    //thickness of gear in mm
	hole_diameter   = 3,    //diameter of the hole in the center, in mm
	twist           = 0,    //teeth rotate this many degrees from bottom of gear to top.  360 makes the gear a screw with each thread going around once
	teeth_to_hide   = 0,    //number of teeth to delete to make this only a fraction of a circle
	pressure_angle  = 28,   //Controls how straight or bulged the tooth sides are. In degrees.
	clearance       = 0.0,  //gap between top of a tooth on one gear and bottom of valley on a meshing gear (in millimeters)
	backlash        = 0.0   //gap between two meshing teeth, in the direction along the circumference of the pitch circle
) {
	assign(pi = 3.1415926)
	assign(p  = mm_per_tooth * number_of_teeth / pi / 2)  //radius of pitch circle
	assign(c  = p + mm_per_tooth / pi - clearance)        //radius of outer circle
	assign(b  = p*cos(pressure_angle))                    //radius of base circle
	assign(r  = p-(c-p)-clearance)                        //radius of root circle
	assign(t  = mm_per_tooth/2-backlash/2)                //tooth thickness at pitch circle
	assign(k  = -iang(b, p) - t/2/p/pi*180) {             //angle to where involute meets base circle on each side of tooth
		difference() {
			for (i = [0:number_of_teeth-teeth_to_hide-1] )
				rotate([0,0,i*360/number_of_teeth])
					linear_extrude(height = thickness, center = true, convexity = 10, twist = twist)
						polygon(
							points=[
								[0, -hole_diameter/10],
								polar(r, -181/number_of_teeth),
								polar(r, r<b ? k : -180/number_of_teeth),
								q7(0/5,r,b,c,k, 1),q7(1/5,r,b,c,k, 1),q7(2/5,r,b,c,k, 1),q7(3/5,r,b,c,k, 1),q7(4/5,r,b,c,k, 1),q7(5/5,r,b,c,k, 1),
								q7(5/5,r,b,c,k,-1),q7(4/5,r,b,c,k,-1),q7(3/5,r,b,c,k,-1),q7(2/5,r,b,c,k,-1),q7(1/5,r,b,c,k,-1),q7(0/5,r,b,c,k,-1),
								polar(r, r<b ? -k : 180/number_of_teeth),
								polar(r, 181/number_of_teeth)
							],
 							paths=[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]]
						);
			cylinder(h=2*thickness+1, r=hole_diameter/2, center=true, $fn=20);
		}
	}
};	
//these 4 functions are used by gear
function polar(r,theta)   = r*[sin(theta), cos(theta)];                            //convert polar to cartesian coordinates
function iang(r1,r2)      = sqrt((r2/r1)*(r2/r1) - 1)/3.1415926*180 - acos(r1/r2); //unwind a string this many degrees to go from radius r1 to radius r2
function q7(f,r,b,r2,t,s) = q6(b,s,t,(1-f)*max(b,r)+f*r2);                         //radius a fraction f up the curved side of the tooth 
function q6(b,s,t,d)      = polar(d,s*(iang(b,d)+t));                              //point at radius d on the involute curve
//===========================================
