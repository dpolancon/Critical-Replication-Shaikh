# AI-TRACE & LEXICAL DISCIPLINE PROTOCOL
## Reusable Editing Artifact for Dissertation Chapters / AG Sessions

### Purpose

Use this protocol to discipline stylistic drift in a dissertation chapter edited with AG or another LLM.

The objective is **not** to flatten the author's theoretical vocabulary, depoliticize the argument, or replace technical concepts with generic prose. The objective is to remove recurring machine-like rhetorical habits that accumulate across repeated editing passes.

This protocol is designed for **semantic calibration**, not global find-and-replace.

---

# 1. CORE LOCK: TECHNICAL LANGUAGE IS NOT GUILTY BY ASSOCIATION

A word or phrase must not be removed merely because it appears frequently.

For every candidate term, distinguish among:

**A. TECHNICAL / CONCEPTUAL — RETAIN**  
The expression names a real theoretical, empirical, mathematical, institutional, or historical object.

**B. LEGITIMATE BUT OPTIONAL — REVIEW**  
The expression is defensible but may be unnecessarily repeated.

**C. RHETORICAL SCAFFOLDING — REWRITE**  
The expression does not add analytical content and mainly organizes or intensifies prose.

Only category C is presumptively editable.

Never perform blind global substitution.

---

# 2. BOUNDARY-FAMILY LOCK

Audit:

- bounded
- bound
- bounds
- boundary
- boundaries
- limiting / limit / limits
- constrained / constraint / constraints

## Retain when conceptually necessary

Examples:

- balance-of-payments constraint
- external constraint
- mathematical parameter bounds
- sample bounds when literally defining an interval
- institutional limits where the limit itself is the analytical object
- a boundary condition in a formal model

## Rewrite when the word merely substitutes for a more concrete description

Examples:

`bounded lag search`  
→ `lag search over k = 1,...,12`

`historically bounded result`  
→ `result for the pre-October 1973 sample`

`forward transmission remains bounded`  
→ `the estimated response remains modest`

`bounded by a bilateral framework`  
→ `framed primarily through bilateral U.S.–Chile relations`

`methodological boundaries`  
→ specify the actual limitation:  
`the estimates do not identify contemporaneous structural effects`

## Binding rule

> Boundary-family vocabulary is not globally prohibited. Preserve it where it carries genuine technical or conceptual meaning. Rewrite it only where it functions as repetitive rhetorical scaffolding and a concrete mechanism, sample restriction, empirical limitation, or institutional constraint can be stated more directly.

---

# 3. SECONDARY AI-LIKE BRANDED VOCABULARY

Audit repeated use of:

- architecture
- framework
- tournament
- gate
- shield
- trap
- atlas
- transmission belt
- corridor
- frontier
- horizon
- hand-off
- hierarchy
- layer
- pathway
- pipeline
- scaffold
- mechanism
- regime
- state
- lens
- terrain
- constellation
- nexus

These terms are not banned.

Retain them if they name a stable concept used consistently across the chapter.

Rewrite them if they merely brand an ordinary analytical move.

### Example

`The empirical tournament reveals...`  
→ `The estimates show...`

`the external shield dissolves`  
→ `foreign reserves no longer buffer the shock`

`the reserve-depletion trap`  
→ describe the persistence directly

`the transmission belt of the crisis`  
→ name the actual channel

Avoid replacing one metaphor with another.

---

# 4. OVER-INTENSIFICATION AUDIT

Search for recurrent intensifiers and evaluative adjectives:

- decisive
- crucial
- fundamental
- profound
- deep
- stark
- striking
- dramatic
- severe
- powerful
- rich
- sophisticated
- exceptional
- remarkable
- central
- key
- critical
- clear / clearly
- precisely
- systematically
- fundamentally
- analytically
- structurally

Do not remove automatically.

Ask:

1. Does the adjective change the factual meaning?
2. Is the strength demonstrated immediately afterward?
3. Would the sentence remain equally informative without it?
4. Has the same intensifier appeared repeatedly within a few pages?

If the adjective is doing the work that evidence should do, remove it.

---

# 5. CONTRAST-CONSTRUCTION AUDIT

LLM-edited prose often overuses contrast templates.

