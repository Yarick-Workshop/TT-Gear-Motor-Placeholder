# TT-Gear-Motor-Placeholder
TT Gearmotor placeholder (work in progress)

> **Note:** This model is an approximate reference placeholder and is not intended for manufacturing the motor itself; when using `tt_motor_placeholder()` for 3D-printed enclosures, verify fit with a test print.

## Files

- [TT-Motor-Library.scad](TT-Motor-Library.scad) — main TT gearbox motor model, belt/hook mounting geometry, OpenSCAD Customizer parameters, `tt_motor_preview()`, and `tt_motor_placeholder()`.
- [Motor-130-Library.scad](Motor-130-Library.scad) — 130-size DC motor sub-assembly (`motor130_preview()`), included by `TT-Motor-Library.scad`.

## Usage

Open [TT-Motor-Library.scad](TT-Motor-Library.scad) in OpenSCAD to configure parameters via the **Customizer** (including the **Placeholder** tab for `placeholder_Hole_Length` / `placeholder_Clearance` and the **Preview** tab's `preview_Mode` dropdown and `preview_Placeholder_Gap`), or include it in your own assemblies with `use <TT-Motor-Library.scad>`:

```openscad
use <TT-Motor-Library.scad>

// Default: centered on the wheel shaft both lengthwise and heightwise
rotate([0, -90, 0])
    tt_motor_preview(shaft_angle = 90);

// Custom alignment: main gearbox front at 0, gearbox on the +X (world +Z) side
rotate([0, -90, 0])
    tt_motor_preview(
        shaft_angle = 90,
        origin_lengthwise = "front",
        origin_heightwise = "top");

// Cutout placeholder for difference() cavities, pin pocket, screw holes, and wheel shaft opening
difference() {
    cube([30, 80, 30], center = true);
    rotate([0, -90, 0])
        tt_motor_placeholder(hole_length = 100, clearance = 0.5);
}
```

## Placeholder Module (`tt_motor_placeholder`)

`tt_motor_placeholder(origin_lengthwise, origin_heightwise, hole_length = 100, clearance = 0.5, hole_diameter = 2.8)` generates a solid negative-volume placeholder for subtracting motor cavities and mounting holes in `difference()` operations:

- **Main gearbox box** — rectangular cavity covering the main gearbox body.
- **Front mounting lug box** — smaller rectangular cavity covering the front mounting lug.
- **Motor & belt cover box** — rectangular cavity covering the rear motor mounting base, hooks, belt, and 130 DC motor.
- **Side pin placeholder** — cylindrical pocket for the gearbox side alignment pin.
- **Mounting screw cylinders** — three long through-cylinders (`hole_length`, default `100`) for the two rear mounting holes and the front lug mounting hole.
- **Wheel shaft pass-through cylinder** — long cylinder (`hole_length`, default `100`) centered at the wheel shaft (`wheelShaft_Offset`) for cutting shaft openings through housing walls.

### Parameters

- `origin_lengthwise`, `origin_heightwise` — same alignment options as `tt_motor_preview()` (defaults to `origin_Lengthwise` and `origin_Heightwise`).
- `hole_length` (default `placeholder_Hole_Length = 100`) — total centered length (`±hole_length / 2` from local `Z = 0`) of the three mounting-screw cylinders and the wheel shaft cylinder along the local `Z` axis. Must exceed `gearBox_Width + 2 * clearance` (`19.7` mm with defaults) for the rear screw holes and shaft opening to extend beyond the gearbox cavity, and `>= wheelShaft_Length` (`34` mm) to enclose the entire wheel shaft.
- `clearance` (default `placeholder_Clearance = 0.5`) — fit tolerance (in mm, applied per side, suited for a 0.5 mm 3D printer nozzle) added to the outer dimensions of the gearbox box, front lug box, motor/belt cover box, side pin, and wheel shaft cylinder (`wheelShaft_Diameter + 2 * clearance`) so a physical motor slides into a 3D-printed cavity and the shaft spins freely without binding due to printer tolerances or layer lines.
- `hole_diameter` (default `mountingHole_Diameter = 2.8`) — diameter of the three mounting screw cylinders (`2.8` mm is suited for self-tapping M3 screws in plastic; pass e.g. `3.2`–`3.4` for M3 clearance holes).

### Preview Modes (`preview_Mode`)

Under the **Preview** tab in the Customizer:
- `"both"` (**default**) — draws `tt_motor_preview()` and `tt_motor_placeholder()` side-by-side along world `X`, separated by a calculated offset from the model dimensions, `placeholder_Hole_Length`, `placeholder_Clearance`, and `preview_Placeholder_Gap` (default `10` mm).
- `"placeholder"` — draws only `tt_motor_placeholder()` at the origin.
- `"preview"` — draws only `tt_motor_preview()` at the origin.
- `"xor"` — symmetric difference of both modules at the same origin.
- `"placeholder_minus_preview"` — subtracts `tt_motor_preview()` from `tt_motor_placeholder()` at the same origin.
- `"preview_minus_placeholder"` — subtracts `tt_motor_placeholder()` from `tt_motor_preview()` at the same origin (to check for geometry protruding outside the placeholder; with default motor dimensions, when `hole_length >= wheelShaft_Length` and `clearance >= 0`, all preview geometry is enclosed).

## Origin Options

Origin alignment can be configured in the OpenSCAD Customizer under the **Origin** tab (`origin_Lengthwise`, `origin_Heightwise`) or passed directly to `tt_motor_preview(shaft_angle, origin_lengthwise, origin_heightwise)` and `tt_motor_placeholder(origin_lengthwise, origin_heightwise, hole_length, clearance, hole_diameter)`. Mode strings are case-sensitive.

### Lengthwise (`origin_Lengthwise` / `origin_lengthwise`)
- `"shaft"` (**default**) — aligns `0` with the center of the wheel shaft.
- `"front"` — aligns `0` with the front face of the **main gearbox body** (note: the front mounting lug still protrudes ahead of `0`).

> **Migration note:** `origin_Lengthwise` now defaults to `"shaft"` instead of `"front"` (previous `master` behavior), moving the default lengthwise origin from the gearbox front to the wheel shaft center. Pass `origin_lengthwise = "front"` (or select **Gearbox front** in the Customizer) to keep the previous alignment.

### Heightwise (`origin_Heightwise` / `origin_heightwise`)
Both `tt_motor_preview()` and `tt_motor_placeholder()` shift along the motor's local `X` axis, which maps to world `Z` under the file's default `rotate([0, -90, 0])`:

- `"shaft"` (**default**) — centers `0` on the wheel shaft (middle of the gearbox height).
- `"top"` — places the gearbox above `0` (on the positive `+X` side locally, or `+Z` under default rotation).
- `"bottom"` — places the gearbox below `0` (on the negative `-X` side locally, or `-Z` under default rotation).
