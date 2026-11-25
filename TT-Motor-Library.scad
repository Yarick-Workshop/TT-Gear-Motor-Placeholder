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
wheelShaft_DD_Thickness = 3.7;

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
placeholder_Shaft_Clearance = 0.1;
placeholder_Shaft_DD_Below_Length = 20;
placeholder_Shaft_Gearbox_Clearance = 1.0;

/* [Preview] */
preview_Mode = "both"; // [placeholder:Placeholder, placeholder_shaft:Placeholder shaft, preview:Preview, preview_with_wheels:Preview with wheels, wheel_only:Wheel only, shaft_test:Shaft fit test, both:Both (side by side), xor:XOR, placeholder_minus_preview:Placeholder - Preview, preview_minus_placeholder:Preview - Placeholder]
preview_Placeholder_Gap = 10;
preview_Shaft_Angle = 90; // [0:1:360]
preview_Show_Body = true;
preview_Show_Shaft = true;
preview_Fn = 64;

/* [Hidden] */
EPSILON = 0.01;

function tt_motor_gearbox_height() =
    assert(gearBox_Height > 0, "gearBox_Height must be positive")
    gearBox_Height;

function wheel_shaft_round_part_length() =
    assert(wheelShaft_DD_Length >= 0, "wheelShaft_DD_Length must be non-negative")
    assert(
        wheelShaft_Length > 2 * wheelShaft_DD_Length,
        "wheelShaft_Length must be greater than 2 * wheelShaft_DD_Length")
    wheelShaft_Length / 2 - wheelShaft_DD_Length;

function tt_motor_shaft_diameter() =
    assert(wheelShaft_Diameter > 0, "wheelShaft_Diameter must be positive")
    wheelShaft_Diameter;

function tt_motor_shaft_dd_thickness() =
    assert(wheelShaft_DD_Thickness > 0, "wheelShaft_DD_Thickness must be positive")
    wheelShaft_DD_Thickness;

function tt_motor_shaft_dd_length() =
    assert(wheelShaft_DD_Length > 0, "wheelShaft_DD_Length must be positive")
    wheelShaft_DD_Length;

function tt_motor_shaft_placeholder_round_length(gearbox_clearance = placeholder_Shaft_Gearbox_Clearance) =
    let(round_len = wheel_shaft_round_part_length() - gearBox_Width / 2 - gearbox_clearance)
    assert(gearbox_clearance >= 0, "gearbox_clearance must be non-negative")
    assert(round_len > 0, "gearbox_clearance leaves no exposed round shaft length")
    round_len;

function tt_motor_shaft_test_outer_diameter(hub_diameter = 0, clearance = placeholder_Shaft_Clearance) =
    assert(hub_diameter >= 0, "hub_diameter must be non-negative")
    assert(clearance >= 0, "clearance must be non-negative")
    max(hub_diameter > 0 ? hub_diameter + 4 : 0, wheelShaft_Diameter + 2 * clearance + 8);

// pre-calculated values
motor_Side_Offset = (gearBox_Width - motorBase_Thickness) / 2;
motor_Box_Width = max(
    motorBase_Thickness,
    motorBase_Thickness + 2 * (hook_Internal_Height + hook_Top_Thickness),
    motorBase_Thickness + 2 * belt_Thickness + EPSILON,
    belt_Ring_External_Diameter);
