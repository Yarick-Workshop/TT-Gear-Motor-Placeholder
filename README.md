# TT-Gear-Motor-Placeholder

Parametric OpenSCAD model and cutout placeholder for the standard yellow **TT geared DC motor** (work in progress).

Use this library to visualize a TT motor (with optional wheels) inside your robot or mechanism designs, and to subtract properly sized motor cavities, screw holes, and shaft openings from 3D-printed mounts or enclosures.

> **Note:** Dimensions are an approximate reference for fitting a TT motor into your designs—not for manufacturing the motor itself. When 3D-printing enclosures with `tt_motor_placeholder()`, verify fit with a quick test print.

## Files

- [TT-Motor-Library.scad](TT-Motor-Library.scad) — main TT gearbox motor model (`tt_motor_preview()`), cutout placeholders (`tt_motor_placeholder()`, `tt_motor_shaft_placeholder()`), fit tests (`tt_motor_shaft_hole_test()`, `tt_motor_test_enclosure()`), 2D orthographic projections (`tt_motor_projection()`), belt/hook geometry, and OpenSCAD Customizer settings.
- [Motor-130-Library.scad](Motor-130-Library.scad) — 130-size DC motor sub-assembly (`motor130_preview()`, `motor130_body_diameter()`), included automatically by `TT-Motor-Library.scad`.

## Quick Start (`use <TT-Motor-Library.scad>`)

Drop `use <TT-Motor-Library.scad>` into your OpenSCAD file to call `tt_motor_preview()` for visualization and `tt_motor_placeholder()` inside `difference()` blocks for cutouts:

```openscad
use <TT-Motor-Library.scad>
$fn = 64; // Library inherits caller's $fn

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
$fn = 64; // Library inherits caller's $fn

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

// Wheels only (hide gearbox/motor/belt via show_body = false, and optionally hide the shaft via show_shaft = false)
rotate([0, -90, 0])
    tt_motor_preview(shaft_angle = 45, show_body = false, show_shaft = false)
        my_wheel();
```

> **Visibility & seam options (`tt_motor_preview`):** `show_body` and `show_shaft` (both default `preview_Show_Body` / `preview_Show_Shaft` = `true`) toggle the motor body and wheel shaft independently. `show_seam` (default `true`) cuts a cosmetic `0.1` mm groove along `Z = 0` between the gearbox halves; pass `false` for clean silhouettes, 2D projections, or boolean operations.

> **Clearance tip (`-Z` side pin):** The gearbox has an alignment pin on the `-Z` side (`Y = 11.2` mm behind the shaft center / `22.2` mm from the gearbox front, `Ø 4` mm, spanning `9.2`–`13.2` mm from the shaft center) that sticks out `0.27` mm past the `-Z` wheel mounting plane (`Z = -11.27` mm vs `-11.0` mm). If your `-Z` wheel has a flat back larger than `18.4` mm in diameter, recess the back face by at least `0.3` mm outside `Ø 18.4` mm or shift it outward along `+Z`.

## Helper Functions

- `tt_motor_gearbox_height()` — returns `gearBox_Height` (`22.44` mm by default) so callers can derive vertical shaft placement and cavity floor thickness without hard-coding dimensions.
- `wheel_shaft_round_part_length()` — returns the distance from shaft center to the DD shoulder (`wheelShaft_Length / 2 - wheelShaft_DD_Length`, `11` mm by default).
- `tt_motor_shaft_diameter()` — returns `wheelShaft_Diameter` (`5.5` mm by default).
- `tt_motor_shaft_dd_thickness()` — returns `wheelShaft_DD_Thickness` (`3.7` mm by default).
- `tt_motor_shaft_dd_length()` — returns `wheelShaft_DD_Length` (`6` mm by default).
- `tt_motor_shaft_placeholder_round_length(gearbox_clearance = placeholder_Shaft_Gearbox_Clearance)` — returns the round collar length stopping `gearbox_clearance` (`1.0` mm by default) short of the gearbox wall (`0.65` mm with defaults).
- `tt_motor_shaft_test_outer_diameter(hub_diameter = 0, clearance = placeholder_Shaft_Clearance)` — returns a safe outer diameter for `tt_motor_shaft_hole_test()`.

