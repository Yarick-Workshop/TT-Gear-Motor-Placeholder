/*
    Copyright (c) 2026 Yarick Workshop
        - Telegram: https://t.me/YarickWorkshop
        - YouTube: https://www.youtube.com/@yarick-workshop
        - Patreon: https://www.patreon.com/YarickWorkshop
        - Thingiverse: https://www.thingiverse.com/techno_plyushkin/
        - Repository: https://github.com/Yarick-Workshop/TT-Gear-Motor-Placeholder

    Drawings sources:
        - TT Gearbox Motor: 
            - https://grabcad.com/library/dc-3v-6v-tt-motor-1
            - https://www.adafruit.com/product/3777
*/

$fn = 64;// TODO, play with it, investigate the artifacts!

/* [Origin] */
origin_Lengthwise = "shaft"; // [shaft:Shaft center, front:Gearbox front]
origin_Heightwise = "shaft"; // [shaft:Shaft center, top:Top of gearbox, bottom:Bottom of gearbox]

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
gearBox_Pin_Diameter = 4;
gearBox_Pin_Height = 1.92;
gearBox_Pin_Top_Round_Radius = 0.25;
gearBox_Pin_Offset = 22.2;

/* [Motor] */
motorBase_Length = 11.2;//OK!!!
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
wheelShaft_Inner_Diameter = 1.95;
wheelShaft_Offset = 11.0;
wheelShaft_DD_Length = 6;// TODO
wheelShaft_DD_Thickness = 3;// TODO

/* [Belt] */
// measured:
belt_Thickness = 0.9;
belt_Ring_External_Diameter = 15.1;
belt_Ring_Internal_Diameter = 10.5;
belt_Width = 8;
belt_Offset_To_Buckle = 21.55;// TODO, it has to be auto-calculated instead!
belt_From_Motor_Bottom_Offset = 3.8;//TODO, do we need it?

belt_Buckle_Width = 11.8;
belt_Buckle_Length = 10.3;
belt_Buckle_Corner_Radius = 1;
belt_Buckle_Hole_Width = 8;
belt_Buckle_Hole_Length = 5;
belt_Buckle_Hole_Corner_Radius = 1;

/* [Hook] */
hook_Offset = 5;
hook_Top_Thickness = 0.8;
hook_Top_Side_Thickness = 0.4;
hook_Bottom_Side_Thickness = 1.5;
hook_Internal_Height = 1.5;
hook_Internal_Width = 1.5;
hook_Depth = 5;
hook_Cave_Width = 2;
hook_Cave_Length = 6;

/* [Placeholder] */
placeholder_Hole_Length = 100;
placeholder_Clearance = 0.5;

/* [Preview] */
preview_Mode = "both"; // [placeholder:Placeholder, preview:Preview, both:Both (side by side), xor:XOR, placeholder_minus_preview:Placeholder - Preview, preview_minus_placeholder:Preview - Placeholder]
preview_Placeholder_Gap = 10;

/* [Hidden] */
EPSILON = 0.01;

// pre-calculated values
motor_Side_Offset = (gearBox_Width - motorBase_Thickness) / 2;
motor_Box_Width = max(
    motorBase_Thickness,
    motorBase_Thickness + 2 * (hook_Internal_Height + hook_Top_Thickness),
    motorBase_Thickness + 2 * belt_Thickness + EPSILON,
    belt_Ring_External_Diameter);
preview_Pos_X_Extent = max(
    wheelShaft_Length / 2,
    gearBox_Width / 2 + gearBox_Pin_Height,
    mountingHoleBox_Height / 2,
    motor_Box_Width / 2 - motor_Side_Offset);
placeholder_Neg_X_Extent = max(
    placeholder_Hole_Length / 2,
    gearBox_Width / 2 + placeholder_Clearance,
    mountingHoleBox_Height / 2 + placeholder_Clearance,
    motor_Side_Offset + motor_Box_Width / 2 + placeholder_Clearance);
preview_Placeholder_Offset = preview_Pos_X_Extent + placeholder_Neg_X_Extent + preview_Placeholder_Gap;

function origin_lengthwise_offset(mode) =
    mode == "shaft" ? -wheelShaft_Offset :
    mode == "front" ? 0 :
    assert(false, str("Unknown origin_Lengthwise mode: ", mode));

function origin_heightwise_offset(mode) =
    mode == "shaft" ? 0 :
    mode == "top" ? gearBox_Height / 2 :
    mode == "bottom" ? -gearBox_Height / 2 :
    assert(false, str("Unknown origin_Heightwise mode: ", mode));