Flag repeated structures such as:

- X, not Y
- not X but Y
- rather than X, Y
- not merely X; it also Y
- does not simply X; it Y
- far from X, Y
- instead of X, Y
- whereas X, Y
- while X, Y
- on the one hand / on the other hand
- neither X nor Y, but Z

These structures are useful when the contrast is analytically necessary.

They become an AI trace when used as the default sentence architecture.

### Editing rule

If the contrast can be written as a positive declarative sentence, prefer the declarative version.

Example:

`The crisis was not merely monetary; it was the product of an external constraint interacting with distributive conflict.`

Possible revision:

`The crisis combined an external constraint with distributive conflict, which shaped the monetary response.`

Do not eliminate contrasts that genuinely distinguish competing theories or mechanisms.

---

# 6. TRIAD / RHETORICAL-PARALLELISM AUDIT

Flag repeated three-part constructions such as:

`external constraint, distributive conflict, and monetary accommodation`

Triads are not prohibited, especially when they reflect the actual architecture of the argument.

But repeated triads can produce synthetic cadence.

Check for:

- three nouns in parallel;
- three verbs in parallel;
- three adjectives in parallel;
- repeated colon + triad formulations;
- successive paragraphs ending in triads.

Retain a triad if all three elements are analytically necessary.

Otherwise:
- collapse overlapping items;
- split into two sentences;
- vary syntax.

---

# 7. SIGNPOSTING AUDIT

Review phrases such as:

- taken together
- in this sense
- in this context
- in this framework
- seen through this lens
- at stake
- what matters here
- the key point is
- the central point is
- this reveals
- this highlights
- this underscores
- this demonstrates
- this suggests
- this establishes
- importantly
- crucially
- significantly
- more broadly
- ultimately

These are not automatically wrong.

Remove them when the sentence can begin directly with the substantive claim.

Example:

`Taken together, these results suggest that...`  
→ `These results indicate that...`

or, where appropriate:

`Inflation predicts subsequent base-money growth across all tested lag lengths.`

---

# 8. CLAIM-STRENGTH CALIBRATION

Audit verbs that may silently convert evidence into proof:

- proves
- confirms
- establishes
- demonstrates
- reveals
- refutes
- rules out
- validates
- verifies
- identifies
- determines
- causes
- drives
- compels

Match wording to the evidential design.

## Typical calibration

### Descriptive evidence
Use:
- documents
- records
- shows
- is consistent with

### Granger / VAR
Use:
- predicts
- contains incremental predictive information
- precedes conditionally
- exhibits predictive feedback

Do not infer structural causality.

### GIRF / non-linear dynamic response
Use:
- conditional response
- dynamic response
- response under the estimated state
- is larger / more persistent over the reported horizon

### PCMCI
Use:
- conditional lagged link
- selected parent relation
- conditional dependence under stated assumptions

Avoid treating it as unrestricted causal proof.

### Historical narrative
Use causal verbs only where the source or design supports them.

---

# 9. ABSTRACT-NOUN / NOMINALIZATION AUDIT

LLM prose often becomes dense through abstract nouns.

Flag clusters such as:

- operationalization
- conceptualization
- institutionalization
- articulation
- reconfiguration
- mediation
- transmission
- accommodation
- reproduction
- consolidation
- destabilization
- incorporation
- transformation
- differentiation
- decomposition
- identification

These are often legitimate disciplinary terms.

The problem is density.

When several occur in one sentence, ask whether one can become a verb.

Example:

`The institutionalization of the programme produced a depoliticization of the external constraint.`

Possible revision:

`As the programme became institutionalized, it treated the external constraint in increasingly technical terms.`

---

# 10. OVER-BRANDED SUBHEADINGS

Audit headings that combine:

- a branded noun;
- a colon;
- an evaluative punchline.

Examples:

`The Empirical Tournament: Reverse Accommodation Dominance`

`The External Shield: The Reserve-Depletion Trap`

`Scientific Progress and Open-Ended Research Horizons`

Prefer headings that state the object directly:

- `Forward and Reverse Monetary Responses`
- `External Price Pass-Through across Solvency-Growth States`
- `Limitations, Implications, and Extensions`

Do not simplify headings that encode a real theoretical distinction.