## Shaft Cutouts & Fit Calibration (`tt_motor_shaft_placeholder`, `tt_motor_shaft_hole_test`)

`tt_motor_shaft_placeholder(clearance = placeholder_Shaft_Clearance, dd_length = tt_motor_shaft_dd_length(), round_length = wheel_shaft_round_part_length(), dd_below_length = placeholder_Shaft_DD_Below_Length)` produces a **vertical** negative-volume shaft half for cutting sockets into wheels and hubs (DD flats at `±Y`, curved faces at `±X`): `Z = 0` marks the physical DD shaft tip, the DD section spans `[-dd_below_length, dd_length]` (extending below `Z = 0` by `20` mm by default to cut clean through-DD holes for easy post-print filing; set `dd_below_length = 0` for a blind pocket), and the round collar spans `[dd_length, dd_length + round_length]` (`wheel_shaft_round_part_length() = 11` mm by default). Its default clearance (`placeholder_Shaft_Clearance = 0.1` mm) is separate from the motor housing's `placeholder_Clearance` (`0.5` mm).

`tt_motor_shaft_hole_test(shaft_depth = tt_motor_shaft_dd_length() + tt_motor_shaft_placeholder_round_length(), height = 2 * tt_motor_shaft_dd_length(), outer_diameter = undef, hub_diameter = 0, base_height = 2.0, shaft_slot_angle = 0)` prints a compact calibration puck (`12` mm tall by default = `2 * wheelShaft_DD_Length`) with `shaft_depth = 6.65` mm (`6.0` mm DD + `0.65` mm round collar, leaving `1.0` mm clearance to the gearbox body) for tuning `clearance`. When `outer_diameter` is omitted (`undef`), it defaults to `tt_motor_shaft_test_outer_diameter(hub_diameter = hub_diameter)`. It requires **exactly 1 child** (the cutting placeholder), which must extend at least `shaft_depth` above `Z = 0` (pass `shaft_depth = tt_motor_shaft_dd_length()` when testing `round_length = 0`):

```openscad
use <TT-Motor-Library.scad>
$fn = 64; // Library inherits caller's $fn

// Cut a DD + round lead-in socket into a 12 mm flat-printed wheel/hub (inner face at Z = 12)
difference() {
    cylinder(d = 20, h = 12);
    translate([0, 0, 12 - 6.65])
        tt_motor_shaft_placeholder(clearance = 0.1);
}

// Print a quick DD shaft fit calibration puck
tt_motor_shaft_hole_test(shaft_depth = 6.65, hub_diameter = 11.0)
    tt_motor_shaft_placeholder(clearance = 0.1);
```

> **Flat-printed vs. `tt_motor_preview()` wheel orientation:** `tt_motor_shaft_placeholder()` is oriented for flat-printed wheels (outer wheel face at `Z = 0`, motor-facing hub face at `+Z`), which is `rotate([180, 0, 0])` inverted relative to `tt_motor_preview()`'s outward-facing wheel mounting frame (for the 12 mm wheel above, mount it via `translate([0, 0, 12 - 0.65]) rotate([180, 0, 0]) my_wheel();`).

> **Through-hole vs. blind pocket:** With the default `dd_below_length = 20` mm, `tt_motor_shaft_placeholder()` cuts a through-DD bore all the way out the bottom of the puck, and `shaft_depth` sets how deep the round collar extends from the top face (`shaft_depth - dd_length`, i.e., `0.65` mm by default). Pass `dd_below_length = 0` to `tt_motor_shaft_placeholder()` if you want a blind pocket of exact depth `shaft_depth` with an internal bottom stop.

> **Resolution (`$fn`) note:** `TT-Motor-Library.scad` does not set a global `$fn` when imported via `use <>`; callers control tessellation resolution with their own `$fn`. Standalone preview uses `preview_Fn` (`64` by default).

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

### Fit Test Enclosure (`tt_motor_test_enclosure`)

