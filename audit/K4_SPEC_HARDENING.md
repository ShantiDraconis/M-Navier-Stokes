# K4 specification hardening — MCCS v2

Successor of `5ed0897476ab490b35632f1853a465af83f78ceb`. No frozen predecessor is mutated.

## Fingerprint budget
Only two K4 fingerprints remain:

- **FP-K4-A** — actual signed kernel/cancellation/coherence chain.
- **FP-K4-B** — actual normalized square average/dyadic/uniform endpoint chain.

No sub-obligation below is promoted to an independent gate.

## Preventive corrections

1. `gradKernel` can no longer be unrelated analytic data: `grad_is_derivative` ties it to the actual `Kdata.kernel` through `HasFDerivAt` away from the origin.
2. The former auxiliary `angularKernel` was removed. Cancellation is now stated for the **actual kernel** on concrete annuli. This avoids silently equating an arbitrary angular function with the strain kernel. A future sphere specialization may replace this only with a proved equivalence.
3. `PositiveBallVolume` was removed. `FarFieldSqAvg` uses the already-established `ballVolume r center = (volume (Metric.ball center r)).toReal`; callers cannot choose an arbitrary normalizer.
4. The coherence structure no longer stores an arbitrary `oscillation`; it bounds the concrete `directionalOscillation xi x r`.
5. The dyadic structure no longer invents a `shellBound`; it is parameterized by the concrete `shellContribution` to be supplied by the actual shell decomposition.

## Scientific boundary
These changes remove specification-laundering routes; they do **not** prove FP-K4-A or FP-K4-B. In particular:

- actual strain/Biot–Savart kernel specialization is still required;
- annular cancellation for that kernel is still required;
- the Campanato-to-directional oscillation estimate is still required;
- the concrete shell decomposition and exact summability exponent are still required;
- `Cfar` must be derived uniformly before the local scale `r`;
- the final `SignedCZLinearGainTarget` remains a target.

Therefore `K4 = OPEN_BRIDGE` until those obligations are discharged, regardless of mechanical CI status.
