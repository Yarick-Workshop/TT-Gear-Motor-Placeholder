/*
Drawings sources:
    - TT Gearbox Motor: https://grabcad.com/library/dc-3v-6v-tt-motor-1
    - 130 motor: https://www.makerstore.com.au/product/elec-130motor-dc6v/
*/

$fn = 64;// TODO, play with it, investigate the artefacts!

/* [Mounting Holes] */
mountingHole_Diameter = 2.8;
mountingHole_Couple_Offset = 31.1;
mountingHole_Couple_Distance = 17.5;
mountingHole_Single_Offset = 2.4;

/* [Gear Box] */
gearBox_Length = 37;//??? measure
gearBox_Height = 22.44;
gearBox_Width = 18.7;
gearBox_Corner_Radius = 3;

/* [Motor] */
motorBase_Length = 10;//TODO
motorBase_Thickness = 17;//TODO
motor_Offset = 65;//TODO

/* [Additional Mounting Hole Box] */
// ??? measure
mountingHoleBox_Length = 5.0;
mountingHoleBox_Height = 2.0;
mountingHoleBox_Width = 5;
mountingHoleBox_Corner_Radius = 1;

/* [Wheel Shaft] */
wheelShaft_Color = "white";//TODO
wheelShaft_Length = 34;//??? measure
wheelShaft_Diameter = 5.5;
wheelShaft_Offset = 11.0;
wheelShaft_DD_Length = 6;// TODO
wheelShaft_DD_Thickness = 3;// TODO

module rounded_square_extruded(
    sx,
    sy,
    h,
    r)
{
	//TODO, refactor
    r_eff = min(r, sx / 2 - 0.01, sy / 2 - 0.01);

    linear_extrude(height = h, center = true)
        translate([-sx / 2, -sy])
            union() {
                square([sx, sy - r_eff]);
                translate([r_eff, sy - r_eff])
                    square([sx - 2 * r_eff, r_eff]);
                translate([r_eff, sy - r_eff])
                    circle(r = r_eff);
                translate([sx - r_eff, sy - r_eff])
                    circle(r = r_eff);
            }
}

module shaft()
{
    //TODO, add rotation angle!
    axle_shaft();
    mirror([0, 0, 1])
        axle_shaft();

    module axle_shaft()
    {
        half_length = wheelShaft_Length / 2;
        round_part_length = half_length - wheelShaft_DD_Length; 

        cylinder(d = wheelShaft_Diameter, h = round_part_length, center=false);

        translate([0, 0, round_part_length])
            dd_shaft(length = wheelShaft_DD_Length, diameter = wheelShaft_Diameter, thickness = wheelShaft_DD_Thickness);
    }
}

module dd_shaft(length, diameter, thickness, center = false)
{
    // TODO, to an external library
    // TODO, validation of the parameters
    intersection()
    {
        cylinder(d = diameter, h = length, center = center);
        translate([0, 0, center ? 0 : length/2])
            cube([diameter + 1, thickness, length + 0.01], center = true);
    }
}

module tt_motor_preview()
{
    color([0.953, 0.725, 0.263])
    difference()
    {
        union()
        {
            rounded_square_extruded(
                sx = gearBox_Height,
                sy = gearBox_Length,
                h = gearBox_Width,
                r = gearBox_Corner_Radius
            );

            translate([0, mountingHoleBox_Length])
                rounded_square_extruded(
                    sx = mountingHoleBox_Width,
                    sy = mountingHoleBox_Length,
                    h = mountingHoleBox_Height,
                    r = mountingHoleBox_Corner_Radius);
            
            // motor base
            translate([0, -gearBox_Length, (gearBox_Width - motorBase_Thickness) / 2])
                rotate([90, 0, 0])
                    dd_shaft(length = motorBase_Length, diameter = gearBox_Height, thickness = motorBase_Thickness, center = false);
        }

        translate([0, -mountingHole_Couple_Offset])
        {
            translate([mountingHole_Couple_Distance/2, 0])
                cylinder(d = mountingHole_Diameter, h = 34, center=true);
            translate([-mountingHole_Couple_Distance/2, 0])
                cylinder(d = mountingHole_Diameter, h = 34, center=true);
        }

        translate([0, mountingHole_Single_Offset])
            cylinder(d = mountingHole_Diameter, h = 34, center=true);

        cube([1000, 1000, 0.1], center=true);//TODO, refactor, get rid of constants
    }

    // 130 motor
    translate([0, -motor_Offset, (gearBox_Width - motorBase_Thickness) / 2 /*TODO, generalize*/])
        rotate([-90, 0, 0])
            motor130_preview();

    // shaft
    color(wheelShaft_Color)
        translate([0, -wheelShaft_Offset])
        {
            shaft();
        }
}

// TODO, move to a library
// TODO, polish!
module motor130_preview()
{
    shaft_length = 36;
    shaft_diameter = 2;

    plastic_bearing_holder_offset = 1.5;
    plastic_bearing_holder_diameter = 9.9;
    plastic_bearing_holder_hight = 2.3;
    plastic_bearing_holder_thickness = 8.9;// TODO, fix to have D not a cylinder!!!

    motor_body_diameter = 20;
    motor_body_thickness = 15.1;

    motor_body_plastic_hight = 5;

    motor_body_metal_hight = 15;

    metal_bearing_holder_diameter = 6.1;
    metal_bearing_holder_high = 1.6;

    // shaft
    color("silver")
        cylinder(d = shaft_diameter, h = shaft_length);
    
    translate([0, 0, plastic_bearing_holder_offset])
    {
        // plastic "bearing"
        color("blue")// TODO parameter
            cylinder(d = plastic_bearing_holder_diameter, h = plastic_bearing_holder_hight);

        translate([0, 0, plastic_bearing_holder_hight])
        {
            // plastic main body
            color("blue")// TODO parameter
                dd_shaft(
                    length = motor_body_plastic_hight,
                    diameter = motor_body_diameter,
                    thickness = motor_body_thickness);
            
            translate([0, 0, motor_body_plastic_hight])
            {
                // metal main body
                color("silver")
                    dd_shaft(
                    length = motor_body_metal_hight,
                    diameter = motor_body_diameter,
                    thickness = motor_body_thickness);

                translate([0, 0, motor_body_metal_hight])
                {
                    // metal bearing holder
                    color("silver")
                        cylinder(d = metal_bearing_holder_diameter, h = metal_bearing_holder_high);
                }
            }
        }
    }    
}

tt_motor_preview();