preview_Pos_X_Extent = max(
    preview_Show_Shaft ? wheelShaft_Length / 2 : 0,
    preview_Show_Body ? max(
        gearBox_Width / 2 + gearBox_Pin_Height,
        mountingHoleBox_Height / 2,
        motor_Box_Width / 2 - motor_Side_Offset) : 0);
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
    mode == "top" ? tt_motor_gearbox_height() / 2 :
    mode == "bottom" ? -tt_motor_gearbox_height() / 2 :
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
        round_part_length = wheel_shaft_round_part_length();

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
    origin_heightwise = origin_Heightwise,
    show_body = preview_Show_Body,
    show_shaft = preview_Show_Shaft)
{
    assert($children <= 2, str("tt_motor_preview expects 0, 1, or 2 wheel children, got ", $children));
    assert(is_bool(show_body), "show_body must be a boolean");
    assert(is_bool(show_shaft), "show_shaft must be a boolean");

    origin_x = origin_heightwise_offset(origin_heightwise);
    origin_y = origin_lengthwise_offset(origin_lengthwise);

    if (show_body || show_shaft || $children > 0)
        translate([origin_x, origin_y, 0])
        {
            if (show_body)
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

                // retaining belt
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

            // shaft and optional wheel callbacks
            if (show_shaft || $children > 0)
                translate([0, wheelShaft_Offset])
                {
                    if (show_shaft)
                        color(wheelShaft_Color)
                            shaft(shaft_angle);

                    if ($children > 0)
                        rotate([0, 0, shaft_angle])
                        {
                            round_part_length = wheel_shaft_round_part_length();

                            translate([0, 0, round_part_length])
                                children(0);

                            rotate([180, 0, 0])
                                translate([0, 0, round_part_length])
                                    if ($children == 2)
                                        children(1);
                                    else
                                        children(0);
                        }
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

/*
    Vertical negative-volume cutting placeholder for one TT motor output shaft end (DD + round collar).
    Z = 0 marks the physical DD shaft tip:
      - [-dd_below_length, dd_length]: double-D section (extends below Z = 0 for through-hole wheel cuts
        so internal flats can be cleaned with a file; set dd_below_length = 0 for a blind pocket)
      - [dd_length, dd_length + round_length]: round shaft collar
    DD flats are at +-Y, curved faces at +-X.
    TODO: add optional M2 retaining screw through-hole and outer screw-head recess support.
*/
module tt_motor_shaft_placeholder(
    clearance = placeholder_Shaft_Clearance,
    dd_length = wheelShaft_DD_Length,
    round_length = wheel_shaft_round_part_length(),
    dd_below_length = placeholder_Shaft_DD_Below_Length)
{
    assert(clearance >= 0, "clearance must be non-negative");
    assert(dd_length > 0, "dd_length must be positive");
    assert(round_length >= 0, "round_length must be non-negative");
    assert(dd_below_length >= 0, "dd_below_length must be non-negative");
    assert(wheelShaft_Diameter > 0 && wheelShaft_DD_Thickness > 0, "Wheel shaft dimensions must be positive");
    assert(
        wheelShaft_DD_Thickness + 2 * clearance <= wheelShaft_Diameter + 2 * clearance,
        "Effective DD thickness must not exceed effective shaft diameter");

    effective_diameter = wheelShaft_Diameter + 2 * clearance;
    effective_dd_thickness = wheelShaft_DD_Thickness + 2 * clearance;

    union()
    {
        translate([0, 0, -dd_below_length])
            dd_shaft(
                length = dd_below_length + dd_length + (round_length > 0 ? EPSILON : 0),
                diameter = effective_diameter,
                thickness = effective_dd_thickness,
                center = false);

        if (round_length > 0)
            translate([0, 0, dd_length])
                cylinder(
                    d = effective_diameter,
                    h = round_length,
                    center = false);
    }
}

/*
    3D-printable calibration puck for testing fit against a vertical shaft cutting placeholder.
    Requires exactly 1 child (the cutting placeholder, e.g. tt_motor_shaft_placeholder()).
    TODO: support optional M2 retaining screw hole / head recess once added to tt_motor_shaft_placeholder().
*/
module tt_motor_shaft_hole_test(
    shaft_depth = wheelShaft_DD_Length + tt_motor_shaft_placeholder_round_length(),
    height = 2 * wheelShaft_DD_Length,
    outer_diameter = tt_motor_shaft_test_outer_diameter(),
    hub_diameter = 0,
    base_height = 2.0,
    shaft_slot_angle = 0)
{
    assert(
        $children == 1,
        str("tt_motor_shaft_hole_test requires exactly 1 child (cutting placeholder), got ", $children));
    assert(shaft_depth >= 0, "shaft_depth must be non-negative");
    assert(height > 0, "height must be positive");
    assert(outer_diameter > 0, "outer_diameter must be positive");
    assert(hub_diameter >= 0, "hub_diameter must be non-negative");
    assert(base_height > 0, "base_height must be positive");
    if (hub_diameter > 0)
        assert(outer_diameter >= hub_diameter, "outer_diameter must be at least hub_diameter");

    total_height = max(height, shaft_depth);
    test_base_height = min(base_height, total_height);
    test_hub_height = total_height - test_base_height;
    use_hub_step = hub_diameter > 0 && hub_diameter < outer_diameter && test_hub_height > 0;

    difference()
    {
        union()
        {
            cylinder(h = use_hub_step ? test_base_height : total_height, d = outer_diameter);

            if (use_hub_step)
                translate([0, 0, test_base_height - EPSILON])
                    cylinder(h = test_hub_height + EPSILON, d = hub_diameter);
        }

        if (shaft_depth > 0)
        {
            is_through_socket = shaft_depth >= total_height - EPSILON * 0.5;
            cut_start_z = is_through_socket ? -EPSILON : total_height - shaft_depth;

            translate([0, 0, cut_start_z])
                rotate([0, 0, shaft_slot_angle])
                    children(0);
        }
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

// demo spoked wheel with DD bore and indicator spoke so shaft rotation is clearly visible
module _preview_demo_wheel(diameter = 34, width = 8)
{
    tire_thickness = 2.5;
    rim_outer_d = diameter - 2 * tire_thickness;
    rim_inner_d = rim_outer_d - 3;
    hub_diameter = max(10, wheelShaft_Diameter + 3);
    spoke_count = 5;
    spoke_width = 2.4;
    rim_thickness = width - 1.5;
    spoke_thickness = rim_thickness - 2 * EPSILON;
    spoke_length = rim_inner_d / 2 - hub_diameter / 2 + 1;

    assert(diameter > 0 && width > 1.5 + 2 * EPSILON, "Demo wheel width must exceed 1.5 + 2 * EPSILON");
    assert(rim_inner_d > hub_diameter, "Demo wheel diameter is too small for the inner rim and hub");
    assert(wheelShaft_Diameter > 0 && wheelShaft_DD_Thickness > 0, "Wheel shaft dimensions must be positive");

    // outer rubber tire with radial tread ribs
    color("#2b2b2b")
    {
        difference()
        {
            cylinder(d = diameter, h = width);
            translate([0, 0, -EPSILON])
                cylinder(d = rim_outer_d - EPSILON, h = width + 2 * EPSILON);
        }

        for (i = [0 : 11])
            rotate([0, 0, i * 30])
                translate([diameter / 2 - 0.3, 0, width / 2])
                    cube([1.0, 2.0, width], center = true);
    }

    // hub with DD shaft bore cut by tt_motor_shaft_placeholder()
    color("#f2c94c")
    {
        difference()
        {
            cylinder(d = hub_diameter, h = width);
            translate([0, 0, wheelShaft_DD_Length + tt_motor_shaft_placeholder_round_length()])
                rotate([180, 0, 0])
                    tt_motor_shaft_placeholder();
        }

        // inner rim
        translate([0, 0, (width - rim_thickness) / 2])
            difference()
            {
                cylinder(d = rim_outer_d, h = rim_thickness);
                translate([0, 0, -EPSILON])
                    cylinder(d = rim_inner_d, h = rim_thickness + 2 * EPSILON);
            }
    }

    // 5 spokes (spoke 0 highlighted in red to show exact shaft angle)
    for (i = [0 : spoke_count - 1])
        color(i == 0 ? "#d94a38" : "#f2c94c")
            rotate([0, 0, i * 360 / spoke_count])
                translate([hub_diameter / 2 - 0.5 + spoke_length / 2, 0, width / 2])
                    cube([spoke_length, spoke_width, spoke_thickness], center = true);
}

// the main rendering part
module _tt_motor_scene()
{
    module preview_aligned(
        with_wheels = false,
        angle = 90,
        show_body = true,
        show_shaft = true)
    {
        rotate([0, -90, 0])
            if (with_wheels)
                tt_motor_preview(
                    shaft_angle = angle,
                    show_body = show_body,
                    show_shaft = show_shaft)
                    _preview_demo_wheel();
            else
                tt_motor_preview(
                    shaft_angle = angle,
                    show_body = show_body,
                    show_shaft = show_shaft);
    }

    module placeholder_aligned()
    {
        rotate([0, -90, 0])
            tt_motor_placeholder();
    }

    if (preview_Mode == "placeholder")
        placeholder_aligned();
    else if (preview_Mode == "placeholder_shaft")
    {
        shaft_test_offset =
            (wheelShaft_Diameter + 2 * placeholder_Shaft_Clearance) / 2 +
            tt_motor_shaft_test_outer_diameter() / 2 +
            preview_Placeholder_Gap;

        rotate([0, 0, preview_Shaft_Angle])
            tt_motor_shaft_placeholder();
        translate([shaft_test_offset, 0, 0])
            tt_motor_shaft_hole_test(shaft_slot_angle = preview_Shaft_Angle)
                tt_motor_shaft_placeholder();
    }
    else if (preview_Mode == "preview")
        preview_aligned(
            angle = preview_Shaft_Angle,
            show_body = preview_Show_Body,
            show_shaft = preview_Show_Shaft);
    else if (preview_Mode == "preview_with_wheels")
        preview_aligned(
            with_wheels = true,
            angle = preview_Shaft_Angle,
            show_body = preview_Show_Body,
            show_shaft = preview_Show_Shaft);
    else if (preview_Mode == "wheel_only")
        _preview_demo_wheel();
    else if (preview_Mode == "shaft_test")
        tt_motor_shaft_hole_test()
            tt_motor_shaft_placeholder();
    else if (preview_Mode == "both")
    {
        preview_aligned(
            angle = preview_Shaft_Angle,
            show_body = preview_Show_Body,
            show_shaft = preview_Show_Shaft);
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
                "', expected one of: placeholder, placeholder_shaft, preview, preview_with_wheels, wheel_only, shaft_test, both, xor, placeholder_minus_preview, preview_minus_placeholder"));
}

_tt_motor_scene($fn = preview_Fn);
