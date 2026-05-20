// Drawings from here: https://grabcad.com/library/dc-3v-6v-tt-motor-1

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
}

color(wheelShaft_Color)
    translate([0, -wheelShaft_Offset])
    {
        cylinder(d = wheelShaft_Diameter, h = wheelShaft_Length, center=true);
    }
