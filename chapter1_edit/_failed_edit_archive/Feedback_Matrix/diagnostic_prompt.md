# 🎯 Cointegrated Revision Diagnostic Prompt

Copy and paste the prompt below into the chat to launch the dynamic 5-agent panel review. It calibrates the review team using the custom `advisor-reviewer` skill, the `heterodox-economics-review` skill, and your advisor's exact feedback, benchmark papers, and spreadsheet notes.

***

```markdown
Run /academic-paper-reviewer in full mode on the chapter manuscript located at:
"C:\ReposGitHub\Critical-Replication-Shaikh\chapter1_edit\02_Chapter\CH1_CriticalReplication.pdf"
(with corresponding LaTeX source in "C:\ReposGitHub\Critical-Replication-Shaikh\chapter1_edit\02_Chapter\WP_CriticalReplication\main.tex")

Apply the following custom skills and project context:
1. Custom Skill: [advisor-reviewer](file:///C:/ReposGitHub/Critical-Replication-Shaikh/.agents/skills/advisor-reviewer/SKILL.md)
2. Custom Skill: [heterodox-economics-review](file:///c:/ReposGitHub/academic-research-skills/.agents/skills/heterodox-economics-review/SKILL.md)
3. Consolidated Feedback Matrix: [Feedback_Matrix.xlsx](file:///C:/ReposGitHub/Critical-Replication-Shaikh/chapter1_edit/01_Feedback_Matrix/Feedback_Matrix.xlsx)
4. Stylistic & Empirical Benchmark: [AshBasuDube2017.pdf](file:///C:/ReposGitHub/Critical-Replication-Shaikh/chapter1_edit/editing_artifacts/examples/AshBasuDube2017.pdf) (Michael Ash et al.)
5. Theoretical & Casual Grounding Benchmark: [Marglin-2025or26-What DifferenceDoesItMake.pdf](file:///C:/ReposGitHub/Critical-Replication-Shaikh/chapter1_edit/papers_suggested_mash/Marglin-2025or26-What DifferenceDoesItMake.pdf) (Stephen Marglin)
6. Economics Writing Guidelines: [IZA_Guidelines_2023-2024.pdf](file:///C:/ReposGitHub/Critical-Replication-Shaikh/chapter1_edit/editing_artifacts/IZA_guidelines/IZA_Guidelines_2023-2024.pdf) (Plamen Nikolov)
7. Candidate Writing Style: [profit_rate_chile.pdf](file:///C:/ReposGitHub/Critical-Replication-Shaikh/chapter1_edit/editing_artifacts/my_writtings/profit_rate_chile.pdf) (Diego Polanco)

Configure the 5-Agent Review Panel as follows:
- EIC (UMass Amherst Applied Econometrics / Michael Ash Persona): Evaluates the overall contribution and journal fit. Evaluates whether the introduction and text get straight to the point (BLUF) and state "This paper examines..." by the second paragraph (IZA style). Focuses on whether the econometric cointegration portions are simplified, admissibility is defined in terms of counterfactuals, and whether casual GDP/employment/capital observations of the US economy (1947-2011) are integrated throughout Section 3 and Section 4 mainly, rather than demoted to the appendix, serving as core pedagogical grounding (Marglin style).
- Reviewer 1 (Methodology / Time-Series Econometrics): Critically assesses the ARDL estimation, Johansen system cointegration, and VECM replication. Checks if the nonstationarity of the residuals is transparently reported and if model selection criteria are focused on the best models (Ash-Basu-Dube style). Audits the VECM analysis (S2) to see if a pedagogical "no-dummy counterfactual" is included to show how residuals fail to cointegrate.
- Reviewer 2 (Domain / Classical-Marxian Political Economy): Evaluates the theoretical consistency of Shaikh's capacity utilization estimation and the candidate's existing overaccumulation and stagnation tendency regime classification (Table 1). Verifies that the single-sector macro bounding of this classification is explicitly framed as an analytical limitation in the text. Audits the literature review section (Section 2 and Section 2.3) to "bring it down to earth": verify that it preserves its existing structure and subheadings but is rewritten to be highly accessible and clear, removing paternalistic, lecturing, or snobbish language. Audits Section 4.3 (S1) to verify that a pedagogical "restricted \theta=1 counterfactual" is used to show how utilization drifts to absurd levels under forced balanced growth.
- Reviewer 3 (Perspective / Institutionalist Economics): Evaluates the workplace/capital market mechanisms that explain how capital is converted into potential output (capacity) and actual output under class struggle. Audits all sections other than the literature review (especially Section 3 and 4) to ensure they integrate "down-to-earth" numerical examples of disproportionality or unbalanced growth using stylized baseline parameters (e.g. g_k=3%, g_y=2%, \theta=0.8) to make the dynamic path comparisons clean and clear.
- Devil's Advocate (Skeptic / Mathematical Fallacy Detector): Challenges the mathematical stability of the acceleration term d\hat{k}/dt (second derivative) over long periods. Detects if estimates of the capital-capacity elasticity \theta suffer from downward measurement-error bias.

Output:
Generate 5 independent review reports (specifically referencing line ranges/sections in main.tex and items in the Feedback_Matrix.xlsx, such as the correction of "labor capacity" to "latent capacity" on Page 17, and the Page 7 cointegration comments). Synthesize these reviews into an Editorial Decision Letter and a prioritized, actionable Revision Roadmap mapped directly to the LaTeX source files to prepare for a subsequent `academic-paper` revision rewrite.
```
