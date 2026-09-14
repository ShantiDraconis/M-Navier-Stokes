/-
A2/TestA2-1.lean

Isolated harness for issue #28 (A2.1 weightedIBP_est).

Baseline certificate:
  SHA 79140147ba92fe290b4178f92ff7d77ec3271198
  run 34794423292 SUCCESS

This file deliberately does NOT promote A2.  It imports only the already
certified weak-diffusion and localized XiEps layers, reuses the real Bochner
pairing and ENNReal.toReal ball-volume convention from step 21, and exposes the
remaining analytic obligations explicitly.
-/

import G1.WeakDiffusionIBP
import G1.XiEpsLocalizedRealization

noncomputable section

open MeasureTheory Metric

namespace G1Audit

/-- Check that the step-21 ball volume is the real-valued ENNReal conversion. -/
theorem testA2_1_ballVolume_toReal (r : ℝ) (c : Vec3) :
    ballVolume r c = (volume (Metric.ball c r)).toReal := by
  rfl

/-- Check that the localized pairing is genuinely real-valued. -/
theorem testA2_1_bochnerPair_real (v w : VectorField) :
    bochnerPair v w = spatialIntegralScalar (fun x => inner ℝ (v x) (w x)) := by
  rfl

/-- Existing pointwise bound needed in the heavy weighted test construction. -/
theorem testA2_1_xi_bound
    (omega : VectorField) (eps : ℝ) (heps : 0 < eps) (x : Vec3) :
    ‖xiEps omega eps x‖ ≤ 1 := by
  exact xiEps_norm_le_one omega eps heps x

/--
The four analytic obligations that must be realized by actual Sobolev theorems
before issue #28 can close.  They are data to be proved by the next lemmas, not
an A2 certificate and not a substitute for weightedIBP_est.
-/
structure TestA2WeightedIBPObligations where
  etaAdmissibleH10 : Prop
  weakMagnitudeChainRule : Prop
  weightedXiGradientIdentity : Prop
  weightedProductRule : Prop

/--
The exact component-level algebraic endpoint already certified in step 19.
The heavy work for A2.1 is to construct `WeightedDualityInterface` from the
Sobolev obligations above rather than assume it.
-/
theorem testA2_1_existing_component_endpoint
    (d : WeightedDualityComponent)
    (h : WeightedDualityInterface d) :
    d.lapPair = -d.bulk - d.cutoffCross - d.weightCross := by
  exact weightedIBP_component d h

/--
Issue #28 target shape.  This declaration is intentionally only a predicate on
concrete data; closing A2.1 requires proving an instance of it from weak/Sobolev
hypotheses, not assuming it as a structure field.
-/
def WeightedIBPEstTarget (d : WeightedDualityComponent) : Prop :=
  d.lapPair = -d.bulk - d.cutoffCross - d.weightCross

/-- Sanity check that the target matches the certified component identity. -/
theorem testA2_1_target_of_interface
    (d : WeightedDualityComponent)
    (h : WeightedDualityInterface d) :
    WeightedIBPEstTarget d := by
  exact weightedIBP_component d h

end G1Audit