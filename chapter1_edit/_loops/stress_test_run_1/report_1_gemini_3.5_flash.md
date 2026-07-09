# AI-Authorship Stress Test Report
**Calibrated to: Michael Ash / UMass Amherst Economics Corpus**
**Target Draft:** `chapter1_edit/03_NewVersion/WP_CriticalReplication_2.0/main.tex`

---

## 🔍 Phase 1: `/calibrate` (Baseline Stylometric Profile)

We calibrated our baseline against two primary sources:
1. **Primary target:** Herndon, Ash, and Pollin (2014, *Cambridge Journal of Economics*), representing Ash's own critical-replication register.
2. **Secondary target:** Ash, Basu, and Dube (2017, PERI Working Paper), and UMass economics dissertation collection samples (e.g., Arora 2024).

### Baseline Profile Characteristics:
*   **Sentence-Length Variance:** High burstiness. Simple, punchy declarative statements are combined with dense mathematical or econometric clauses. There are no patterns of uniform mid-length sentences.
*   **Narrative Framing:** Zero narrative frames or metaphor systems (no "detective stories," "mysteries," "clues," or "suspects"). The text gets straight to the point (BLUF).
*   **Direct Address:** Absolute absence of direct reader address (e.g., no "let's examine," "we must note," or conversational "simply").
*   **Connective Density:** Transitions are sparse and logical (e.g., "We show that...", "The results indicate...", "This table reports..."). Paragraph-ending summaries avoid high concentrations of demonstrative-pronoun transitions ("This [verb]s that...").
*   **Hedging:** Hedging is narrow and strictly quantitative. Vague statements like "impact is substantial" or "significantly influence outcomes" are replaced by exact numerical spreads or mechanical linkages.
*   **Terminological Precision:** High specificity. Concepts like capacity utilization ($\mu_t$), capital productivity ($\rho_t$), and functional distribution ($e_t$) are referenced exactly rather than using simplified paraphrases like "how resources are used" or "wealth distribution."
*   **Imperfection Signature:** Natural drafts show varying polish—extremely tight in derivations, occasionally showing minor syntactic variation or technical placeholder elements in drafts, rather than a uniform, over-smoothed polish.

---

## 🧠 Phase 2: `/diagnose` (Dimension-by-Dimension Critique)

Applying the draft `main.tex` against the calibrated baseline reveals a stark duality:
1. **The Technical Spine (§3 & §4.1–4.3):** Fits the baseline perfectly. It is dense, mathematically rigorous, and uses the correct Marxian and time-series jargon. It is indistinguishable from genuine academic writing.
2. **The Connective Tissue (§1, §4.4, §4.6, & §5):** Departs significantly from the baseline. This is where AI-editing passes (e.g., QwenStudio or ChatGPT) have left distinct "tells":
    *   **Metaphor Overuse:** The entire chapter is framed around a "macroeconomic detective story," treating the $p$-value of $0.099$ as a "clue," and the rate of exploitation ($e_t$) as the "missing suspect."
    *   **Tutorial Voice:** Drops into direct address ("Let's break down... simply") and simplified summaries ("how resources are used", "how they distribute wealth").
    *   **Extreme Redundancy:** The conclusion cycles through identical points about overaccumulation and demand buffers three separate times across four paragraphs, using different variations of the "detective story" metaphor.
    *   **Structural Mismatch:** The introduction roadmap promises a discussion on theoretical implications for profit rate crises and the endogenization of $\theta$, but the draft conclusion completely omitted these points.

---

## 📋 Phase 3: `/report` (Stylometric Audit Ledger)

