import G1.MaximalFrontier

noncomputable section
namespace G1Audit.MaximalFrontier

/-- Fixed nondegenerate subcutoff scale used only by semantic negative controls. -/
def abUnitScale : G1Audit.SubcutoffScale := {
  r := 1
  rho := 1
  hr := by norm_num
  hrho := by norm_num
  hr_le_rho := by norm_num
}

/-- Negative control A: the bare abstract types do not manufacture
`ActualNS -> SignedCZLinearGainTarget`. This is a countermodel to automatic
interface closure, not a counterexample to Navier--Stokes. -/
theorem abstract_A_requires_additional_hypotheses :
    ¬ ActualNSToK4Target
      (State := Unit)
      (fun _ => True)
      (fun _ => (1 : ℝ))
      (fun _ => (0 : ℝ))
      (fun _ => (0 : ℝ))
      (fun _ => abUnitScale) := by
  intro h
  have ht := h () True.intro
  norm_num [G1Audit.SignedCZLinearGainTarget,
    G1Audit.SubcutoffScale.ratio, abUnitScale] at ht

/-- A statewise constant can absorb an unbounded family state-by-state. -/
def abNatFarField (n : Nat) : ℝ := n

def abNatStatewiseCfar (n : Nat) : ℝ := n

theorem statewise_cfar_target_holds :
    ActualNSToK4Target
      (State := Nat)
      (fun _ => True)
      abNatFarField
      abNatStatewiseCfar
      (fun _ => (1 : ℝ))
      (fun _ => abUnitScale) := by
  intro n _
  simp [G1Audit.SignedCZLinearGainTarget,
    G1Audit.SubcutoffScale.ratio, abUnitScale,
    abNatFarField, abNatStatewiseCfar]

/-- Uniform version of the same toy family: one global Cfar must work for every state. -/
def UniformCfarNatTarget : Prop :=
  ∃ Cfar : ℝ, ∀ n : Nat,
    G1Audit.SignedCZLinearGainTarget
      (abNatFarField n) Cfar 1 abUnitScale

/-- Quantifier/constant firewall: statewise Cfar does not imply one global Cfar. -/
theorem no_uniform_cfar_for_nat_family :
    ¬ UniformCfarNatTarget := by
  rintro ⟨Cfar, hCfar⟩
  obtain ⟨n, hn⟩ := exists_nat_gt Cfar
  have ht := hCfar n
  have hle : (n : ℝ) ≤ Cfar := by
    simpa [G1Audit.SignedCZLinearGainTarget,
      G1Audit.SubcutoffScale.ratio, abUnitScale,
      abNatFarField] using ht
  exact (not_le_of_gt hn) hle

theorem statewise_cfar_not_uniform :
    ActualNSToK4Target
      (State := Nat)
      (fun _ => True)
      abNatFarField
      abNatStatewiseCfar
      (fun _ => (1 : ℝ))
      (fun _ => abUnitScale) ∧
    ¬ UniformCfarNatTarget := by
  exact ⟨statewise_cfar_target_holds, no_uniform_cfar_for_nat_family⟩

/-- Minimal trajectory used to show that the bare K4 target cannot manufacture
terminal G1 without an actual bridge. -/
def abZeroTrajectory : TrajectoryData := {
  y := fun _ => 0
  z := fun _ => 0
  stretch := fun _ => 0
  nu := 1
  hnu := by norm_num
  hy := by intro t; norm_num
  hz := by intro t; norm_num
}

theorem terminalFlexibleG1_at_zero_time_false :
    ¬ TerminalFlexibleG1 0 abZeroTrajectory := by
  intro h
  rcases h with ⟨t0, theta, a, ht00, ht0T, htheta0, htheta1, ha, hs⟩
  linarith

theorem zero_signedCZ_target_true :
    G1Audit.SignedCZLinearGainTarget 0 0 0 abUnitScale := by
  norm_num [G1Audit.SignedCZLinearGainTarget,
    G1Audit.SubcutoffScale.ratio, abUnitScale]

/-- Negative control B: a true abstract SignedCZ target does not, from the bare
interface alone, imply TerminalFlexibleG1. -/
theorem abstract_B_requires_additional_hypotheses :
    ¬ K4TargetToTerminalFlexibleG1
      (State := Unit)
      (fun _ => (0 : ℝ))
      (fun _ => abZeroTrajectory)
      (fun _ => (0 : ℝ))
      (fun _ => (0 : ℝ))
      (fun _ => (0 : ℝ))
      (fun _ => abUnitScale) := by
  intro h
  have hg1 := h () zero_signedCZ_target_true
  exact terminalFlexibleG1_at_zero_time_false hg1

def AB_SEMANTIC_FIREWALL_STATUS : String :=
  "BARE_INTERFACES_REQUIRE_ADDITIONAL_HYPOTHESES"

def CFAR_QUANTIFIER_STATUS : String :=
  "STATEWISE_DOES_NOT_IMPLY_UNIFORM_GLOBAL_CONSTANT"

def ACTUAL_NS_STATUS_AFTER_AB_AUDIT : String :=
  "OPEN_BRIDGE_PENDING_CONCRETE_CLAY_INSTANTIATION"

#print axioms abstract_A_requires_additional_hypotheses
#print axioms statewise_cfar_target_holds
#print axioms no_uniform_cfar_for_nat_family
#print axioms abstract_B_requires_additional_hypotheses

end G1Audit.MaximalFrontier
