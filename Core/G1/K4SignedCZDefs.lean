/-
K4 signed-CZ semantic surface.
No new macro-gate. This file only exposes and typechecks the exact objects
already used by the K4 target at predecessor b99786a701fd08dd247d1ef3d7f6e63796b0062e.
-/
import G1.SignedFarField

namespace G1Audit

/-- The current K4 directional observable is physical-space local oscillation.
It is not, by definition, a Littlewood--Paley square function. -/
abbrev K4DirectionalOscillation := directionalOscillation

/-- The exact normalized K4 far-field quantity. -/
abbrev K4FarFieldSqAvg := FarFieldSqAvg

/-- Exact scale domain: 0 < r ≤ rho and 0 < rho. -/
abbrev K4SubcutoffScale := SubcutoffScale

/-- Exact current endpoint target. -/
abbrev K4SignedCZTarget := SignedCZLinearGainTarget

/-- No analytic hypothesis on xi is silently added here.  Any restriction on xi
needed to exclude a counterexample must appear in a later proved theorem. -/
structure K4XiSemanticInput where
  xi : VectorField3

#check directionalOscillation
#check FarFieldSqAvg
#check SubcutoffScale
#check SignedCZLinearGainTarget
#check K4XiSemanticInput
#print axioms SignedCZLinearGainTarget

end G1Audit
