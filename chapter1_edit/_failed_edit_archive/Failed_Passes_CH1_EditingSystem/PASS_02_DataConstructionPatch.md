# PASS 02 Data Construction Patch

## Edited Paragraph 1: Imputed Interest and Dummies

Before:

> Corporate gross value added is corrected for imputed financial intermediation services by subtracting net monetary interest paid and adding back imputed net interest adjustments (NIPA Table 7.11). The algebraic derivation and NIPA accounts usage considering their releases used by Shaikh, are detailed in more extension at Appendix... Historically, these set of dummies are coherent with relevant recessive events...

After:

> Corporate gross value added is corrected for imputed financial intermediation services by subtracting net monetary interest paid and adding back imputed net interest adjustments (NIPA Table 7.11). The algebraic derivation and NIPA account usage are detailed in Appendix... They are treated here as historically interpretable shock controls associated with 1956, 1974, and 1980, not as standalone causal explanations of those episodes.

Purpose: grammar cleanup, dummy interpretation softening, and distinction between econometric controls and historical causality.

## Edited Paragraph 2: GPIM Gross Capital

Before:

> These measurement conventions constitute the identification strategy. The GPIM accounting approach to reconstruct gross capital stock, built the varaible of capital stock that is included in the analysis, the justification lies on the fact that net capital stock are representative of book-value and might be more appropriate to measure profitability...

After:

> These measurement conventions constitute the identification strategy. For the capacity question, the relevant capital stock is the gross stock of capital in operation, not the net book-value stock used more commonly in profitability accounting. The GPIM reconstruction is appropriate here because it tracks the accumulation and depletion of operating capital through `z_t^*`, preserving the stock-flow relation needed to estimate productive capacity.

Purpose: clarify why gross GPIM-adjusted capital is appropriate for productive-capacity measurement, while net capital remains more closely tied to book-value/profitability measurement.

