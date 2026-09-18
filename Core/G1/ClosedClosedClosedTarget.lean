import IMath.Certificates.Core
import G1.MaximalFrontier

noncomputable section

namespace G1Audit.ClosedClosedClosedTarget

open IMath
open G1Audit.MaximalFrontier

/-
CLOSED -> CLOSED -> CLOSED target.

This file is a prize-standard specification, not a substitute for missing
mathematics. The terminal certificate is allowed to exist only after every
middle edge is represented by a concrete theorem.
-/

def ICoreClosed : Prop :=
  Phi3.state (Phi3.I (α := ℂ)) = .indeterminate ∧
  Phi3.idiv (.finite (0 : ℂ)) (.finite 0) = Phi3.I ∧
  Function.Injective ofReal ∧
  Function.Injective ofComplex

theorem I_core_closed : ICoreClosed := by
  exact ⟨
    IMath.Certificates.C01_I_is_indeterminate,
    IMath.Certificates.C06_zero_over_zero_is_I,
    IMath.Certificates.C04_real_embedding_injective,
    IMath.Certificates.C05_complex_embedding_injective
  ⟩

structure PrizePredicates (State : Type) where
  ActualNS : State → Prop
  K4SignedCZ : State → Prop
  TerminalG1 : State → Prop
  UniformEnstrophy : State → Prop
  CriticalL3 : State → Prop
  ESSContinuation : State → Prop
  GlobalRegularity : State → Prop

def MiddleClosureTarget {State : Type} (P : PrizePredicates State) : Prop :=
  (∀ u, P.ActualNS u → P.K4SignedCZ u) ∧
  (∀ u, P.K4SignedCZ u → P.TerminalG1 u) ∧
  (∀ u, P.ActualNS u → P.TerminalG1 u → P.UniformEnstrophy u) ∧
  (∀ u, P.ActualNS u → P.UniformEnstrophy u → P.CriticalL3 u) ∧
  (∀ u, P.ActualNS u → P.CriticalL3 u → P.ESSContinuation u) ∧
  (∀ u, P.ActualNS u → P.ESSContinuation u → P.GlobalRegularity u)

def FinalTarget {State : Type} (P : PrizePredicates State) : Prop :=
  ∀ u, P.ActualNS u → P.GlobalRegularity u

theorem final_of_middle_closed
    {State : Type} (P : PrizePredicates State)
    (hMid : MiddleClosureTarget P) :
    FinalTarget P := by
  rcases hMid with ⟨h01, h12, h23, h34, h45, h56⟩
  intro u hu
  have hK4 : P.K4SignedCZ u := h01 u hu
  have hG1 : P.TerminalG1 u := h12 u hK4
  have hE : P.UniformEnstrophy u := h23 u hu hG1
  have hL3 : P.CriticalL3 u := h34 u hu hE
  have hESS : P.ESSContinuation u := h45 u hu hL3
  exact h56 u hu hESS

def ClosedClosedClosedTarget {State : Type} (P : PrizePredicates State) : Prop :=
  ICoreClosed ∧ MiddleClosureTarget P ∧ FinalTarget P

theorem package_closed_chain
    {State : Type} (P : PrizePredicates State)
    (middle_closed : MiddleClosureTarget P) :
    ClosedClosedClosedTarget P := by
  exact ⟨I_core_closed, middle_closed, final_of_middle_closed P middle_closed⟩

def TARGET_START_STATUS : String := "CLOSED"
def TARGET_MIDDLE_STATUS : String := "MUST_BE_CLOSED_BEFORE_PRIZE_SEAL"
def TARGET_END_STATUS : String := "CLOSED_ONCE_MIDDLE_THEOREMS_EXIST"
def ACCEPT_OPEN_IN_FINAL_CERTIFICATE : Bool := false

#print axioms I_core_closed
#print axioms final_of_middle_closed
#print axioms package_closed_chain

end G1Audit.ClosedClosedClosedTarget
