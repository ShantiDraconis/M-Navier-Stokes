namespace NewRoutes
structure FiniteCascadeBudget where
  State : Type
  budget : State → Nat
  transfer : State → State
  consumes : ∀ s, budget (transfer s) < budget s
structure StretchingCancellationLedger where
  State : Type
  criticalBound : State → Prop
  continuation : State → Prop
  closes : ∀ s, criticalBound s → continuation s
end NewRoutes
