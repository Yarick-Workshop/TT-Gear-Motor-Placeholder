/*
Drawings sources:
    - TT Gearbox Motor: https://grabcad.com/library/dc-3v-6v-tt-motor-1
    - 130 motor: https://www.makerstore.com.au/product/elec-130motor-dc6v/
*/

$fn = 64;// TODO, play with it, investigate the artifacts!

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

/* [Belt] */
// measured:
belt_Thickness = 0.9;
belt_Ring_External_Diameter = 15.1;
belt_Ring_Internal_Diameter = 10.5;
belt_Width = 8;
belt_Offset_To_Buckle = 22;// TODO, it has to be auto-calculated instead!
belt_From_Motor_Bottom_Offset = 3.8;//TODO, do we need it?

belt_Buckle_Width = 11.8;
belt_Buckle_Length = 10.3;
belt_Buckle_Corner_Radius = 1;
belt_Buckle_Hole_Width = 8;
belt_Buckle_Hole_Length = 5;
belt_Buckle_Hole_Corner_Radius = 1;

/* [Hidden] */
EPSILON = 0.01;

// pre-calculated values
motor_Side_Offset = (gearBox_Width - motorBase_Thickness) / 2;

module rounded_square_extruded(
    sx,
    sy,
    h,
    r)
{
	//TODO, refactor
    r_eff = min(r, sx / 2, sy / 2);

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

module round_end_profile_2d(r, h, rb, rt)
{
    // R-Z half-profile: rectangles + quarter circles; any rb/rt combination.
    // rb=0, rt=0 → plain rectangle; rb only / rt only / both → body + end caps.
    body_h = h - rb - rt;

    union()
    {
        if (rb == 0 && rt == 0)
            square([r, h]);
        else
        {
            if (body_h > 0)
                translate([0, rb])
                    square([r, body_h]);

            if (rb > 0)
            {
                square([r - rb, rb]);
                intersection()
                {
                    translate([r - rb, rb])
                        circle(r = rb);
                    translate([r - rb, 0])
                        square([rb, rb]);
                }
            }

            if (rt > 0)
            {
                translate([0, h - rt])
                    square([r - rt, rt]);
                intersection()
                {
                    translate([r - rt, h - rt])
                        circle(r = rt);
                    translate([r - rt, h - rt])
                        square([rt, rt]);
                }
            }
        }
    }
}

module round_end_cylinder(
    diameter,
    length,
    bottom_round_radius = 0,
    top_round_radius = 0,
    center = false)
{
    r = diameter / 2;
    rb = bottom_round_radius > 0 ? min(bottom_round_radius, r, length / 2) : 0;
    rt = top_round_radius > 0 ? min(top_round_radius, r, length / 2) : 0;
    z0 = center ? -length / 2 : 0;

    translate([0, 0, z0])
        rotate_extrude()
            round_end_profile_2d(r, length, rb, rt);
}

module dd_shaft(
    length,
    diameter,
    thickness,
    bottom_round_radius = 0,
    top_round_radius = 0,
    center = false)
{
    // TODO, to an external library
    // TODO, validation of the parameters
    intersection()
    {
        round_end_cylinder(
            diameter = diameter,
            length = length,
            bottom_round_radius = bottom_round_radius,
            top_round_radius = top_round_radius,
            center = center);
        translate([0, 0, center ? 0 : length/2])
            cube([diameter + 1, thickness, length + EPSILON], center = true);
    }
}

module d_shaft(length, diameter, thickness, bottom_round_radius = 0, center = false)
{
    // TODO, check and optimize!
    // Single-flat D profile (thickness = flat-to-peak height).
    r = diameter / 2;
    intersection()
    {
        round_end_cylinder(
            diameter = diameter,
            length = length,
            bottom_round_radius = bottom_round_radius,
            center = center);
        translate([-(diameter + 1) / 2, -r + (diameter - thickness), center ? -length/2 : 0])
            cube([diameter + 1, thickness + EPSILON, length + EPSILON], center = false);
    }
}

module tt_motor_preview()
{
    color([0.953, 0.725, 0.263])// TODO, move this and other colors to input parameters :)
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
            translate([0, -gearBox_Length, motor_Side_Offset])
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
    translate([0, -motor_Offset, motor_Side_Offset])
        rotate([-90, 0, 0])
            motor130_preview();

    // shaft
    color(wheelShaft_Color)
        translate([0, -wheelShaft_Offset])
        {
            shaft();
        }

    color("gray", 0.5)
        translate([0, -motor_Offset + belt_From_Motor_Bottom_Offset - belt_Thickness, /*TODO, generalize*/, motor_Side_Offset])
            rotate([-90, 0, 0])
                if ($preview)
                {
                    render() // to get rid of artifacts, TODO try another way to speed-up
                        belt();
                }
                else
                {
                    belt();
                }
}

// TODO, move to a library
// TODO, polish!
module motor130_preview()
{
    shaft_length = 36;
    shaft_diameter = 2;
    motor_shaft_bottom_round_radius = 0.25;
    motor_shaft_top_round_radius = 0.25;

    plastic_bearing_holder_offset = 1.5;
    plastic_bearing_holder_diameter = 9.9;
    plastic_bearing_holder_hight = 2.3;
    plastic_bearing_holder_thickness = 8.9;
    plastic_bearing_holder_bottom_round_radius = 0.5;

    motor_body_diameter = 20;
    motor_body_thickness = 15.1;

    motor_body_plastic_hight = 5;
    motor_body_plastic_bottom_round_radius = 1.5;

    motor_body_metal_hight = 15;
    motor_body_metal_top_round_radius = 0.5;

    metal_bearing_holder_diameter = 6.1;
    metal_bearing_holder_high = 1.6;
    metal_bearing_holder_top_round_radius = 0.5;

    // shaft
    color("silver")
        round_end_cylinder(
            diameter = shaft_diameter,
            length = shaft_length,
            bottom_round_radius = motor_shaft_bottom_round_radius,
            top_round_radius = motor_shaft_top_round_radius);
    
    translate([0, 0, plastic_bearing_holder_offset])
    {
        // plastic "bearing" (flat on +Y, opposite of default d_shaft)
        color("blue")// TODO parameter
            mirror([0, 1, 0])
                d_shaft(
                    length = plastic_bearing_holder_hight,
                    diameter = plastic_bearing_holder_diameter,
                    thickness = plastic_bearing_holder_thickness,
                    bottom_round_radius = plastic_bearing_holder_bottom_round_radius);

        translate([0, 0, plastic_bearing_holder_hight])
        {
            // plastic main body
            color("blue")// TODO parameter
                dd_shaft(
                    length = motor_body_plastic_hight,
                    diameter = motor_body_diameter,
                    thickness = motor_body_thickness,
                    bottom_round_radius = motor_body_plastic_bottom_round_radius);
            
            translate([0, 0, motor_body_plastic_hight])
            {
                // metal main body
                color("silver")
                    dd_shaft(
                        length = motor_body_metal_hight,
                        diameter = motor_body_diameter,
                        thickness = motor_body_thickness,
                        top_round_radius = motor_body_metal_top_round_radius);

                translate([0, 0, motor_body_metal_hight])
                {
                    // metal bearing holder
                    color("silver")
                        round_end_cylinder(
                            diameter = metal_bearing_holder_diameter,
                            length = metal_bearing_holder_high,
                            top_round_radius = metal_bearing_holder_top_round_radius);
                }
            }
        }
    }    
}

module belt()
{
    assert(belt_Thickness > 0, "belt_Thickness must be positive");
    assert(belt_Width > 0, "belt_Width must be positive");
    assert(
        belt_Ring_Internal_Diameter > belt_Ring_External_Diameter,
        "belt_Ring_Internal_Diameter must be less than belt_Ring_External_Diameter");
    assert(
        belt_Buckle_Hole_Width < belt_Buckle_Width,
        "belt_Buckle_Hole_Width must be less than belt_Buckle_Width");
    assert(
        belt_Buckle_Hole_Length < belt_Buckle_Length,
        "belt_Buckle_Hole_Length must be less than belt_Buckle_Length");

    // ring 
    difference()
    {
        cylinder(d = belt_Ring_External_Diameter, h = belt_Thickness);
        cylinder(d = belt_Ring_Internal_Diameter, h = belt_Thickness);
    }

    rotate([-90, 0, 90])
    {
        // belt strap
        difference()
        {
            rounded_square_extruded(
                sx = motorBase_Thickness + 2 * belt_Thickness + EPSILON,
                sy = belt_Offset_To_Buckle - belt_Buckle_Length + 2 * EPSILON,
                h = belt_Width,
                r = belt_Buckle_Corner_Radius);
            translate([0, - belt_Thickness + EPSILON])
                rounded_square_extruded(
                    sx = motorBase_Thickness + EPSILON,
                    sy = belt_Offset_To_Buckle - belt_Buckle_Length - belt_Thickness + 4 * EPSILON,
                    h = belt_Width,
                    r = belt_Buckle_Corner_Radius);
            rotate([90, 0])
                cylinder(d = belt_Ring_Internal_Diameter, h = belt_Thickness);
        }

        // belt buckles
        belt_buckle();
        
        mirror([1, 0, 0])
            belt_buckle();
    }

    module belt_buckle()
    {
        translate([motorBase_Thickness / 2 + belt_Thickness / 2 + EPSILON / 2, -belt_Offset_To_Buckle])
            rotate([0, 90, 180])
                difference()
                {
                    rounded_square_extruded(
                        sx = belt_Buckle_Width,
                        sy = belt_Buckle_Length,
                        h = belt_Thickness,
                        r = belt_Buckle_Corner_Radius);
                    translate([0, -(belt_Buckle_Length - belt_Buckle_Hole_Length) / 2])
                        rounded_square_extruded(
                            sx = belt_Buckle_Hole_Width,
                            sy = belt_Buckle_Hole_Length,
                            h = belt_Thickness,
                            r = belt_Buckle_Hole_Corner_Radius);
                }
    }
}

// the main rendering part
rotate([0, 90, 180])
    tt_motor_preview();