`tt_motor_test_enclosure(min_wall_thickness = testEnclosure_Min_Wall_Thickness, wheel_cylinder_diameter = testEnclosure_Wheel_Cylinder_Diameter, clearance = placeholder_Clearance, hole_diameter = mountingHole_Diameter, part = "both", assembled = false, gap = preview_Gap, origin_lengthwise = origin_Lengthwise, origin_heightwise = origin_Heightwise)` generates a printable two-half rectangular test enclosure around `tt_motor_placeholder()`, split along `Z = 0` (`-Z` and `+Z` halves):

- `min_wall_thickness` (default `testEnclosure_Min_Wall_Thickness = 2`) — minimum wall thickness (in mm) added around all outer faces of the `tt_motor_placeholder()` bounding box.
- `wheel_cylinder_diameter` (default `testEnclosure_Wheel_Cylinder_Diameter = 12`) — diameter (in mm) of the cylindrical wheel-hub clearance cutout through both side walls around the wheel shaft (`0` disables the extra cylinder, leaving only `tt_motor_placeholder()`'s shaft opening; must leave at least `min_wall_thickness` around the outer enclosure walls).
- `clearance` (default `placeholder_Clearance = 0.5`), `hole_diameter` (default `mountingHole_Diameter = 2.8`) — passed through to `tt_motor_placeholder()`. Both halves use the same `hole_diameter` (`2.8` mm suits self-tapping M3 screws, or pass `3.2`–`3.4` mm for M3 clearance holes with nuts; if self-tapping into one half, drill out the other half to `3.2` mm).
- `part` — `"both"` (default), `"neg_z"`, or `"pos_z"`.
- `assembled` (default `false`) — when `false`, lays both halves flat on `Z = 0` with their cavities facing `+Z` (separated by `gap` along `X`) for support-free printing; when `true`, positions both halves assembled around the motor origin with a `0.1` mm seam gap along `Z`.
- `gap` (default `preview_Gap = 10`) — spacing (in mm) between the two halves along `X` when `assembled = false` and `part = "both"`.
- `origin_lengthwise`, `origin_heightwise` (default `origin_Lengthwise`, `origin_Heightwise`) — validated on every call; applied when `assembled = true` (ignored in the flat `assembled = false` print layout).

### 2D Projections (`tt_motor_projection`)

`tt_motor_projection(view = "both", shaft_angle = 0, origin_lengthwise = origin_Lengthwise, origin_heightwise = origin_Heightwise, gap = preview_Gap, pin_ring_thickness = 0.4)` generates 2D orthographic projections of `tt_motor_preview()` (with the cosmetic `Z = 0` split seam suppressed via `show_seam = false`) onto the `X-Y` plane for inspection or SVG/DXF export:

- **`view = "both"` (default)** — places the side and top projections side-by-side on the same page along `X`, aligned along the lengthwise `Y` axis and separated by `gap`. The 2D coordinate origin `[0, 0]` belongs to the **side** view (`origin_lengthwise` / `origin_heightwise`), while the top view is shifted along `+X` past the side view's right edge (e.g., its shaft center lands at `X = 38.22` mm with defaults). For origin-aligned CAD/SVG/DXF exports, call `view = "side"` and `view = "top"` separately.
- **`view = "side"`** — side profile along the wheel shaft axis showing gearbox and front lug corner roundings, all three mounting holes, the open wheel shaft bore (`show_shaft = false`), belt/hooks/130 motor with its roundings, and the `-Z` gearbox alignment pin marked as an outline ring cutout (`Ø gearBox_Pin_Diameter`, visual alignment marker rather than a physical through-hole).
- **`view = "top"`** — top-down profile (matching `rotate([0, -90, 0])`) showing both wheel shafts, the protruding alignment pin profile, front lug, belt/hooks, and 130 motor.
- **`shaft_angle`** (default `0`) — rotates the wheel shaft in the **top view only** (ignored in `view = "side"` where the shaft is hidden). Keep the default `0` so the DD shaft flats (`±Y`) remain visible in profile.
- **`gap`** (default `preview_Gap = 10`) — non-negative spacing (in mm) between the side and top views when `view = "both"`.
- **`pin_ring_thickness`** (default `0.4`) — radial thickness (in mm) of the side-view alignment pin outline ring; must be positive and strictly less than `gearBox_Pin_Diameter / 2` (when `gearBox_Pin_Diameter > 0` and `gearBox_Pin_Height > 0`).
- **`origin_lengthwise`, `origin_heightwise`** (default `origin_Lengthwise`, `origin_Heightwise`) — `origin_lengthwise` shifts `Y` in both views; `origin_heightwise` shifts `X` in `view = "side"` only and does **not** affect `view = "top"` (the heightwise axis is projected away in the top view).

```openscad
use <TT-Motor-Library.scad>
$fn = 64; // Required for smooth circular holes/roundings in SVG/DXF exports

tt_motor_projection();              // Side & top views side by side
tt_motor_projection(view = "side"); // Origin-aligned side profile only
```

> **Performance note:** `projection()` triggers full CGAL evaluation even during OpenSCAD F5 preview, so rendering `view = "both"` at `$fn = 64` can take ~60–75 s (OpenSCAD 2021.01). Standalone `preview_Mode = "projections"` logs a console `WARNING:` reminder; lower `$fn` / `preview_Fn` or adjust Customizer settings in another mode first.

> **Known artifact (top view):** The top projection currently contains two narrow `~0.95 × 16.5` mm internal slots between the 130-motor body flats (`15.1` mm) and the retaining belt strap's inner width (`17` mm), tracked in [#11](https://github.com/Yarick-Workshop/TT-Gear-Motor-Placeholder/issues/11).

## Origin & Alignment Options

Alignment can be changed in the OpenSCAD Customizer under the **Origin** tab (`origin_Lengthwise`, `origin_Heightwise`) or passed directly to `tt_motor_preview(shaft_angle = 0, origin_lengthwise, origin_heightwise, show_body, show_shaft, show_seam)`, `tt_motor_placeholder(origin_lengthwise, origin_heightwise, hole_length, clearance, hole_diameter)`, `tt_motor_test_enclosure(..., assembled = true, origin_lengthwise, origin_heightwise)`, and `tt_motor_projection(..., origin_lengthwise, origin_heightwise)` (where `origin_heightwise` applies to the side view only). Mode names are case-sensitive.

### Lengthwise (`origin_Lengthwise` / `origin_lengthwise`)
- `"shaft"` (**default**) — places `0` at the center of the wheel shaft.
- `"front"` — places `0` at the front face of the **main gearbox body** (the front mounting lug extends ahead of `0`).

> **Note:** Earlier versions defaulted `origin_Lengthwise` to `"front"`. Pass `origin_lengthwise = "front"` (or select **Gearbox front** in the Customizer) if updating an older design.

### Heightwise (`origin_Heightwise` / `origin_heightwise`)
Shifts `tt_motor_preview()`, `tt_motor_placeholder()`, assembled `tt_motor_test_enclosure()`, and the side view of `tt_motor_projection()` along local `X` (world `Z` when rotated with `rotate([0, -90, 0])`):

- `"shaft"` (**default**) — centers `0` on the wheel shaft (middle of the gearbox height).
- `"top"` — places the gearbox above `0` (`+X` locally, `+Z` under default rotation).
- `"bottom"` — places the gearbox below `0` (`-X` locally, `-Z` under default rotation).

## Customizer & Preview Modes

Open [TT-Motor-Library.scad](TT-Motor-Library.scad) directly in OpenSCAD to tune motor dimensions, clearances, and preview views using the **Customizer** panel:

- **`[Origin]`** — choose default lengthwise and heightwise origins (`origin_Lengthwise`, `origin_Heightwise`).
- **`[Placeholder]`** — set default `placeholder_Hole_Length`, `placeholder_Clearance` (housing), `placeholder_Shaft_Clearance` (wheel shaft socket, default `0.1` mm), `placeholder_Shaft_DD_Below_Length` (DD through-hole extension below `Z = 0`, default `20` mm), and `placeholder_Shaft_Gearbox_Clearance` (margin kept between the round shaft collar and the gearbox body, default `1.0` mm).
- **`[Test Enclosure]`** — set `testEnclosure_Min_Wall_Thickness` (default `2` mm) and `testEnclosure_Wheel_Cylinder_Diameter` (default `12` mm).
- **`[Preview]`** — set `preview_Gap` (default `10` mm — spacing used by side-by-side preview modes and default `gap` for `tt_motor_test_enclosure()` and `tt_motor_projection()`), `preview_Shaft_Angle` (`0`–`360`, default `90` — rotates the wheel shaft and demo wheels in `"preview"`, `"preview_with_wheels"`, and `"both"`, and rotates the cutting shaft placeholder and calibration puck slot in `"placeholder_shaft"`; comparison modes keep `shaft_angle = 90`, while `"shaft_test"` and `"projections"` keep `shaft_angle = 0` / `shaft_slot_angle = 0`), `preview_Show_Body` and `preview_Show_Shaft` (both default `true` — toggle body/shaft visibility in `"preview"`, `"preview_with_wheels"`, and `"both"`, and serve as defaults for `tt_motor_preview()`; comparison modes always render both), `preview_Fn` (default `64` — standalone preview resolution), and `preview_Mode`:
  - `"both"` (**default**, *Motor & Cutout*) — shows `tt_motor_preview()` (shaft rotated by `preview_Shaft_Angle`) and `tt_motor_placeholder()` side by side, separated by `preview_Gap`.
  - `"preview"` (*View - Motor*) — shows only the motor model (`tt_motor_preview()`) with its wheel shaft rotated by `preview_Shaft_Angle`.
  - `"preview_with_wheels"` (*View - Motor + Wheels*) — shows the motor with a spoked demo wheel (DD bore + red `0°` indicator spoke) mounted on both shaft ends, with the shaft and wheels rotated by `preview_Shaft_Angle`.
  - `"wheel_only"` (*View - Demo Wheel*) — shows only the demo wheel at `[0, 0, 0]` for quick inspection.
  - `"test_enclosure_assembled"` (*View - Test Box (assembled)*) — shows the two-half test enclosure (`tt_motor_test_enclosure(assembled = true)`) assembled around the motor origin with a `0.1` mm seam gap.
  - `"projections"` (*2D - Projections (Side & Top)*) — shows both 2D orthographic projections (`tt_motor_projection(view = "both", shaft_angle = 0)`) side-by-side on the same page: side view (holes, roundings, motor, and alignment pin outline ring) and top view (dual DD shafts with flat step-down visible, alignment pin profile, belt, and motor). **Slow (~1 min at `preview_Fn = 64`)** because `projection()` forces full CGAL rendering even in F5 preview; logs a console warning when selected.
  - `"placeholder"` (*Cutout - Motor*) — shows only the negative-volume cutout (`tt_motor_placeholder()`).
  - `"placeholder_shaft"` (*Cutout - Shaft & Puck*) — shows both the vertical cutting shaft placeholder (`tt_motor_shaft_placeholder()`) and the shaft fit calibration puck (`tt_motor_shaft_hole_test()`) side by side, separated by `preview_Gap`.
  - `"test_enclosure"` (*Print - Test Box (flat)*) — shows the two-half printable test enclosure (`tt_motor_test_enclosure(assembled = false)`) laid flat side-by-side for support-free printing.
  - `"shaft_test"` (*Print - Shaft Fit*) — shows only the printable DD shaft fit calibration puck (`tt_motor_shaft_hole_test()` cut by `tt_motor_shaft_placeholder()`).
  - `"placeholder_minus_preview"` (*Check - Clearance Gap*) — subtracts the motor model from the cutout volume to inspect clearance space around the motor.
  - `"preview_minus_placeholder"` (*Check - Protrusions*) — subtracts the cutout volume from the motor model to verify nothing sticks out (empty with default dimensions when `clearance >= 0`).
  - `"xor"` (*Check - Fit Diff (XOR)*) — shows the symmetric difference between preview and placeholder at the same origin.
