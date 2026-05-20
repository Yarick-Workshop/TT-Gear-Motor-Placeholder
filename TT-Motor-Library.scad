// Drawings from here: https://grabcad.com/library/dc-3v-6v-tt-motor-1

$fn = 64;// TODO, play with it, investigate the artefacts!

/* [Gear Box] */
gearBox_Length = 37;//??? measuere
gearBox_Height = 22.44;
gearBox_Width = 18.7;
corner_radius = 3;

/* [Wheel Shaft] */
wheelShaft_Color = "white";//TODO
wheelShaft_Length = 34;//??? measuere
wheelShaft_Diameter = 5.5;
wheelShaft_Offset = 11.0;

module rounded_square_extruded(
    sx = gearBox_Height,
    sy = gearBox_Length,
    h = gearBox_Width,
    r = corner_radius
) {
    r_eff = min(r, sx / 2 - 0.01, sy / 2 - 0.01);

    linear_extrude(height = h, center = true)
    translate([-sx / 2, -sy])
    union() {
        square([sx, sy - r_eff]);
        translate([r_eff, sy - r_eff]) square([sx - 2 * r_eff, r_eff]);
        translate([r_eff, sy - r_eff]) circle(r = r_eff);
        translate([sx - r_eff, sy - r_eff]) circle(r = r_eff);
    }
}

difference()
{
	rounded_square_extruded();
	translate([0, -31.1])
	{
		translate([17.5/2, 0])
			cylinder(d = 2.8, h = 34, center=true);
		translate([-17.5/2, 0])
			cylinder(d = 2.8, h = 34, center=true);
	}
}

color(wheelShaft_Color)
    translate([0, -wheelShaft_Offset])
    {
        cylinder(d = wheelShaft_Diameter, h = wheelShaft_Length, center=true);
    }
