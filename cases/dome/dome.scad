/*
 Domed case for pheremes alert tool
 Uses 7 LEDs from WS2811 string
 (eg. https://www.amazon.com/gp/product/B01AU6UG70
  uses a 12mm hole in a 1.5mm thick panel)
 */ 

// https://github.com/daprice/PiHoles
use <PiHoles/PiHoles.scad>
// https://github.com/diara628/MCAD
//use <MCAD/shapes.scad>

// which kind of Pi?
pi_type = "Zero";

// padding around pi
padding = 5;
// base diameter
width = 2 * ( piBoardDim(pi_type)[1] + padding);
// base height
height = piBoardDim(pi_type)[0] + (2 * padding);
// wall on dome
dome_thick = 1;
// 2mm thick wall on base / LED plate
base_thick = 2;
// LED hole
led_hole =  12;

post_height = 5;
cable_diameter = 4.5;

/****************************************/

/* exterior dimentions
  h is straight side height
  r is radius
  t is wall thickness
*/
module domed_box(r, h, bt, dt){
    // need to clear half an LED and the board, plus the board padding
    extra_back_depth = led_hole/2 
        + post_height
        + piBoardDim(pi_type)[2]
        + padding;

    difference(){
        union(){
            // half shell
            rotate_extrude(angle=180){
                _box(r,h,bt,dt);
                }
            rotate([90,0,0])
                linear_extrude(extra_back_depth){
                    union(){
                    _box(r,h,bt,dt);
                    mirror([1,0,0]) _box(r,h,bt,dt);
                    }
            }
        }
        // holes
        offset = ((r-led_hole)/2) + (led_hole/2);
        translate([0,0,h-bt]){
          cylinder(r=led_hole/2, h=bt);
        }
        translate([offset,0,h-bt]){
          cylinder(r=led_hole/2, h=bt);
        }
        translate([-offset,0,h-bt]){
          cylinder(r=led_hole/2, h=bt);
        }
        translate([0,offset,h-bt]){
          cylinder(r=led_hole/2, h=bt);
        }
    }
    // back
    difference(){
        // back panel
        translate([0,-extra_back_depth,0]){
            rotate([90,0,0]){
                linear_extrude(bt){
                    square([r,h]);
                    translate([-r,0]){
                        square([r,h]);
                    }
                    translate([0,h]){
                        circle(r);
                    }
                }
            }
        }
        // wire hole
        translate([(r/2),-extra_back_depth,0]){
            rotate([90,0,0]){
                linear_extrude(bt){
                    union(){
                        translate([0,cable_diameter/2,0]) circle(cable_diameter/2);
                        square(cable_diameter, center=true);
                    }
                }
        }
    }
    }
    mirror([1,0,0])
      translate([0, -extra_back_depth, 0])
        rotate([0,-90,-90])
          piPosts(pi_type, post_height);
} 

module _box(r,h,bt,dt){
    _base(r,h,bt);
    _dome(r,h,dt);
}
module _base(r,h,t){
    difference(){
        square([r,h]);
        translate([-t, -t]) square([r,h]);
    }
}
module _dome(r,h,t){
    translate([0,h]){
        intersection(){
            square(r, center=false);
            difference(){
                circle(r);
                circle(r-t);
            }
        }
    }
}

domed_box(width/2, height, base_thick, dome_thick, $fn=100);