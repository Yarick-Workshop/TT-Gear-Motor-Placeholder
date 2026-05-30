/*
Drawing source:
    - https://www.makerstore.com.au/product/elec-130motor-dc6v/
*/

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
