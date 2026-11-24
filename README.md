# TT-Gear-Motor-Placeholder

Parametric OpenSCAD model and cutout placeholder for the standard yellow **TT geared DC motor** (work in progress).

Use this library to visualize a TT motor (with optional wheels) inside your robot or mechanism designs, and to subtract properly sized motor cavities, screw holes, and shaft openings from 3D-printed mounts or enclosures.

> **Note:** Dimensions are an approximate reference for fitting a TT motor into your designs—not for manufacturing the motor itself. When 3D-printing enclosures with `tt_motor_placeholder()`, verify fit with a quick test print.

## Files

- [TT-Motor-Library.scad](TT-Motor-Library.scad) — main TT gearbox motor model (`tt_motor_preview()`), cutout placeholder (`tt_motor_placeholder()`), belt/hook geometry, and OpenSCAD Customizer settings.
- [Motor-130-Library.scad](Motor-130-Library.scad) — 130-size DC motor sub-assembly (`motor130_preview()`), included automatically by `TT-Motor-Library.scad`.

## Quick Start (`use <TT-Motor-Library.scad>`)

Drop `use <TT-Motor-Library.scad>` into your OpenSCAD file to call `tt_motor_preview()` for visualization and `tt_motor_placeholder()` inside `difference()` blocks for cutouts:

```openscad
use <TT-Motor-Library.scad>

// Default motor preview (centered on the wheel shaft)
rotate([0, -90, 0])
    tt_motor_preview(shaft_angle = 90);

// Custom alignment: gearbox front at 0, gearbox above the Z = 0 plane
rotate([0, -90, 0])
    tt_motor_preview(
        shaft_angle = 90,
        origin_lengthwise = "front",
        origin_heightwise = "top");

// Subtract a motor cavity, alignment pin pocket, screw holes, and shaft opening
difference() {
    cube([30, 80, 30], center = true);
    rotate([0, -90, 0])
        tt_motor_placeholder(hole_length = 100, clearance = 0.5);
}
```

> **Orientation tip:** In the library's local coordinates, the dual wheel shaft runs along `Z`, the motor length runs along `+Y`, and the gearbox height runs along `X`. Wrapping calls in `rotate([0, -90, 0])` stands the motor upright in world coordinates (wheel shaft along `X`, height along `Z`), matching the standalone file preview.

## Attaching Wheels (`tt_motor_preview`)

You can pass `0`, `1`, or `2` child modules to `tt_motor_preview()` to preview your own wheels on the dual DD output shaft:

- **0 children** — renders the motor only.
- **1 child** — mounts the same wheel on both shaft ends (`+Z` side as given, `-Z` side rotated 180° via `rotate([180, 0, 0])`).
- **2 children** — mounts the first child on the `+Z` shaft end and the second child (rotated via `rotate([180, 0, 0])`) on the `-Z` shaft end. To mount a wheel on one side only, pass an empty `union() {}` for the other child.

When designing a wheel module, place its local `[0, 0, 0]` where the round shaft steps down to the flat DD section (`wheelShaft_Length / 2 - wheelShaft_DD_Length`, `11` mm from center with defaults), with `+Z` pointing outward away from the gearbox and the DD flat faces at `±Y` (flat-to-flat thickness along `Y`, curved sides along `X`). Both wheels rotate rigidly with the shaft around the motor's `Z` axis by `shaft_angle`:

```openscad
use <TT-Motor-Library.scad>

// Same wheel mounted on both shaft ends
rotate([0, -90, 0])
    tt_motor_preview(shaft_angle = 45)
        my_wheel();

// Distinct left/right wheels on the +Z and -Z shaft ends
rotate([0, -90, 0])
    tt_motor_preview(shaft_angle = 45) {
        wheel_pos_z();
        wheel_neg_z();
    }
```

> **Clearance tip (`-Z` side pin):** The gearbox has an alignment pin on the `-Z` side (`Y = 11.2` mm behind the shaft center / `22.2` mm from the gearbox front, `Ø 4` mm, spanning `9.2`–`13.2` mm from the shaft center) that sticks out `0.27` mm past the `-Z` wheel mounting plane (`Z = -11.27` mm vs `-11.0` mm). If your `-Z` wheel has a flat back larger than `18.4` mm in diameter, recess the back face by at least `0.3` mm outside `Ø 18.4` mm or shift it outward along `+Z`.

## Enclosure Cutouts (`tt_motor_placeholder`)

`tt_motor_placeholder(origin_lengthwise, origin_heightwise, hole_length = 100, clearance = 0.5, hole_diameter = 2.8)` produces a solid negative volume to subtract from housings, brackets, and chassis plates:

- **Main gearbox cavity** — rectangular block covering the yellow gearbox body.
- **Front mounting lug cavity** — smaller rectangular block covering the front tab.
- **Motor & belt cover cavity** — rectangular block enclosing the rear mounting base, belt hooks, retaining belt, and 130 DC motor.
- **Side alignment pin pocket** — cylindrical recess for the gearbox side pin.
- **Mounting screw holes** — three long through-cylinders (`hole_length`, default `100` mm) for the two rear mounting holes and the front lug hole.
- **Wheel shaft pass-through** — long cylinder (`hole_length`, default `100` mm) centered on the wheel shaft (`wheelShaft_Offset`) for cutting axle holes through walls.

### Parameters

- `origin_lengthwise`, `origin_heightwise` — align the motor relative to `[0, 0, 0]` (defaults to `origin_Lengthwise` and `origin_Heightwise` from the Customizer).
- `hole_length` (default `placeholder_Hole_Length = 100`) — total length of the screw and wheel-shaft cylinders along local `Z`, centered at `Z = 0` (`±hole_length / 2`). Make sure it exceeds `gearBox_Width + 2 * clearance` (`19.7` mm with defaults) so the screw holes cut through outer walls, and `>= wheelShaft_Length` (`34` mm) to clear the full shaft.
- `clearance` (default `placeholder_Clearance = 0.5`) — per-side fit margin (in mm) added to the gearbox, front lug, motor/belt cover, side pin, and wheel shaft opening (`wheelShaft_Diameter + 2 * clearance`) so a real motor slides into a 3D-printed pocket and the axle spins freely without rubbing.
- `hole_diameter` (default `mountingHole_Diameter = 2.8`) — diameter of the three mounting screw cylinders (`2.8` mm suits self-tapping M3 screws in plastic; pass e.g. `3.2`–`3.4` mm for M3 clearance holes).

## Origin & Alignment Options

Alignment can be changed in the OpenSCAD Customizer under the **Origin** tab (`origin_Lengthwise`, `origin_Heightwise`) or passed directly to `tt_motor_preview(shaft_angle = 0, origin_lengthwise, origin_heightwise)` and `tt_motor_placeholder(origin_lengthwise, origin_heightwise, hole_length, clearance, hole_diameter)`. Mode names are case-sensitive.

### Lengthwise (`origin_Lengthwise` / `origin_lengthwise`)
- `"shaft"` (**default**) — places `0` at the center of the wheel shaft.
- `"front"` — places `0` at the front face of the **main gearbox body** (the front mounting lug extends ahead of `0`).

> **Note:** Earlier versions defaulted `origin_Lengthwise` to `"front"`. Pass `origin_lengthwise = "front"` (or select **Gearbox front** in the Customizer) if updating an older design.

### Heightwise (`origin_Heightwise` / `origin_heightwise`)
Shifts both `tt_motor_preview()` and `tt_motor_placeholder()` along local `X` (world `Z` when rotated with `rotate([0, -90, 0])`):

- `"shaft"` (**default**) — centers `0` on the wheel shaft (middle of the gearbox height).
- `"top"` — places the gearbox above `0` (`+X` locally, `+Z` under default rotation).
- `"bottom"` — places the gearbox below `0` (`-X` locally, `-Z` under default rotation).

## Customizer & Preview Modes

Open [TT-Motor-Library.scad](TT-Motor-Library.scad) directly in OpenSCAD to tune motor dimensions, clearances, and preview views using the **Customizer** panel:

- **`[Origin]`** — choose default lengthwise and heightwise origins (`origin_Lengthwise`, `origin_Heightwise`).
- **`[Placeholder]`** — set default `placeholder_Hole_Length` and `placeholder_Clearance`.
- **`[Preview]`** — set `preview_Placeholder_Gap` (default `10` mm), `preview_Shaft_Angle` (`0`–`360`, default `90` — rotates the wheel shaft and demo wheels in `"preview"`, `"preview_with_wheels"`, and `"both"`; comparison modes keep `shaft_angle = 90`), and `preview_Mode`:
  - `"both"` (**default**) — shows `tt_motor_preview()` (shaft rotated by `preview_Shaft_Angle`) and `tt_motor_placeholder()` side by side, separated by `preview_Placeholder_Gap`.
  - `"preview"` — shows only the motor model (`tt_motor_preview()`) with its wheel shaft rotated by `preview_Shaft_Angle`.
  - `"preview_with_wheels"` — shows the motor with a spoked demo wheel (DD bore + red `0°` indicator spoke) mounted on both shaft ends, with the shaft and wheels rotated by `preview_Shaft_Angle`.
  - `"wheel_only"` — shows only the demo wheel at `[0, 0, 0]` for quick inspection.
  - `"placeholder"` — shows only the negative-volume cutout (`tt_motor_placeholder()`).
  - `"xor"` — shows the symmetric difference between preview and placeholder at the same origin.
  - `"placeholder_minus_preview"` — subtracts the motor model from the cutout volume to inspect clearance space around the motor.
  - `"preview_minus_placeholder"` — subtracts the cutout volume from the motor model to verify nothing sticks out (empty with default dimensions when `clearance >= 0`).