module rounded_square_extruded(
    sx,
    sy,
    h,
    r)
{
    //TODO, refactor
    r_eff = max(0, min(r, sx / 2, sy / 2));

    linear_extrude(height = h, center = true)
        translate([-sx / 2, 0])
            if (r_eff == 0)
                square([sx, sy]);
            else
                union() {
                    translate([0, r_eff])
                        square([sx, sy - r_eff]);
                    if (sx > 2 * r_eff)
                    {
                        translate([r_eff, 0])
                            square([sx - 2 * r_eff, r_eff]);
                        translate([sx - r_eff, r_eff])
                            circle(r = r_eff);
                    }
                    translate([r_eff, r_eff])
                        circle(r = r_eff);
                }
}

module shaft(angle)
{
    rotate([0, 0, angle])
        difference ()
        {
            // shaft body
            union()
            {
                axle_shaft();
                mirror([0, 0, 1])
                    axle_shaft();
            }

            // internal hole for the shaft, TODO, refactor, really there are 2 parts but not one
            cylinder(d = wheelShaft_Inner_Diameter, h = wheelShaft_Length + 2 * EPSILON, center=true);
        }
    

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

include <Motor-130-Library.scad>

module tt_motor_preview(
    shaft_angle = 0,
    origin_lengthwise = origin_Lengthwise,
    origin_heightwise = origin_Heightwise)
{
    translate([origin_heightwise_offset(origin_heightwise), origin_lengthwise_offset(origin_lengthwise), 0])
    {
        color([0.953, 0.725, 0.263])// TODO, move this and other colors to input parameters :)
        difference()
        {
            union()
            {
                // gear box body
                rounded_square_extruded(
                    sx = gearBox_Height,
                    sy = gearBox_Length,
                    h = gearBox_Width,
                    r = gearBox_Corner_Radius
                );

                // side pin
                translate([0, gearBox_Pin_Offset, -gearBox_Width / 2])
                    rotate([0, 180])
                        round_end_cylinder(
                            diameter = gearBox_Pin_Diameter,
                            length = gearBox_Pin_Height,
                            top_round_radius = gearBox_Pin_Top_Round_Radius,
                            center = false);

                // additional mounting hole box
                translate([0, -mountingHoleBox_Length])
                    rounded_square_extruded(
                        sx = mountingHoleBox_Width,
                        sy = mountingHoleBox_Length,
                        h = mountingHoleBox_Height,
                        r = mountingHoleBox_Corner_Radius);
                
                // motor base
                translate([0, gearBox_Length, motor_Side_Offset])
                    rotate([-90, 0, 0])
                        motor_mounting_part();
            }

            // mounting holes
            translate([0, mountingHole_Couple_Offset])
            {
                translate([mountingHole_Couple_Distance/2, 0])
                    cylinder(d = mountingHole_Diameter, h = 34, center=true);
                translate([-mountingHole_Couple_Distance/2, 0])
                    cylinder(d = mountingHole_Diameter, h = 34, center=true);
            }

            // additional mounting hole
            translate([0, -mountingHole_Single_Offset])
                cylinder(d = mountingHole_Diameter, h = 34, center=true);

            // shaft hole
            translate([0, wheelShaft_Offset])
            {
                cylinder(d = wheelShaft_Diameter + 2 * EPSILON, h = gearBox_Width + 2 * EPSILON, center = true);
            }

            // separate 2 halves of the gearbox and motor base along Z = 0
            split_sx = max(gearBox_Height, mountingHoleBox_Width, hook_Depth) + 2 * EPSILON;
            split_sy = mountingHoleBox_Length + gearBox_Length + motorBase_Length + 2 * EPSILON;
            translate([0, (gearBox_Length + motorBase_Length - mountingHoleBox_Length) / 2, 0])
                cube([split_sx, split_sy, 0.1], center = true);
        }

        // 130 motor
        translate([0, motor_Offset, motor_Side_Offset])
            rotate([-90, 0, 180])
                motor130_preview();

        // shaft
        color(wheelShaft_Color)
            translate([0, wheelShaft_Offset])
            {
                shaft(shaft_angle);
            }

        color("gray", 0.5)
            translate([0, motor_Offset - belt_From_Motor_Bottom_Offset + belt_Thickness, motor_Side_Offset])
                rotate([90, 0, 0])
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
}

/*
    Negative-volume placeholder for difference() cutouts (cavities, shaft, and screw holes).
    `clearance` adds an outward fit margin per side to the boxes, pin, and wheel shaft cylinder.
    `hole_length` is the total centered length along local Z (must exceed `gearBox_Width + 2 * clearance`
    for the rear screw holes and wheel shaft opening to extend beyond the gearbox cavity).
*/
module tt_motor_placeholder(
    origin_lengthwise = origin_Lengthwise,
    origin_heightwise = origin_Heightwise,
    hole_length = placeholder_Hole_Length,
    clearance = placeholder_Clearance,
    hole_diameter = mountingHole_Diameter)
{
    assert(hole_length > 0, "hole_length must be positive");
    assert(clearance >= 0, "clearance must be non-negative");
    assert(hole_diameter > 0, "hole_diameter must be positive");

    motor_rear_y = max(motor_Offset, motor_Offset - belt_From_Motor_Bottom_Offset + belt_Thickness);
    assert(motor_rear_y > gearBox_Length, "motor rear extent must exceed gearBox_Length");
    motor_box_front_y = max(-clearance, gearBox_Length - clearance - EPSILON);
    motor_box_length = motor_rear_y + clearance - motor_box_front_y;
    motor_box_height = max(gearBox_Height, belt_Ring_External_Diameter, belt_Buckle_Width, belt_Width, hook_Depth);

    translate([origin_heightwise_offset(origin_heightwise), origin_lengthwise_offset(origin_lengthwise), 0])
        union()
        {
            // main gearbox box
            translate([
                -(gearBox_Height + 2 * clearance) / 2,
                -clearance,
                -(gearBox_Width + 2 * clearance) / 2])
                cube([
                    gearBox_Height + 2 * clearance,
                    gearBox_Length + 2 * clearance,
                    gearBox_Width + 2 * clearance]);

            // front mounting lug box
            translate([
                -(mountingHoleBox_Width + 2 * clearance) / 2,
                -mountingHoleBox_Length - clearance,
                -(mountingHoleBox_Height + 2 * clearance) / 2])
                cube([
                    mountingHoleBox_Width + 2 * clearance,
                    mountingHoleBox_Length + clearance + EPSILON,
                    mountingHoleBox_Height + 2 * clearance]);

            // motor, base, hooks and belt cover box
            translate([
                -(motor_box_height + 2 * clearance) / 2,
                motor_box_front_y,
                motor_Side_Offset - (motor_Box_Width + 2 * clearance) / 2])
                cube([
                    motor_box_height + 2 * clearance,
                    motor_box_length,
                    motor_Box_Width + 2 * clearance]);

            // side pin placeholder
            translate([0, gearBox_Pin_Offset, -gearBox_Width / 2 + EPSILON])
                rotate([0, 180, 0])
                    cylinder(
                        d = gearBox_Pin_Diameter + 2 * clearance,
                        h = gearBox_Pin_Height + clearance + EPSILON,
                        center = false);

            // mounting screw hole cylinders
            translate([0, mountingHole_Couple_Offset, 0])
            {
                translate([mountingHole_Couple_Distance / 2, 0, 0])
                    cylinder(d = hole_diameter, h = hole_length, center = true);
                translate([-mountingHole_Couple_Distance / 2, 0, 0])
                    cylinder(d = hole_diameter, h = hole_length, center = true);
            }

            translate([0, -mountingHole_Single_Offset, 0])
                cylinder(d = hole_diameter, h = hole_length, center = true);

            // wheel shaft pass-through cylinder
            translate([0, wheelShaft_Offset, 0])
                cylinder(d = wheelShaft_Diameter + 2 * clearance, h = hole_length, center = true);
        }
}

module belt()
{
    assert(belt_Thickness > 0, "belt_Thickness must be positive");
    assert(belt_Width > 0, "belt_Width must be positive");
    assert(
        belt_Ring_Internal_Diameter < belt_Ring_External_Diameter,
        "belt_Ring_Internal_Diameter must be less than belt_Ring_External_Diameter");
    assert(
        belt_Buckle_Hole_Width < belt_Buckle_Width,
        "belt_Buckle_Hole_Width must be less than belt_Buckle_Width");
    assert(
        belt_Buckle_Hole_Length < belt_Buckle_Length,
        "belt_Buckle_Hole_Length must be less than belt_Buckle_Length");

    // ring + strap/buckles with a single shared bore cutout along Z
    difference()
    {
        union()
        {
            cylinder(d = belt_Ring_External_Diameter, h = belt_Thickness);

            rotate([90, 0, -90])
            {
                // belt strap
                belt_strap_outer_sx = motorBase_Thickness + 2 * belt_Thickness + EPSILON;
                belt_strap_outer_sy = belt_Offset_To_Buckle - belt_Buckle_Length + 2 * EPSILON;
                belt_strap_corner_radius = max(0, min(belt_Buckle_Corner_Radius, belt_strap_outer_sx / 2, belt_strap_outer_sy / 2));
                belt_strap_inner_corner_radius = max(0, belt_strap_corner_radius - belt_Thickness);
                difference()
                {
                    rounded_square_extruded(
                        sx = belt_strap_outer_sx,
                        sy = belt_strap_outer_sy,
                        h = belt_Width,
                        r = belt_strap_corner_radius);
                    translate([0, belt_Thickness])
                        rounded_square_extruded(
                            sx = motorBase_Thickness + EPSILON,
                            sy = belt_strap_outer_sy - belt_Thickness + EPSILON,
                            h = belt_Width + 2 * EPSILON,
                            r = belt_strap_inner_corner_radius);
                }

                // belt buckles
                belt_buckle();
                mirror([1, 0, 0])
                    belt_buckle();
            }
        }

        translate([0, 0, -EPSILON])
            cylinder(
                d = belt_Ring_Internal_Diameter,
                h = belt_Thickness + 2 * EPSILON);
    }

    module belt_buckle()
    {
        translate(
            [
                motorBase_Thickness / 2 + belt_Thickness / 2 + EPSILON / 2,
                belt_Offset_To_Buckle
            ])
            rotate([0, -90, 180])
                difference()
                {
                    rounded_square_extruded(
                        sx = belt_Buckle_Width,
                        sy = belt_Buckle_Length,
                        h = belt_Thickness,
                        r = belt_Buckle_Corner_Radius);
                    translate([0, (belt_Buckle_Length - belt_Buckle_Hole_Length) / 2])
                        rounded_square_extruded(
                            sx = belt_Buckle_Hole_Width,
                            sy = belt_Buckle_Hole_Length,
                            h = belt_Thickness + 2 * EPSILON,
                            r = belt_Buckle_Hole_Corner_Radius);
                }
    }
}

module motor_mounting_part()
{
    hook_position_on_base = motorBase_Length - hook_Offset;// along motor base from gearbox face
    hook_flat_face_offset = motorBase_Thickness / 2;// D-shaft flat face, from center

    union()
    {
        difference()
        {
            // D-shaft motor base
            dd_shaft(
                length = motorBase_Length,
                diameter = gearBox_Height,
                thickness = motorBase_Thickness,
                center = false);

            // cave between mirrored hooks
            translate([0, 0, hook_position_on_base - hook_Cave_Width / 2])
                cube(
                    [
                        hook_Cave_Length,
                        motorBase_Thickness + EPSILON,
                        hook_Cave_Width
                    ],
                    center = true);
        }

        // belt hooks
        hook_on_flat_face();
        mirror([0, 1, 0])
            hook_on_flat_face();
    }

    module hook_on_flat_face()
    {
        translate([0, hook_flat_face_offset, hook_position_on_base])
            rotate([0, -90])
                linear_extrude(height = hook_Depth, center = true)
                    polygon(points = [
                        [0, 0],
                        [0, hook_Internal_Height],
                        [-hook_Internal_Width, hook_Internal_Height],
                        [-hook_Internal_Width, hook_Internal_Height + hook_Top_Thickness],
                        [hook_Top_Side_Thickness, hook_Internal_Height + hook_Top_Thickness],
                        [hook_Bottom_Side_Thickness, 0]
                    ]);
    }
}

// the main rendering part
module _tt_motor_scene()
{
    module preview_aligned()
    {
        rotate([0, -90, 0])
            tt_motor_preview(shaft_angle = 90);
    }

    module placeholder_aligned()
    {
        rotate([0, -90, 0])
            tt_motor_placeholder();
    }

    if (preview_Mode == "placeholder")
        placeholder_aligned();
    else if (preview_Mode == "preview")
        preview_aligned();
    else if (preview_Mode == "both")
    {
        preview_aligned();
        translate([preview_Placeholder_Offset, 0, 0])
            placeholder_aligned();
    }
    else if (preview_Mode == "xor")
    {
        union()
        {
            difference()
            {
                placeholder_aligned();
                preview_aligned();
            }
            difference()
            {
                preview_aligned();
                placeholder_aligned();
            }
        }
    }
    else if (preview_Mode == "placeholder_minus_preview")
    {
        difference()
        {
            placeholder_aligned();
            preview_aligned();
        }
    }
    else if (preview_Mode == "preview_minus_placeholder")
    {
        difference()
        {
            preview_aligned();
            placeholder_aligned();
        }
    }
    else
        assert(
            false,
            str(
                "Unknown preview_Mode '", preview_Mode,
                "', expected one of: placeholder, preview, both, xor, placeholder_minus_preview, preview_minus_placeholder"));
}

_tt_motor_scene();