| TYPE (dimension) | LOCATION (section/¶) | Issue (departure from baseline) | Action (rewrite direction) |
| :--- | :--- | :--- | :--- |
| **Imperfection Signature (Narrative Conceit)** | §1, ¶1 (Line 67) | "This chapter unfolds as a macroeconomic detective story, investigating a cointegration mystery..." — Genre-metaphor framing absent from economics register. | Cut the detective framing; open directly on the structural parameters and the capacity utilization replication. |
| **Register Collapse (Colloquialism)** | §3.1, ¶5 (Line 221) | "The economic punchline is clear..." — Tutorial/colloquial tone. | Replace with formal academic phrasing (e.g., "Economically..."). |
| **Imperfection Signature (Narrative Conceit)** | §4.4, ¶1 (Line 505) | "launches a data archaeology investigation to unravel the mystery..." — Excessive metaphor. | Reframe as a technical baseline reconstruction. |
| **Register Collapse (Metaphor)** | §4.4, ¶2 (Line 507) | "borderline bounds significance of $p=0.099$ serves as a clue, hinting at the fragility..." — Detective framing. | Reframe as a signal of econometric sensitivity. |
| **Register Collapse (Metaphor)** | §4.4, ¶3 (Line 510) | "... demonstrated that replication is not a passive mirror, but an active data archaeology." | Reframe as "active econometric reconstruction." |
| **Register Collapse (Direct Address / Blog style)** | §4.4, ¶5 (Line 530) | "Let's break down the $F$-bounds diagnostic... simply... statistical gatekeeper." — Direct reader address and tutorial register. | Remove direct address ("Let's") and reframe bounds testing in formal econometric terms. |
| **Register Collapse (Direct Address / Metaphor)** | §4.4, ¶6 (Line 532) | "serves as our first key diagnostic clue: it warns us..." — Direct address and detective framing. | Reframe to state that borderline significance indicates specification sensitivity. |
| **Register Collapse (Vague Filler)** | §4.4, ¶7 (Line 534) | "This shift may seem minor, but its impact is substantial... dynamic factor that can significantly influence outcomes." — Fluff. | Replace with the exact mechanical propagation of $\theta$ through the capacity utilization identity. |
| **Citation Integration (Compile Error)** | §4.4, ¶8 (Line 536) | "... potential impact on the results \cite{}." — Empty citation. | Insert the correct bounds-testing key: `\citep{Pesaran2001}`. |
| **Register Collapse (Duplication / Fluff)** | §4.4, ¶9 (Line 556) | "how resources are used" repeated 5 times in 4 sentences. Paraphrase loop. | Replace with a description of what the fan diagram plots (alternative ARDL paths vs. Shaikh baseline and FRB). |
| **Register Collapse (Colloquialism / Metaphor)** | §4.5, ¶2 (Line 575) | "key takeaway is... statistical mirror of subjective preferences." | Reframe in terms of parameter sensitivity to information-criterion penalty schedules. |
| **Imperfection Signature (Narrative Conceit)** | §4.6, ¶1 (Line 667) | "reaches its climax in Stage S2..." — Storytelling climax framing. | Reframe as "extends the empirical analysis to a system-level..." |
| **Register Collapse (Metaphor / Compile Error)** | §4.6, ¶5 (Line 691) | "$e_t$ is the missing suspect that rescues cointegration... \cite{}." — Detective frame and empty citation. | Reframe to explain that $e_t$ resolves omitted variable bias. Insert `\citep{Kurz1986}`. |
| **Citation Integration (Compile Error)** | §4.6, ¶6 (Line 693) | "... historical dummy variables \label{eq:counterfactual}." — Orphaned label in regular text. | Remove `\label{eq:counterfactual}` from text. |
| **Register Collapse (Vague Filler)** | §4.6, ¶7 (Line 716) | "for a system to survive... simplest path... comprehensive understanding..." | Reframe to discuss the specification frontier, fit-complexity trade-offs, and VECM rank restrictions. |
| **Register Collapse (Oversimplification)** | §4.6, ¶8 (Line 726) | "how fully companies use their resources and how they distribute wealth." — AI-paraphrase error. | Reframe as "the rate of capacity utilization and the functional distribution of income." |
| **Redundancy & Structural Gap (Severity: High)** | §5 (Lines 769–778) | Extremely repetitive overaccumulation paragraphs; detective framing ("mystery", "culprit"); misses the roadmap's promised theoretical discussion and future research placeholders. | Rewrite Section 5 entirely to state findings, connect $\theta < 1.0$ to the Marxian falling rate of profit, and frame $\theta$ endogenization as future work. |

---

## ⚖️ Qualitative Verdict

The technical spine of this dissertation chapter is exceptionally strong and sits fully within the PERI and UMass Amherst heterodox econometrics register. However, the connective paragraphs and the conclusion have been heavily over-smoothed by an AI editing pass, introducing a "macroeconomic detective story" narrative arc and tutorial colloquialisms that would stand out immediately to Michael Ash. This is a highly localized, bounded editing job: removing the detective frame, correcting the empty citations, and rewriting the conclusion will fully align the text with the target academic register.
