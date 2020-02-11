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

// 70mm cube base
base_cube = 70;
// 2mm thick wall
wall_thick = 2;
// 12mm corner radius
corner_radius = 12;
// LED hole
led_hole =  12;
led_panel_thick = 1.5;

/****************************************/


  difference(
    roundedBox(
      base_cube+(wall_thick*2),
      base_cube+(wall_thick*2),
      base_cube+led_panel_thick,
      corner_radius
    ),
    roundedBox(base_cube, base_cube, base_cube, corner_radius-wall_thick)
  );