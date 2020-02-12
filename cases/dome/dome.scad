/*
 Domed case for pheremes alert tool
 Uses 7 LEDs from WS2811 string
 (eg. https://www.amazon.com/gp/product/B01AU6UG70
  uses a 12mm hole in a 1.5mm thick panel)
 */ 

// https://github.com/daprice/PiHoles
use <PiHoles/PiHoles.scad>
// https://github.com/diara628/MCAD
use <MCAD/shapes.scad>

// padding around pi zero
padding = 5;
// base diameter
width = 2 * ( piBoardDim("Zero")[1] + padding);
// base height
height = piBoardDim("Zero")[0] + (2 * padding);
// 1.5mm thick wall
wall_thick = 1.5;
// LED hole
led_hole =  12;

post_height = 5;
cable_diameter = 3;

/****************************************/

/* exterior dimentions
  h is straight side height
  r is radius
  t is wall thickness
*/
module domed_box(r, h, t){
    // need to clear half an LED and the board, plus the board padding
    extra_back_depth = led_hole/2 
        + post_height
        + piBoardDim("Zero")[2]
        + padding;

    difference(){
        union(){
            // half shell
            rotate_extrude(angle=180){
                _box(r,h,t);
                }
            rotate([90,0,0])
                linear_extrude(extra_back_depth){
                    union(){
                    _box(r,h,t);
                    mirror([1,0,0]) _box(r,h,t);
                    }
            }
        }
        // holes
        offset = ((r-led_hole)/2) + (led_hole/2);
        translate([0,0,h-t]){
          cylinder(r=led_hole/2, h=t);
        }
        translate([offset,0,h-t]){
          cylinder(r=led_hole/2, h=t);
        }
        translate([-offset,0,h-t]){
          cylinder(r=led_hole/2, h=t);
        }
        translate([0,offset,h-t]){
          cylinder(r=led_hole/2, h=t);
        }
    }
    // back
    difference(){
        // back panel
        translate([0,-extra_back_depth,0]){
            rotate([90,0,0]){
                linear_extrude(t){
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
                linear_extrude(t){
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
          piPosts("Zero", post_height);
} 

module _box(r,h,t){
    _base(r,h,t);
    _dome(r,h,t);
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

domed_box(width/2, height, wall_thick, $fn=100);