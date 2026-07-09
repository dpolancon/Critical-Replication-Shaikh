# STYLE_HAP_CriticalReplication

## Purpose

This note defines the HAP-style critical-replication register for Chapter 1.

“HAP-style” refers to the argumentative discipline of Herndon, Ash, and Pollin’s critical replication of Reinhart and Rogoff. The relevant standard is not imitation of their prose, but their method: narrow replication target, exact reconstruction, precise classification of divergence, transparent recalculation, and bounded political-economy implications.

## Core standard

A HAP-style introduction should:

1. State the target claim being replicated.
2. Explain why the target claim matters.
3. Define the replication as narrow before broadening the stakes.
4. Reconstruct the original empirical object before criticizing it.
5. Identify the exact sources of divergence.
6. Separate computational reproducibility, data construction, methodological choice, and object shift.
7. Avoid motive claims.
8. State political or theoretical implications only after the empirical correction has been established.

## Negative rule

Do not turn the introduction into:

- a broad literature review;
- a general history of capacity utilization;
- a manifesto on capitalist crisis;
- a de-AI prose exercise;
- an abstract theory section.

The introduction should create a disciplined replication contract.

## HAP-style sequence for Chapter 1

The introduction should follow this sequence:

### Paragraph 1 — Measurement problem and target object

Capacity utilization is a latent object. Shaikh’s method provides a portable accounting-based solution by constructing capacity from a long-run output-capital relation.

### Paragraph 2 — Replication target

This chapter critically replicates the coefficient that generates Shaikh’s productive-capacity path. The target is not only the recovered utilization series, but the long-run output-capital coefficient that determines the denominator of utilization.

### Paragraph 3 — Reinterpretation

The chapter interprets that coefficient as a candidate transformation elasticity, θ, linking capital accumulation to productive-capacity formation.

### Paragraph 4 — Replication architecture

The chapter proceeds in three stages:

- S0: reconstruct the closest recoverable Shaikh-like baseline;
- S1: test the single-equation ARDL specification space;
- S2: test whether the relation survives in a joint VECM system.

### Paragraph 5 — Main finding, calibrated

The baseline is approximately recoverable, but the coefficient is not structurally self-sufficient. It is sensitive to admissible single-equation choices and becomes system-admissible only when distribution and historical shock controls enter the long-run system.

### Paragraph 6 — Stakes

The implication is not that Shaikh’s approach should be discarded. The implication is that the portability of the capacity-utilization measure depends on making explicit the distributional and historical conditions under which the output-capital relation is stable.

## Claim calibration

Avoid:

- “proves”
- “fractures”
- “decisively refutes”
- “severe omitted variable bias”
- “class-struggle parameter” as an econometric finding
- “exclusively” unless tied to the retained admissibility criteria

Prefer:

- “indicates”
- “shows”
- “does not survive the admissibility gates”
- “is not self-sufficient at the system level”
- “is consistent with omitted distributional conditioning”
- “under the retained admissibility criteria”

## Chapter-specific governing claim

Shaikh’s capacity path is arithmetically recoverable, but the structural parameter that generates it is not self-sufficient. Once interpreted as a transformation elasticity, the output-capital coefficient is sensitive to admissible ARDL choices and becomes system-admissible only when distribution and historical shock vectors enter the long-run system.

## Use in editing

When a future prompt says “HAP-style introduction,” read this note first and apply it as the controlling standard.

Do not rely on external memory, previous chat context, or unstated interpretation. Treat this file as the repo-local definition of the HAP critical-replication standard.
