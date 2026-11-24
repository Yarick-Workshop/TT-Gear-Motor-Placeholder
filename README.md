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

### Wheel Callbacks (`tt_motor_preview` children)

`tt_motor_preview()` accepts `0`, `1`, or `2` OpenSCAD child modules to attach wheels to the dual shaft:

- **0 children** — renders the motor only.
- **1 child** — mounts the child at the `+Z` shaft transition (`z = wheelShaft_Length / 2 - wheelShaft_DD_Length`) and rotates it (`rotate([180, 0, 0])`) onto the `-Z` shaft transition.
- **2 children** — mounts `children(0)` on the `+Z` shaft end and `children(1)` (rotated via `rotate([180, 0, 0])`) on the `-Z` shaft end. To attach a wheel on only one side, pass an empty `union() {}` as the other child.

Each wheel child's local `[0, 0, 0]` is placed where the round shaft meets the DD shaft, with its `+Z` axis pointing outward along the DD shaft, and rotated around `Z` by `shaft_angle`. Note that on the `-Z` side, the gearbox alignment pin (`Y = 22.2` mm, `d = 4` mm, `r ∈ [9.2, 13.2]` mm from the shaft center) protrudes `0.27` mm past the wheel mounting plane (`Z = -11.27` mm vs `-11.0` mm), so flat-backed `-Z` wheels larger than `18.4` mm in diameter should include a `>= 0.3` mm recess at that radius or an outward `+Z` offset:

```openscad
use <TT-Motor-Library.scad>

// Same wheel mirrored on both shaft ends
rotate([0, -90, 0])
    tt_motor_preview(shaft_angle = 45)
        my_wheel();

// Distinct left/right wheels on +Z and -Z shaft ends
rotate([0, -90, 0])
    tt_motor_preview(shaft_angle = 45) {
        wheel_pos_z();
        wheel_neg_z();
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
- `preview_Shaft_Angle` (default `90`, range `0`–`360`) — rotates the wheel shaft and any attached preview wheels in `"preview"`, `"preview_with_wheels"`, and `"both"` modes (placeholder comparison modes keep `shaft_angle = 90`).
- `"both"` (**default**) — draws `tt_motor_preview()` (without wheels) and `tt_motor_placeholder()` side-by-side along world `X`, separated by a calculated offset from the model dimensions, `placeholder_Hole_Length`, `placeholder_Clearance`, and `preview_Placeholder_Gap` (default `10` mm).
- `"placeholder"` — draws only `tt_motor_placeholder()` at the origin.
- `"preview"` — draws only `tt_motor_preview()` at the origin (without wheels).
- `"preview_with_wheels"` — draws `tt_motor_preview()` with an asymmetric spoked demo wheel (with a DD center bore and red 0° indicator spoke) mounted to both shaft ends and rotated by `preview_Shaft_Angle`.
- `"wheel_only"` — draws only the demo wheel at `[0, 0, 0]` without any translations, rotations, or motor geometry.
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
