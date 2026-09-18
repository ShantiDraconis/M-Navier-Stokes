import «audit».Universal8x5

namespace NSAudit8x5
open Audit8x5

def sourceHeadExact : String :=
  "6e17fc115336fef1c30797c2a50806c91567b920"

def frozenS1 : String :=
  "ShantiDraconis/M-Navier-Stokes@c56d9632facf96e0a5d834b987b30df5fe2563a1/Core/G1/ClosedClosedClosedTarget.lean::I_core_closed"

/--
Pre-CI lock state. L7/L8 are intentionally false until the source checkout
build and no-placebo audit succeed.
-/
def locksReviewed : Locks :=
  {
    L1 := true
    L2 := true
    L3 := true
    L4 := true
    L5 := true
    L6 := true
    L7 := false
    L8 := false
  }

/--
Sigma_0 for the exact frozen source. A is not promoted before CI.
Zero means "MATCH not yet certified", not "the mathematical negation is proved".
-/
def sigma0 : Sigma :=
  {
    HC := false
    Q := false
    S := false
    K := false
    A := false
  }

def residues : List Residue :=
  [
    { position := .L5_SEMANTIC_AUDIT, nature := .HC,
      state := .blocking, id := "ActualNS_to_TerminalFlexibleG1" },
    { position := .L5_SEMANTIC_AUDIT, nature := .Q,
      state := .blocking, id := "Concrete_Clay_quantifier_instantiation" },
    { position := .L5_SEMANTIC_AUDIT, nature := .S,
      state := .reviewed, id := "K4_scaling_to_actual_NS_data" },
    { position := .L5_SEMANTIC_AUDIT, nature := .K,
      state := .blocking, id := "Uniform_theta_lt_one_and_integrable_defect" },
    { position := .L8_NO_PLACEBO, nature := .A,
      state := .reviewed, id := "Axiom_and_assumption_laundering_audit" }
  ]

theorem preCI_does_not_emit :
    emitClosedClosedClosed locksReviewed sigma0 = false := by
  rfl

theorem HC_zero_blocks_emission :
    emitClosedClosedClosed locksReviewed sigma0 = false :=
  no_emit_with_HC_zero locksReviewed sigma0 rfl

end NSAudit8x5
