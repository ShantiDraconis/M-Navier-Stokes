/- K4 API probe only. No mathematical conclusion is certified by this file. -/
import G1.K4ExplicitRieszKernel

noncomputable section
open MeasureTheory Metric
open scoped RealInnerProductSpace
namespace G1Audit

#check hasFDerivAt_norm_rpow
#check HasFDerivAt.pow
#check HasFDerivAt.inv
#check HasFDerivAt.mul
#check HasFDerivAt.div
#check ContinuousLinearMap.ext
#check innerSL
#check Measure.measurePreserving_neg
#check Homeomorph.neg
#check norm_smul

end G1Audit
