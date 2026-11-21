# TT-Gear-Motor-Placeholder
TT Gearmotor placeholder (work in progress)

> **Note:** This model is a visual placeholder only and is not intended for manufacturing use.

## Files

- [TT-Motor-Library.scad](TT-Motor-Library.scad) — main TT gearbox motor model, belt/hook mounting geometry, OpenSCAD Customizer parameters, and `tt_motor_preview()`.
- [Motor-130-Library.scad](Motor-130-Library.scad) — 130-size DC motor sub-assembly (`motor130_preview()`), included by `TT-Motor-Library.scad`.

## Usage

Open [TT-Motor-Library.scad](TT-Motor-Library.scad) in OpenSCAD to configure parameters via the **Customizer**, or include it in your own assemblies with `use <TT-Motor-Library.scad>`:

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
```

## Origin Options

Origin alignment can be configured in the OpenSCAD Customizer under the **Origin** tab (`origin_Lengthwise`, `origin_Heightwise`) or passed directly to `tt_motor_preview(shaft_angle, origin_lengthwise, origin_heightwise)`. Mode strings are case-sensitive.

### Lengthwise (`origin_Lengthwise` / `origin_lengthwise`)
- `"shaft"` (**default**) — aligns `0` with the center of the wheel shaft.
- `"front"` — aligns `0` with the front face of the **main gearbox body** (note: the front mounting lug still protrudes ahead of `0`).

> **Migration note:** `origin_Lengthwise` now defaults to `"shaft"` instead of `"front"` (previous `master` behavior), moving the default lengthwise origin from the gearbox front to the wheel shaft center. Pass `origin_lengthwise = "front"` (or select **Gearbox front** in the Customizer) to keep the previous alignment.

### Heightwise (`origin_Heightwise` / `origin_heightwise`)
`tt_motor_preview()` shifts along the motor's local `X` axis, which maps to world `Z` under the file's default `rotate([0, -90, 0])`:

- `"shaft"` (**default**) — centers `0` on the wheel shaft (middle of the gearbox height).
- `"top"` — places the gearbox above `0` (on the positive `+X` side locally, or `+Z` under default rotation).
- `"bottom"` — places the gearbox below `0` (on the negative `-X` side locally, or `-Z` under default rotation).