---

# 11. REPETITIVE AUTHORIAL MOVES

Flag recurrent paragraph templates:

1. literature claim;
2. `Yet...`;
3. author's correction;
4. strong concluding sentence.

Also flag repeated:

`This distinction is decisive.`

`This tension is central.`

`This contradiction defines...`

`This is precisely where...`

`The significance of this result lies in...`

Vary paragraph movement.

Sometimes end with evidence rather than a punchline.

Sometimes begin with the result rather than the literature contrast.

Sometimes allow a paragraph to close quietly.

---

# 12. HUMAN CADENCE CHECK

A chapter should not sound uniformly optimized.

Review for:

- repeated sentence length;
- repeated semicolon structures;
- paragraph-final aphorisms;
- excessive em dashes;
- excessive colon-led definitions;
- every paragraph beginning with a transition;
- every subsection ending with a synthesis sentence.

Prefer natural variation:

- short factual sentences;
- longer analytical sentences where necessary;
- occasional plain declarative prose;
- fewer rhetorical finales.

Do not intentionally introduce grammatical roughness.

---

# 13. TERMS THAT SHOULD USUALLY REMAIN STABLE

Do not de-trace terminology that is part of the chapter's actual conceptual apparatus.

Examples may include:

- balance-of-payments constraint
- dependency theory as a research programme
- protective belt, when explicitly Lakatosian
- international currency hierarchy
- world money
- Solvency Growth Gap
- capacity utilization
- wage share
- profit rate
- state dependence
- central-bank accommodation
- Granger predictive precedence
- threshold VAR / TVAR
- generalized impulse response function

The exact protected list should be adjusted for each chapter.

---

# 14. EDITING WORKFLOW FOR AG

Before making edits, produce a ledger.

Use:

| ID | Location | Exact phrase | Pattern family | Classification A/B/C | Proposed action | Meaning preserved? | Execute? |
|---|---|---|---|---|---|---|---|

Pattern families:

- BOUNDARY
- BRANDED_JARGON
- INTENSIFIER
- CONTRAST
- TRIAD
- SIGNPOST
- CLAIM_STRENGTH
- NOMINALIZATION
- HEADING
- CADENCE

## Execution rule

- A → retain
- B → edit only if repetition is evident
- C → rewrite directly

If semantic meaning could shift:  
`RESEARCHER DECISION`

Do not edit that occurrence automatically.

---

# 15. HARD PROHIBITIONS

Do not:

- run a global replacement on any flagged term;
- replace technical terminology merely because it sounds abstract;
- depoliticize substantive political-economy claims;
- replace the author's theoretical vocabulary with generic economics prose;
- add new references to solve stylistic problems;
- introduce new metaphors while removing old ones;
- alter equations, coefficients, sample periods, or empirical results;
- convert calibrated causal language into stronger claims;
- rewrite whole sections when local edits suffice;
- pursue stylistic uniformity as an objective.

---

# 16. STOPPING RULE

Stop the de-tracing pass when:

1. the major repeated lexical families have been audited;
2. category-C rhetorical residues have been repaired;
3. technical/conceptual terminology remains intact;
4. no empirical meaning has changed;
5. the chapter no longer exhibits conspicuous repeated templates across adjacent pages.

Do not continue into a generic "polish" pass.

The goal is not maximally smooth prose.

The goal is prose that sounds authored, analytically specific, and proportionate to the evidence.

---

# 17. COMPACT AG LAUNCHER

Use the following when attaching this protocol to another chapter-editing session:

> Read `AI_TRACE_LEXICAL_DISCIPLINE_PROTOCOL.md` before editing. Apply it as a semantic audit, not as a vocabulary blacklist. Preserve technical and conceptual terms where they perform real analytical work. Concentrate on repetitive rhetorical scaffolding, especially the boundary family, secondary branded metaphors, contrast templates, over-intensification, signposting, claim-strength inflation, nominalization clusters, and repetitive paragraph cadence. Produce the audit ledger before editing. Do not execute any occurrence whose meaning is uncertain; mark it `RESEARCHER DECISION`. Do not alter empirical results, theoretical commitments, or citation architecture. Stop after the identified patterns have been corrected; do not roll into a generic prose-polishing pass.
