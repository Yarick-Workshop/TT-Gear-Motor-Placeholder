# TT-Gear-Motor-Placeholder
TT Gearmotor placeholder (work in progress)

> **Note:** This model is a visual placeholder only and is not intended for manufacturing use.

## Files

- [TT-Motor-Library.scad](TT-Motor-Library.scad) — main TT gearbox motor model, belt/hook mounting geometry, OpenSCAD Customizer parameters, `tt_motor_preview()`, and `tt_motor_placeholder()`.
- [Motor-130-Library.scad](Motor-130-Library.scad) — 130-size DC motor sub-assembly (`motor130_preview()`), included by `TT-Motor-Library.scad`.

## Usage

Open [TT-Motor-Library.scad](TT-Motor-Library.scad) in OpenSCAD to configure parameters via the **Customizer** (including the **Preview** tab to toggle `tt_motor_preview()`, `tt_motor_placeholder()`, and their side-by-side offset), or include it in your own assemblies with `use <TT-Motor-Library.scad>`:

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

// Cutout placeholder for difference() cavities, pin pocket, and screw holes
difference() {
    cube([30, 80, 30], center = true);
    rotate([0, -90, 0])
        tt_motor_placeholder(hole_length = 100, clearance = 0.5);
}
```

## Placeholder Module (`tt_motor_placeholder`)

`tt_motor_placeholder(origin_lengthwise, origin_heightwise, hole_length = 100, clearance = 0.5)` generates a solid negative-volume placeholder for subtracting motor cavities and mounting holes in `difference()` operations:

- **Main gearbox box** — rectangular cavity covering the main gearbox body.
- **Front mounting lug box** — smaller rectangular cavity covering the front mounting lug.
- **Motor & belt cover box** — rectangular cavity covering the rear motor mounting base, hooks, belt, and 130 DC motor.
- **Side pin placeholder** — cylindrical pocket for the gearbox side alignment pin.
- **Mounting screw cylinders** — three long through-cylinders (`hole_length`, default `100`) for the two rear mounting holes and the front lug mounting hole.

### Parameters

- `origin_lengthwise`, `origin_heightwise` — same alignment options as `tt_motor_preview()` (defaults to `origin_Lengthwise` and `origin_Heightwise`).
- `hole_length` (default `100`) — length of the three mounting-screw cylinders along the local Z axis.
- `clearance` (default `0.5`) — fit tolerance (in mm, applied per side, suited for a 0.5 mm 3D printer nozzle) added to the outer dimensions of the gearbox box, front lug box, motor/belt cover box, and side pin so a physical motor slides into a 3D-printed cavity without binding due to printer tolerances or layer lines. Screw hole diameters remain unchanged (`mountingHole_Diameter`).

## Origin Options

Origin alignment can be configured in the OpenSCAD Customizer under the **Origin** tab (`origin_Lengthwise`, `origin_Heightwise`) or passed directly to `tt_motor_preview(shaft_angle, origin_lengthwise, origin_heightwise)` and `tt_motor_placeholder(origin_lengthwise, origin_heightwise, hole_length, clearance)`. Mode strings are case-sensitive.

### Lengthwise (`origin_Lengthwise` / `origin_lengthwise`)
- `"shaft"` (**default**) — aligns `0` with the center of the wheel shaft.
- `"front"` — aligns `0` with the front face of the **main gearbox body** (note: the front mounting lug still protrudes ahead of `0`).

> **Migration note:** `origin_Lengthwise` now defaults to `"shaft"` instead of `"front"` (previous `master` behavior), moving the default lengthwise origin from the gearbox front to the wheel shaft center. Pass `origin_lengthwise = "front"` (or select **Gearbox front** in the Customizer) to keep the previous alignment.

### Heightwise (`origin_Heightwise` / `origin_heightwise`)
`tt_motor_preview()` shifts along the motor's local `X` axis, which maps to world `Z` under the file's default `rotate([0, -90, 0])`:

- `"shaft"` (**default**) — centers `0` on the wheel shaft (middle of the gearbox height).
- `"top"` — places the gearbox above `0` (on the positive `+X` side locally, or `+Z` under default rotation).
- `"bottom"` — places the gearbox below `0` (on the negative `-X` side locally, or `-Z` under default rotation).
