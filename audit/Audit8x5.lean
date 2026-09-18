namespace Audit8x5

inductive Lock8 where
  | L1_HEAD_EXATO
  | L2_FROZEN_S1
  | L3_ENDPOINT_DEFINITION
  | L4_COMPRESSION
  | L5_SEMANTIC_AUDIT
  | L6_RESIDUE_CLASSIFIER
  | L7_BUILD
  | L8_NO_PLACEBO
  deriving DecidableEq, Repr

inductive Axis5 where
  | HC
  | Q
  | S
  | K
  | A
  deriving DecidableEq, Repr

inductive ResidueClass where
  | raw
  | reviewed
  | certified
  | blocking
  | refuted
  | external
  deriving DecidableEq, Repr

structure Locks where
  L1 : Bool
  L2 : Bool
  L3 : Bool
  L4 : Bool
  L5 : Bool
  L6 : Bool
  L7 : Bool
  L8 : Bool
  deriving Repr

structure Sigma where
  HC : Bool
  Q : Bool
  S : Bool
  K : Bool
  A : Bool
  deriving Repr

structure Residue where
  position : Lock8
  nature : Axis5
  state : ResidueClass
  id : String
  deriving Repr

def locksGreen (L : Locks) : Bool :=
  L.L1 && L.L2 && L.L3 && L.L4 && L.L5 && L.L6 && L.L7 && L.L8

def sigmaMatched (s : Sigma) : Bool :=
  s.HC && s.Q && s.S && s.K && s.A

def emitClosedClosedClosed (L : Locks) (s : Sigma) : Bool :=
  locksGreen L && sigmaMatched s

/-- No semantic mismatch may be hidden by a fully green outer container. -/
theorem no_emit_with_HC_zero
    (L : Locks) (s : Sigma) (h : s.HC = false) :
    emitClosedClosedClosed L s = false := by
  simp [emitClosedClosedClosed, sigmaMatched, h]

theorem no_emit_with_Q_zero
    (L : Locks) (s : Sigma) (h : s.Q = false) :
    emitClosedClosedClosed L s = false := by
  simp [emitClosedClosedClosed, sigmaMatched, h]

theorem no_emit_with_S_zero
    (L : Locks) (s : Sigma) (h : s.S = false) :
    emitClosedClosedClosed L s = false := by
  simp [emitClosedClosedClosed, sigmaMatched, h]

theorem no_emit_with_K_zero
    (L : Locks) (s : Sigma) (h : s.K = false) :
    emitClosedClosedClosed L s = false := by
  simp [emitClosedClosedClosed, sigmaMatched, h]

theorem no_emit_with_A_zero
    (L : Locks) (s : Sigma) (h : s.A = false) :
    emitClosedClosedClosed L s = false := by
  simp [emitClosedClosedClosed, sigmaMatched, h]

end Audit8x5


namespace NSAudit8x5
open Audit8x5

def sourceHeadExact : String :=
  "6e17fc115336fef1c30797c2a50806c91567b920"

def frozenS1 : String :=
  "ShantiDraconis/M-Navier-Stokes@c56d9632facf96e0a5d834b987b30df5fe2563a1/Core/G1/ClosedClosedClosedTarget.lean::I_core_closed"

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
