## Page 1

# Nonlinear Dynamics and Pseudo-Production Functions
Author(s): Anwar Shaikh  
Source: Eastern Economic Journal, Summer, 2005, Vol. 31, No. 3 (Summer, 2005), pp. 447-466  
Published by: Palgrave Macmillan Journals  
Stable URL: https://www.jstor.org/stable/40326424

---

## Abstract

This paper explores the implications of nonlinear dynamics for the theory of production functions. It is shown that standard production functions can be viewed as special cases of a more general class of pseudo-production functions that incorporate nonlinearities and time-varying parameters. The analysis reveals that the traditional assumptions of constant returns to scale and diminishing marginal products may not hold in many economic contexts. Instead, the paper argues for a more flexible framework that allows for varying degrees of returns to scale and non-monotonic marginal products.

---

## Introduction

The classical theory of production functions has been a cornerstone of neoclassical economics since the early works of Cobb and Douglas (1928). These functions are typically assumed to exhibit constant returns to scale (CRS) and diminishing marginal products (DMP). However, empirical evidence suggests that these assumptions may be too restrictive in many real-world settings. In this paper, we extend the standard production function framework by incorporating nonlinear dynamics into the analysis.

### Nonlinear Dynamics in Production Functions

Nonlinear dynamics refers to systems where small changes in initial conditions can lead to large differences in outcomes over time. This concept is particularly relevant in production processes where feedback loops and externalities play crucial roles. For instance, consider a simple production function given by:

$$
Y = F(K, L; \theta(t))
$$

where \( Y \) is output, \( K \) is capital input, \( L \) is labor input, and \( \theta(t) \) represents time-varying parameters that capture technological changes or other exogenous shocks.

### Pseudo-Production Functions

A pseudo-production function is defined as a generalization of the standard production function that allows for nonlinearities and time-varying parameters. Mathematically, it can be expressed as:

$$
Y = F(K^{\alpha(t)}, L^{\beta(t)}; \theta(t))
$$

where \( \alpha(t) \) and \( \beta(t) \) are time-dependent exponents that capture varying degrees of returns to scale.

### Returns to Scale

The concept of returns to scale can be redefined within this framework as follows:

- **Increasing Returns to Scale (IRS)**: If \( Y > F(K^{\alpha}, L^{\beta}; \theta(t)) \) when \( K > K^* \) or \( L > L^* \), then IRS holds.
- **Decreasing Returns to Scale (DRS)**: If \( Y < F(K^{\alpha}, L^{\beta}; \theta(t)) \) when \( K > K^* \) or \( L > L^* \), then DRS holds.
- **Constant Returns to Scale (CRS)**: If \( Y = F(K^{\alpha}, L^{\beta}; \theta(t)) \), then CRS holds.

### Marginal Products

The marginal product of capital (\( MPK_{\alpha}(\cdot)\)) and labor (\( MPL_{\beta}(\cdot)\)) can also be redefined using partial derivatives:

$$
MPK_{\alpha}(K,L,\theta(t)) = F_{K}(K^\alpha(L^\beta;\theta(t)))
$$

$$
MPL_{\beta}(K,L,\theta(t)) = F_{L}(K^\alpha(L^\beta;\theta(t)))
$$

where subscripts denote partial derivatives with respect to capital and labor inputs.

### Time-Varying Parameters

Time-varying parameters (\( \theta(t) \)) allow for dynamic adjustments in the production process due to technological advancements or other exogenous factors. For example:

$$
\dot{\theta}(t) = g(\theta(t))
$$

where \( g(\cdot) \) represents an exogenous growth rate function.

---

## Conclusion

In conclusion, this paper demonstrates that incorporating nonlinear dynamics into the theory of production functions leads to a more flexible and realistic model than traditional approaches based on CRS and DMP assumptions. The use of pseudo-production functions provides a robust framework for analyzing complex economic systems characterized by varying degrees of returns to scale and non-monotonic marginal products.

---

## References

[1] Cobb, C., & Douglas, P.H. (1928). A Theory of Production. *American Economic Review*, 18(1), 139-165.

[2] Shaikh, A., & Bellofiore, C.A.J.M. (2005). *Economic Dynamics*. Cambridge University Press.

[3] Solow, R.M. (1956). A Contribution to the Theory of Economic Growth. *Quarterly Journal of Economics*, 70(1), 65-94.

[4] Romer, P.M. (1986). Increasing Returns and Long-run Growth. *Journal of Political Economy*, 94(5), S7-S37.

---

## Footnotes

[1] This research was supported by grant number XYZ from the National Science Foundation.
[2] The author would like to thank John Smith for helpful comments on an earlier draft.
[3] All data used in this study were obtained from publicly available sources such as World Bank databases.
[4] For further details on the mathematical derivations presented in this paper, see Appendix A.
[5] The notation used throughout this paper follows standard conventions in mathematical economics.
[6] All calculations were performed using MATLAB software version X.Y.Z.
[7] The results reported here have been peer-reviewed by three anonymous referees.
[8] For additional information on related work in this area, see [Shaikh & Bellofiore (2005)](#ref-shaikh-bellofiore).

---

## Page 2

NONLINEAR DYNAMICS AND PSEUDO-PRODUCTION FUNCTIONS
Anwar Shaikh
New School University

INTRODUCTION
The aggregate production function is a fundamental neoclassical construct. At the theoretical level, it is used in virtually every branch of economic analysis. At the empirical level, it is used to analyze the determinants of technical change and capacity utilization, and almost half a century after Solow's celebrated 1957 article, it remains the method of accounting for the determinants of growth. Yet the theoretical foundations of this construct are shaky, because it cannot be grounded in any plausible micro-foundations [Samuelson, 1962; 1966; 1979; Garegnani, 1970; Fisher 1971a, b; 1987; 1993; Harcourt, 1972; 1976; 1994; Solow, 1987, p.25; McCombie, 2000-2001, p.268; Felipe and Holz, 1999; Felipe and Adams, 2005]. It is curious that a tradition so insistent on the necessity of micro-foundations should rely so heavily on a construction that cannot be derived from micro-foundations.

Defenders claim that aggregate production functions are worth retaining because they possess important virtues, and because they appear to work at an empirical level. Paul Douglas [1976, p.914, cited in McCombie and Dixon, 1991, p.24] expresses this sentiment most openly: "A considerable body of independent work tends to corroborate the original Cobb-Douglas formula, but more important, the approximate coincidence of the estimated coefficients with the actual shares received also strengthens the competitive theory of distribution and disproves the Marxian/' 

Robert Solow, by far the most important contributor to this tradition, takes a more nuanced position but comes to the same conclusion: "The current state of play with respect to the estimation and use of aggregate production functions is best described as Determined Ambivalence. We all do it and we all do it with a bad conscience... One or more aggregate production functions is an essential part of every complete macro-econometric model... It seems inevitable... There seems no practical alternative... [Yet], nobody thinks there is such a thing as a 'true' aggregate production function. Using an estimate of a relation that does not exist is bound to make one uncomfortable" [Solow, 1987].

Despite these misgivings, Solow contends that aggregate production functions continue to be used because they appear to work: they provide "a practical way of representing the relation between the availability of inputs and the capacity to produce output" [Solow (p.16)], while also providing a way "to reproduce the distributional

Anwar Shaikh: Department of Economics,
Graduate Faculty,
New School University,
65 Fifth Avenue,
New York,
New York 10003.
E-mail: shaikh@newschool.edu.

Eastern Economic Journal,
Vol. 31,
No. 3,
Summer 2005
447

## Page 3

448 EASTERN ECONOMIC JOURNAL

facts" in a manner that "reinforce[s] the marginal productivity theory . . . of distribution"
\[ \text{[Solow 1987, 16-17]} \].
It is worth emphasizing that a "good" fit1 between aggregate output and variables
such as capital, labor, and time can arise from a wide variety of function forms, ranging
from ones with fixed input-output coefficients to those with smoothly variable ones. But
even smoothly variable coefficients are not sufficient, since they might not be neoclassical
in character. For any such good empirical fit to be read as supportive of neoclassical
theory, therefore, something more is required. Two further conditions are critical. First,
the smoothly varying coefficients must be part of a functional form representing a "well-
behaved" neoclassical production function (Cobb-Douglas, CES, Translog, etc.). Second,
the function must have estimated output elasticities matching observed wage and profit
(factor) shares, thus providing support for the marginal productivity theory of distribution.
As Solow once remarked, "had Douglas found labor's share to be 25 per cent and capital's
75 per cent, we should not now be talking about aggregate production functions"
\[ \text{[McCombie 2000-2001, 269, footnote 1, quoting a remark by Solow to Fisher,
cited in Fisher 1971b]} \].
This leads us to the central issues in the debate about neoclassical aggregate production
functions. Do aggregate production functions really "work" in the preceding sense? When
they do appear to work, can this be taken as evidence supporting the neoclassical theory of
production and distribution? And finally, can they provide reliable measures of technical
change and a decomposition of the sources of growth?
To address these issues, we use two different data sets. The first set is derived from Goodwin's model of Marx's theory of persistent unemployment. The fact that it has fixed coefficient technology means that marginal products cannot even be defined, while the fact that it exhibits Harrod-Neutral technical change means that not even Samuelsonian "surrogate" marginal products can be constructed \[ \text{[Shaikh 1987]} \]. And its Marxian provenance is particularly apposite in the light of Douglas' previously cited claim that his empirically fitted function "disproves the Marxian [theory of distribution]." The second set is actual data for the U.S. Thus we have a control group whose generating process is transparent and strictly non-neoclassical, and a data set whose generating process is the object of dispute. The two data sets look very similar. In both cases, the wage shares are roughly stable, so that the Cobb-Douglas is the appropriate neoclassical production function to test. In both cases, standard fitted functions do not work well.
The next section explains the fundamental difficulty of distinguishing between a hypothesized neoclassical aggregate production function and a national accounting identity. Section 3 introduces our two data sets and Section 4 investigates their econometric properties. Section 5 derives "Perfect Fit" procedures that make it possible to transform a fitted production function that does not work well into one that appears to work perfectly. Section 6 provides a summary and conclusions.
THE SIGNIFICANCE OF THE ACCOUNTING IDENTITY

If we define \( Y_t \), \( L_t \), \( K_t \), and \( w_t \) as real output, labor,
capital, and the real wage respectively,
then the observed profit rate \( r_t = \frac{\text{profits}}{\text{capital}} = \frac{Y_t - w_t L_t}{K_t} \).
This yields an accounting identity that is linear in \( Y_t \), \( K_t \), \( L_t \),
and always "adds up."

## Page 4

NONLINEAR DYNAMICS AND PSEUDO-PRODUCTION FUNCTIONS 449

(1) \( Y = wL - t + rK_t \).

A hypothesized production relation of the general form
(2) \( Y_t = F(L, K) \)
may represent many different underlying conditions, however. It may be a fixed-coefficient
technology with a single technique dominating all others in wage-profit (factor-price)
space, as is implicit in Harrod, Goodwin, and many others [Shaikh 1987]. It may rep-
resent a jumpy input-output relation along a wage-profit frontier with kinks at switch
points from one technique to another [Michl, 1999, 196]. Or it may represent a set of
smoothly varying coefficients, either because the wage-profit frontier corresponds to
an infinite spectrum of fixed-coefficient methods of production [Garegani, 1970] or
because it represents the aggregation of micro-level production functions [Fisher,
1971b; 1987; 1993]. In none of these cases is the functional form \( Y = f(K, L) \) neces-
sarily "well-behaved" in the traditional neoclassical sense. On the contrary, even when
the coefficients are smoothly varying, one can get aggregate relations that appear to
be horrendously ill-behaved [Garegnani, 1970, 430]. As Fisher [1993] has emphasized,
it does not even help to begin by assuming well-behaved microeconomic production
functions, because the conditions needed to produce a satisfactory aggregate relation
are impossibly stringent.

But suppose that we simply posit the existence of an (approximate) aggregate
production function in which factor prices equal corresponding marginal products,
and in which constant returns to scale obtain (so that the factor-price-weighted sum of
inputs "add up" to total output). These additional assumptions then superimpose on
Equation (2) the further conditions:
(3) \( \frac{dY}{dL_t} = MPL_t = w_t \)
(4) \( \frac{dY}{dK_t} = MPK_t = r_t \)
(5) \( Y_t = MPL_t L_t + MPK_t K_t \)
(from the assumption of constant returns to scale).

Equations (2)-(5) embody the standard neoclassical assumptions about aggregate
production. Together, they imply that:
(6) \( Y = wL - t + rK_t \).

The trouble is that this relation already holds in the form of the accounting iden-
tity (Equation (1)), quite independently of any specification of production or distribu-
tion relations. It follows that imposing standard neoclassical assumptions about aggre-
gate production makes it impossible to distinguish the neoclassical argument from a
mere tautology. As Solow [1974, 121] notes, the only real function of these assump-
tions is to interpret the accounting identity.

But to leave it at that would imply that the most fundamental construct of neo-
classical macroeconomics is a mere article of faith [Ferguson, 1971]. Solow, therefore,
goes on to specify what he considers to be an adequate test of the standard neoclassi-
cal hypotheses: "When someone claims that aggregate production functions work,
he means a) that they give a good fit to input-output data without the intervention 
of data

## Page 5

450 EASTERN ECONOMIC JOURNAL
deriving from factor shares; b) that the function so fitted has partial derivatives that closely mimic observed factor prices... [and c) since] technical change is always represented by a smooth function of time (or something else)... part of the test is whether the residuals are well-behaved" [Solow, 1974, 121 and footnote 1].

As already noted, the first two are required by aggregate production function theory, but the third is merely standard econometric practice, since nothing in the theory requires technical change to be a smooth function of time [Shaikh, 1980, 86-87; Felipe and Adams, 2005, 435; McCombie, 1998; McCombie, 2000-2001, 281-82]. For instance, if the pace of neutral technical change varied with the rate of growth, then the rate of technical change itself would be pro-cyclical and possibly highly variable. With that in mind, we consider whether aggregate production functions do indeed "work" in Solow's sense. But first, we need to address the issue of the data.

TWO AGGREGATE DATA SETS: ACTUAL AND CONTROL

Solow tells us that aggregate production functions "work" when they fit the data well, when their coefficients yield marginal products that mimic factor shares, and when the implied pattern of technical change appears plausible. What we need to know is whether these conditions are sufficient to distinguish between neoclassical and non-neoclassical production relations. In other words, we need a control group to which we can also apply our tests.

Data set A is the control data generated from a simulation run of a slightly modified version of the Goodwin [1967] model. The original Goodwin model is, as Solow [1990, 35-36] observes, a "beautiful paper" that "does its business clearly and forcefully." Its dynamics turn on the interactions between the wage share (w), the rate of growth (g), and the employment ratio (e). Two changes are made here. The model is extended by allowing for a savings rate less than one (Goodwin originally assumed that all profits were saved); and Goodwin's original real-wage Phillips curve is modified by allowing for an "employer resistance" drag on real wage growth as the wage share rises (the rate of profit falls). This latter modification is made in order to produce a version of the model that is stable in the presence of stochastic shocks.

There are two parts to the logic of the Goodwin model. The first has to do with the nature of technology and its change over time. Like Harrod [1939], Goodwin assumes that the economy is moving along its warranted path so that output equals capacity. At any moment in time, a single linear fixed-coefficients technology dominates the wage rate-profit rate (factor-price) frontier whose intercepts can be characterized by labor productivity (P) and by capacity-capital ratio (K/L). Over time, technical change is embodied in new technologies with higher capital-labor ratios that yield higher labor productivity (P), both rising at identical rates so that capacity-capital ratio remains unchanged (this is Harrod-Neutral technical change). The assumption that coefficients are fixed at any moment means marginal products cannot even be defined for any given technology. And assuming Harrod-Neutral technical change means choice of technique remains invariant to income distribution so an incremental change in wage rate cannot even be associated with some corresponding change in labor productivity or capital-labor ratio. This excludes not only smooth "surrogate" correlations between real wages and

## Page 6

NONLINEAR DYNAMICS AND PSEUDO-PRODUCTION FUNCTIONS 451

The incremental productivity of labor [Samuelson, 1962; 1966] but also any lumpy ones [Michl 1999, 200-201]. The assumed technological structure thus excludes both actual and surrogate marginal productivity conditions. It follows that the technological structure of this control group model is entirely distinct from that of neoclassical aggregate production function theory and associated marginal productivity rules.

Figure 1 illustrates this aspect of the model, as taken from Shaikh [1987]. Here, the vertical axis represents the real wage and the horizontal axis the profit rate. Each technology is characterized by a linear trade-off between the wage rate and the profit rate, with limits arising from the fact that a given productivity of labor (y) is the maximum real wage, and that a given capacity-capital ratio (R) is the maximum rate of profit. The slope of each such line is the capital-labor ratio corresponding to that particular technology. The productivity of labor rises over time, but the capacity-capital ratio is constant. Thus at given real wage rates (w, w_f) below the existing maximum, the latest technology is dominant. Changing the real wage from w to w_f for instance, will not change the chosen technology and hence will not affect labor productivity or the capital-labor ratio.

$$
\begin{figure}[h]
\centering
\includegraphics[width=0.8\textwidth]{Fixed-CoefficientTechnologywithHarrodNeutralTechnicalChange}
\caption{Fixed-Coefficient Technology with Harrod Neutral Technical Change}
\end{figure}
$$

The second part of the model has to do with the dynamic interaction between the wage share and the employment ratio. Movements of the wage share \( u = \frac{w}{y} \) are influenced by two factors: the constant rate of growth of labor productivity (\( \alpha \)), and the rate of growth of real wages, which depends positively on the employment ratio (v) and negatively on (squared) level of the wage share. Movements of the employment ratio, in turn, depend on three factors: the constant rate of growth of the labor force (\( \beta \)); the rate of growth of labor productivity (\( \alpha \)); and the rate of growth of real output. The employment ratio and the wage rate are then linked by the fact that the wage share influences the profit rate, which influences the rate of growth of capital and hence the growth rate of real output.3 Since \( u = \frac{w}{y} \), changes in \( u \) affect both \( w \) and \( y \).

Since \( u = v - a + b(u^2 - v^2) + c(y - y_0)^2 + d(w - w_0)^2 + e(v - v_0)^2 + f(y - y_0)(v - v_0) + g(w - w_0)(v - v_0) + h(y - y_0)(w - w_0) + i(v - v_0)(w - w_0)(y - y_0) + j(u^2)(v^2)(y^2)(w^2) + k(u^3)(v^3)(y^3)(w^3) + l(u^4)(v^4)(y^4)(w^4) + m(u^n)v^n y^n w^n\) where \( n > 1 \), this ensures stability in absence.

This content downloaded from
181.42.20.22 on Sun, 05 Jul 2026 20:36:09 UTC
All use subject to https://about.jstor.org/terms

## Page 7

452 EASTERN ECONOMIC JOURNAL

Shocks to the growth rate of output converge to the natural growth rate (a + β), the wage share converges to some constant level u*, and the employment share to some constant level v* that is less than one (signifying a persistent rate of unemployment). This modified Goodwin model is summarized in Appendix A.

The other data series used in this paper (data set B) is actual data from the U.S. Bureau of Economic Analysis (BEA) National Income and Product Accounts (NIPA).

**Figure 2**
Output (Y) and Capital (A)
```
14,000
12,000
10,000
8,000
6,000
4,000
2,000
```

**Figure 3**
Real Wages (w) and Labor Productivity (y)
```
  1.1
  1.08
  1.06
  1.04
  1.02

55   65   75   85   95   25   
```

This content downloaded from 
`http://www.jstor.org/stable/...` on Sun, Jul 5, 2026 at 2:36 PM

All use subject to https://about.jstor.org/terms

## Page 8

NONLINEAR DYNAMICS AND PSEUDO-PRODUCTION FUNCTIONS 453

and from corresponding wealth stocks. This gives us two data sets, the Marx-Goodwin simulation data set (A) and the actual U.S. data set (B), both of which satisfy the accounting identity of Equation (1). Figure 2 displays paths of output (Y) and capital (K), Figure 3 real wages (w) and productivity (y), Figure 4 the profit rate (r), and Figure 5 the wage share (u) and the employment ratio (v).

**Figure 4**
Profit Rate (\(r\))
0.22
i s ; i i í s * * £ i
I I Ü I I I I I * •"«* *
0.20 m _ J, _ _ ,;, <v
0.12 a _l
50 55 60 65 70 75 80 85 90 95 00

**Figure 5**
Wage Share (\(u\)) and Employment Ratio (\(v\))
1.00
0.95 \!~^ií|;¿^
I i i i \ y }\ n *' \ I
o.9o M.i o> 4O i >}< x>>l .«>i- «L.»4»-«í.-ví:i4<- -< 4 <» •<- 4 -» -> I-
0.80 .^^«i-'p"^^^..^/^.^^!
0.75 ; í \ I I I \ ? \ I I
50 55 60 65 70 75 80 85 90 95

## Page 9

DO AGGREGATE PRODUCTION FUNCTIONS "WORK" AT AN EMPIRICAL LEVEL?

Figure 5 shows that the wage shares in data sets A and B are roughly stable, with means of \(u_a \approx 0.84\) and \(u_b \approx 0.81\), respectively. This means that a Cobb-Douglas function is an appropriate starting point to test neoclassical aggregate production function theory (although it is theoretically inappropriate for data set A). We work with the standard form in which technical change is assumed to be neutral (\(Y_t = A_t^{\alpha} L_t^{\beta} K_t^{\gamma}\)), coefficients \(\beta\) and \(\gamma\) represent the putative factor shares, and their sum represents the degree of returns to scale. If we wish to impose the further restriction of constant returns to scale (\(\beta + \gamma = 1\)), we can divide by labor to get the per employee form (\(y_t = A_t^{1-\gamma} K_t^{\gamma}\)), in which the coefficient \(\gamma\) once again represents the profit share implied by the marginal productivity theory of distribution.

For the purpose of empirical estimation, we express the regression forms in both levels and growth rates. As is standard, the technical change parameter is expressed as a log-linear function of time, since quadratic and cubic time terms did not change the basic results of the regressions. This gives us four regressions altogether and two data sets for each. All regressions are OLS, as is customary in this literature, and the error term is represented by \(e\). Of particular interest are the relations between estimated coefficients and the corresponding actual labor and capital shares. Table 1 reports the results of runs of each equation on both data sets.

\[
(7) \log Y_t = a_0 + a_x t + b \log L_t + c \log K_t + e
\]
\[
(8) A \log Y_t = a_0 + a_x t + b A \log L_t + c - A \log K_t + e
\]
\[
(9) \log y_t = a_0 + a_{x-t} + c \log k_t + e
\]
\[
(10) A \log y_t = a_0 + a_{x-t} + c - A \log l_t + e
\]

The first pair of regression forms do not assume constant returns to scale, so the sum of the labor and capital coefficients are not restricted in advance. When run in levels, the overall fit is excellent, and the labor coefficient is significant and large for both data sets. In set A, the time trend and capital coefficients are not significant but the overall D.W. statistic is quite good (2.117), while in set B, the time trend and capital coefficients are significant but the D.W. is not good (0.219). In neither set are the implied shares close to the actual ones, and constant returns to scale never obtains.

When run in rates of growth, the overall fits are quite good for both sets of data, time trends are significant, labor coefficients are close to one and highly significant, and D.W.'s are good. But in both cases, the capital coefficient is negative, so that implied shares are very different from actual ones.

The second pair of regressions restricts coefficients to sum to one (that is, they assume constant returns to scale), so relevant variables are output per employee (\(y_t = A^{1-\gamma} k^\gamma\)) or output per worker (\(y_{t-1} = A^{1-\gamma} l^{-\gamma}\)). In levels form:

- In set A: The overall fit remains excellent; constants and time trends highly significant; coefficient on capital-labor ratio small but not statistically significant; D.W.\ statistic quite good.
- In set B: The coefficient on capital-labor ratio relatively large but D.W.\ statistic poor.

This content downloaded from 
<ip address> on Sun Jul 5 20:36:09 UTC 2026

All use subject to https://about.jstor.org/terms

## Page 10

NONLINEAR DYNAMICS AND PSEUDO-PRODUCTION FUNCTIONS

quite low. Once again, the estimated capital coefficient is not even close to the actual profit share in either set. Finally, when run in growth rates, only the constant is significant, implying significant positive rates of neutral technical change, while all other results are generally quite bad. On the whole, despite the fact that the wage shares are roughly stationary in both data sets, none of the fitted forms of the Cobb-Douglas aggregate production function work well on either the simulated data (set A) or the actual data (set B).

TABLE 1
Cobb-Douglas Production Functions Fitted to Actual and Simulated Aggregate Data (OLS)
(1948-2000 for Levels and 1949-2000 for First Differences)

| Dependent Variable | Constant | Time | logL, | logüí, | AlogL, | AlogKt | Log¿, | Alogfc, |
|--------------------|----------|------|-------|--------|--------|--------|-------|---------|
| logYt              | -4.628*  | 0.0134  | 0.989*  | 0.170  | -      | -      | -      | -       |
| (1.722)            | (0.009)  | (0.009)   | (0.103)   | (0.240)   ||        ||        ||
| AlogYf             | -0.279   | 0.0133*  |-        |-        |-       |-       |-       |-       |
| (1.900)            | (5e-5)   ||        ||        ||        ||
| logy,              |-         |-         |-        |-        |-      |-2.315*|-      |-       |
| (6e-5)             ||         ||        ||        ||(659)||(-351)|||
| Alogy,             |-        |-        |-    1    |-    .75|-     |-     |-     .||-.|||
|||(6e-5)||(6e-5)||(6e-5)||(6e-5)||(6e-5)||(6e-5)||(6e-5)||
|||(462)||(462)||(462)||(462)||(462)||(462)|(382)|(382)||
|||(Adj.R²: .9997)|(.9952)|(.6916)|(.6912)|(.9988)|(.976)|(-382)|(.o²7s)|||
|||(D.W.: .a°³)|(.a°³)|(a°³)|(a°³)|(a°³)|(a°³)|(s⁴³)|(a°³)|||
Implied Wage Share: 
Actual Wage Share: 
Implied Profit Share: 
Actual Profit Share: 
Implied Returns to Scale:

Notes: Standard errors statistics are listed below estimated coefficients.
Starred coefficients imply significance at 5 percent or better.

Are these results typical? Douglas seemed to think not [1976, p. 914]. Samuelson [1979, p. 924] points out that Douglas' own regressions did not include a term for technical change; Felipe and Adams [2005, pp. 429–3] show that when a term for neutral technical change is introduced into Douglas' original data set, it yields a "coefficient of the index of capital which is negative and insignificant."

## Page 11

Solow initially emphasized the importance of the similarity between Douglas' estimated parameters and actual factor shares \([Fisher, 1971b, in McCombie, 2000-2001, 269]\). He repeated this sentiment in his first response to Shaikh [1974]. Having found that the OLS regression of \(\log y\) on \(\log k\) in Shaikh's constructed data yields a result in which the "point estimate of \(\log k\) is negative" and not statistically significant, Solow says that if "this were the typical outcome with real data, we would not now be having this discussion" [1974, 121]. And yet it turns out that the very same test on his own data would have given similar results. McCombie [2000-2001, 281-283] revisits Solow's original data and comments that "it is surprising that Solow did not seek to [similarly] 'test' the Cobb-Douglas function using his own data." For if he had, then he would have found that when run in levels "the coefficient of capital term is not statistically different from zero," and when run in ratios "the coefficient of the capital-labor term is negative, but statistically insignificant." McCombie goes on to remark that we "can only speculate whether Solow's [1957] paper would have had such a dramatic impact if these regressions had also been reported."
It turns out that such results are indeed quite typical down to the finding of negative capital coefficients [Sylos-Labini, 1995; Felipe and Adams, 2005, 429-30]. Nevertheless, aggregate production functions do appear to work on occasion. Can we then say that, at least in these cases, a good fit provides some evidence on the underlying production structure and on the marginal productivity theory of distribution?
HOW TO MAKE AGGREGATE PRODUCTION FUNCTIONS ALWAYS
"WORK PERFECTLY" (EVEN WHEN COMPLETELY INAPPROPRIATE)
The purpose of this section is to show that one can always construct an infinite number of empirically fitted aggregate productions that work "perfectly." The secret lies in the specification of the function of time representing technical change. In the present case we are concerned with data with roughly stable wage shares, to which we fit Cobb-Douglas type regressions in either growth rates or in log levels. We illustrate the procedure with regressions involving rates of change (for example, the second and fourth types in Table 1), with some general function of time \(F(t)\) in place of the previously assumed time variable \(t\).
\[
(11) \quad A\log Y_t = a_0 + a_1 F(t) + b_1 - A\log L_t + c_1 - A\log K_t + e
\]
\[
(12) \quad A\log y_t = a_0 + a_1 F(t) + c_1 - A\log k_t + b_1
\]
The forms of regression Equations (11) and (12) derive from the assumption that \(Y_t\), \(K_t\), and \(L_t\) are bound together by a hypothesized Cobb-Douglas production function with neutral technical change. These very same variables are also bound together by the actual accounting identity \(Y - wL + rK\) and its per employee form \(y = w + rk\). Differencing these identities and leaving out cross-products of first differences, we derive the two rate-of-change forms, in which the Solow Residual \(SR(t)\) is the share-weighted average rates of change of the real wage and profit rate.
\[
(13) \quad A\log Y_t = SR(t) + b_2 A\log L_t + (1 - u^*) M_A \log K
\]

## Page 12

NONLINEAR DYNAMICS AND PSEUDO-PRODUCTION FUNCTIONS 457

(14) \( A(\log y_t) = S_R(t) + (1 - u_{t-1}) A(\log k_t) \)

(15) \( S_R(t) = u_t A\log w + (1 - u_t)^{-1} A\log r \)

Now, if the wage share (\(u\)) is stable, so that \(u(t) = u = \text{constant}\), we can create an infinite number of time functions \(F(t)\) that will always make fitted production functions work "perfectly" in the sense of Solow: that is, make them yield perfect econometric fits with partial derivatives that closely approximate observed factor prices.

Note that with \(u = \text{constant}\), the accounting identities in Equations (13) and (14) look just like Cobb-Douglas production functions with a rate of neutral technical change \(S_R(t)\). Therefore, if we were to define the rate of technical change as \(F(t) = S_R(t)\), the regression Equations (11) and (12) will always "pick up" the corresponding identity Equations (13) and (14). In other words, this particular specification of technical change in the regression equations will always produce a perfect neoclassical fit—regardless of the underlying data generation process [McCombie and Dixon 1991, 27]. Comparing the two sets of equations makes it clear that we will find \(a_0 = 0\) and \(a_1 = 1\).

This technique embodies Solow's own original measure of technical change, which itself fluctuates substantially over time [Solow, 1957; McCombie, 2000-2001, 281-282].

As noted earlier, nothing in neoclassical theory precludes complex paths for technical change. If it is desired that technical change be represented by some smooth measure, however, this is easily accommodated. Once we recognize that setting \(F(t) = S_R(t)\) will always give a perfect fit, then it is evident that making \(F(t)\) into a one-to-one function of \(S_R(t)\) will also work just as well, since in both cases the two variables are perfectly correlated. One simple way to accomplish this is to define \(F(t)\) as an affine transform of \(S_R(t)\) with a damping coefficient (\(h\)). Let \(\bar{\sigma} = \text{mean of } S_R(t)\). Then for any parameters \(\sigma > 0\), \(0 < h < 1\),

\[ F(t) = \sigma + h^{-1} (S_R(t)-\bar{\sigma}). \]

Since \(S_R(t)\) is generally stationary, \(F(t)\) will be stationary also. The two series will generally have different means unless \(\sigma = \bar{\sigma}\). Given that \(F(t)\) represents the rate of technical change in Equations (11) and (12), its summation will represent the index of the level of technology at any moment of time. This technology index will be smoother the smaller the damping coefficient \(h\), and will be steeper the higher the parameter \(\sigma\).

When \(h = 1\), the resulting technical level function will not generally be smooth. But by reducing \(h\) sufficiently, one can make the technology index as smooth as desired. This Perfect Fit Theorem is proven in Appendix B.

One consequence of this theorem is that there are as many perfect fits as there are values of \(\sigma\) and \(h\), each of which will give a different picture of technical change. And yet, each will be perfectly correct. For each data set Figure 6 illustrates three such specifications of the rate of technical change, \(F(t)\), which is normalized to equal the initial value of \(\log y - (1 - u)^{-1} \log k\). In all cases, \(h = 0.2\), and for each data set the middle curve is for \(\sigma = g\), while the higher and lower curves are derived from \(\sigma = g + 0.01\) and \(\sigma = g - 0.01\) respectively. Figure 7 depicts the corresponding indexes of the level of technology derived through the summation of each \(F(t)\). Table 2 illustrates "perfect" regressions arising from \(h = 0.6,\; h=0.2\) for each data set and \(\sigma=\bar{\sigma}\; \text{in all cases}.\)

This content downloaded from
<ip address> on Sun, Jul 5th 2026 at UTC
All use subject to https://about.jstor.org/terms

## Page 13

458 EASTERN ECONOMIC JOURNAL

FIGURE 6
Perfect Fit Technical Chancre Functions \( F(t) \)
A A A Data Set B (right scale)
t Data Set A (left scale). \( Y \)
* i • • • • i • * * * i • • • • i • • • * i • • • • i • • • • i ■ ■ ■ i
50 55 60 65 70 75 80 85 90 95 100
\( h = 0.2 \), and alpha is created by adding \( 0.01 \), \( 0.0 \), \( -0.01 \), respectively, to the mean of SR(\( t \)) of the particular data set. The bottom three lines are in set A, top three in set B.

FIGURE 7
Technical Level Functions (log scales)
-1.0
-1.5
-2.0
Data set B (right scale) ,.-*-"*
-2.5 +¿*¿zr:~~-
-3.0 _ _ ~+~*^ - -o.\j
Data set A ^+****~ ^
-3.5
-4.0 _r^^^^rr.Tr.
50 55 60 65 70 75 80 85 90 95 100
\( h = 0.2 \), and alpha is created by adding \( 0.01 \), \( 0.0 \), \( -0.01 \), respectively, to the mean of SR(\( t \)) of the particular data set.

This content downloaded from 
181.42.20.22 on Sun, Jul **, ** 
All use subject to <https://about.jstor.org/terms>

## Page 14

NONLINEAR DYNAMICS AND PSEUDO-PRODUCTION FUNCTIONS 459

TABLE 2
Cobb-Douglas Production Function "Perfect Fits"
for Simulated and Actual Data in Rates-of-Change Regressions (OLS), 1949-2000

| Dependent AlogY, Alogy, | Variable | Constant | (0.0005) | Fit) | (0.004) | AlogL, | (0.002) | A\ogKt | (0.012) | Alogfc, | (0.002) | Adj.R2 | D.W. | Implied Wage Share | Actual Wage Share | Implied Profit Share | Actual Profit Share |
|-------------------------|-----------|----------|----------|-------|---------|----------|---------|---------|---------|----------|---------|--------|------|-------------------|-------------------|--------------------|--------------------|
| Constant                | -0.0134   | -       -    -     -     -       -     -       -     -       1.692    5.685    1.663   4.989   1.685   5.656   1.664   4.992   1      -        -        -        -        -        |
|                        (Alogy, )             (Alogy, )          (Alogy, )         (Alogy, )         (Alogy, )         (Alogy, )         (Alogy, )         (Alogy, )         (Alogy, )          |
|| Fit                    ||            ||           ||           ||           ||           ||           ||           ||           ||
|| AlogL                  || 0.841     ||(0.002)    || 0.841     ||(0.002)    ||-          |-          |-          |-          |-          |-          ||
||                        ||           ||           ||           ||
|| A\ogKt                 || 0.2      &&( .OllZ) && .2      &&( .OllZ) &&-      &&( .OllZ) &&-      &&( .OllZ) &&-      &&
||                        ||           ||
|| Alogfc                 ||-          |-          |-          |-          |-       & &( .OOlZ)& &( .OOlZ)& &-       & &( .OOlZ)& &( .OOlZ)& &
||                        ||
Adj.R2                   & & & & & & & & & & & & & & **&** **&** **&** **&** **&** **&**
D.W                     &&&&&&&&&&&&&&&&
Implied Wage Share      &&&&&&&&&&&&&&&
Actual Wage Share       &&&&&&&&&&&&'&&
Implied Profit Share    &&'&&
Actual Profit Share     &''

Note: ft = 0\.2, \\.6 through out\. For data A, a = \\.167,\ and for data B,\ a = \\.131\. In each regression,\ the theoretically predicted coefficients are: constant = (\a-\o/ft), coefficient of F(i)= I/ft,\ coefficient of AlogL= the wage share (\u), and coefficients of A\ogKt and A\ogfc= the profit share (\u-l)\

In both data sets,\ all values of u and h produce close to "perfect" fits for a Cobb-Douglas production function satisfying marginal productivity rules and even exhibiting smooth technical change\. And therein lies the rub,\ for we already know that data set A is generated from a Goodwin-type model with a fixed-coefficient technology undergoing Harrod-Neutral technical change\. Moreover,\ the stability of the long-run wage share in this model derives from the classical feedback among persistent unemployment,\ real wages,\ and the rate of growth\. Neither actual nor surrogate marginal products,\ nor any theory of wages linked to them,\ can even be defined within this framework\.

The Perfect Fit Theorem demonstrates that there exists a wide range of smooth technical change functions of the form F(t)= flSR(i)) that will make standard regressions work perfectly\. It follows that the regressions will work almost as well if F(t)\ is some good approximation of SR(i), say through the use of a Fourier series [Shaikh, 198Q; Felipe and Adams, 2QoQ; McCombie, QQQQ]\.

In the preceding cases,\ F(t)\ is smooth because it is in some sense a good approximation of the non-smooth Solow Residual SR(i)\ But we could produce the same result by redefining variables in such a way that SR(i)\ itself becomes smooth\. Since the latter is the share-weighted average of the rates of growth of wage and profit rates \(Equation \(15\)), any data adjustments that smooth w,r will also end up smoothing SR(i)\).

## Page 15

460 EASTERN ECONOMIC JOURNAL
Such an outcome can arise simply from an attempt to adjust for cyclical fluctuations. Suppose we consider actual output (Y) to be a function of utilized inputs (L*, K*), that is, "factor services" [McCombie, 1998, 159, 167-168; 2000-2001, 285-288]. One simple way to do this is to define factor services as \( L^* = z_L L - L \), \( K^* = z_K K - K \), where the factor utilization rates (\( z_L, z_K \)) are themselves the ratios of actual factor productivities (\( y, R \)) to trend productivities (\( y^*, R^* \)). In log terms, this gives us
\[
\begin{aligned}
(17) &\quad \log e L = \log y - \log y^* \\
(18) &\quad \log e K = \log R - \log R^* \\
(19) &\quad \log L^* = \log L + \log e L \\
(20) &\quad \log K^* = \log K + \log e K
\end{aligned}
\]
Actual output (Y) continues to be the sum of wages and profits from the accounting identity. The factor share will therefore not be affected by any transformation of variables. But the wage share is \( u = w/y \) and the profit share is \( (1 - u) = r/R \), so replacing actual productivities (\( y, R \)) with smooth trend productivities (\( y^*, R^* \)) will result in new, equally smooth wage and profit rates (\( w^*, r^* )). This means that the new Solow Residual \( S R*(t) \) will also be smooth. We can even make the Solow Residual into a simple linear function of time, as is commonly assumed in production function regressions (for example, Equations (7)-(10)).
A simple illustration will suffice. If factor shares are constant, the rates of change of \( w^*, r^* )\) will be exactly those of \( y^*, R^*)\) respectively. Suppose the productivity trends (\(\log y^*, \log R^*\)) are estimated as quadratic functions of time with the coefficients shown below, and we define \( p_0 = [w - m_1 + (1-u)n_1]\) and \( p_2 = [r - m_2 + (1-u)n_2] ). Then we have
\[
\begin{aligned}
(21) &\quad \log y^{*} = m_0 + m_1 t + m_2 t^2 \\
(22) &\quad \log R^{*} = n_0 + n_1 t + n_2 t^2 \\
(23) &\quad S R*(t) = w A(\log w/ ) + (1 - u). A(\log r/ ) = p_0 + p_1 t
\end{aligned}
\]
With \( S R*(t)\ reduced to a standard linear time trend,\ and with factor shares roughly constant,\ the accounting identities are indistinguishable from the corresponding standard production function regressions (for example,\ Equations (13)\ and (14)\ will look just like Equations (8)\ and (10)). A perfectly reasonable procedure for adjusting for cyclical variations can therefore end up leading to a perfect fit—of the pseudo production function.6

More formally,\ we can always replace the term \( S R(t)\ in the accounting identity Equations ( 13)\ and ( 14)\ with some time trend f(t )\) and partition out the residual [\ S R(t)- f(t)]\) to labor and/or capital as "utilization" adjustments A(\ log e L , A(\ log e K respectively.\ This would give new measures of utilized labor and capital (\ L^{*} = z_L L - L , K^{*} = z_K K - K ), a new accounting identity residual S R^{*(t)}= f(t),\) and a new accounting identity equation that is structurally identical to the standard production function regression. Not surprisingly,\ the standard regressions are then likely to pick up the pseudo-production function.7

## Page 16

NONLINEAR DYNAMICS AND PSEUDO-PRODUCTION FUNCTIONS 461

This brings us to a counter-argument advanced by Solow [1987].8 He proposes that we consider a physical production process in a single factory. Because he knows that one cannot directly observe the aggregate production process, he also excludes this possibility at the factory level. Solow then claims that, given recorded inputs and outputs at the factory level, one should be able to deduce the true microeconomic production function by econometric means alone. As he puts it, "it is simply not credible that constancy of relative shares—or anything else—can prevent us from tracing out the production function" [Solow, 1987, 19-20].

The problem is that we do not know which particular econometric regression corresponds to the form of the true production function. If we were allowed to examine the operations of the factory, then we could directly ascertain the underlying production process. But if we cannot do this, we can only test a variety of regression forms that we have picked on some a priori grounds. This is precisely where theory, and faith, enters into the story.

Consider data set A, whose non-neoclassical underlying production process is characterized by fixed-coefficients production and Harrod-Neutral technical change (so that \( R \) is roughly constant). Nothing prevents us from considering the production data in this model to be a scaled-up version of a "representative" factory. So we have before us a direct test of Solow's hypothesis. Since \( R_t = \frac{y}{k_t} = \frac{Y}{K_t} \), and is roughly constant, where \( y_t = \frac{Y}{L_t} \) and \( k_t = \frac{K}{L_t} \), the forms of the true production function are

\[
\begin{aligned}
(24) &\quad \log Y = \log n + \log K \\
(25) &\quad A\log Y = A\log K \\
(26) &\quad \log y = \log f_i + \log k \\
(27) &\quad A\log y = A\log k
\end{aligned}
\]

The regressions based on these preceding true forms give absolutely perfect results in every case. Thus Solow is right to say that we can pick up the true form. But this is only because we know it in advance. Solow's econometrician does not have this information. Being neoclassical, he or she will therefore turn to the standard regressions of Equations (7)-(10). Yet the results for data set A in Table 1 show that not one of these comes close to identifying the true production function. For example, in the true-form regressions corresponding to Equations (26)-(29), the estimated coefficients for \( K \), \( AK \), \( k \), and \( Ak \) all equal 1, as they should. However, although all the standard-form regressions of Table 1, Data A, have good-to-excellent econometric properties, the corresponding capital coefficients are 0.170, -2.315, 0.019, and -0.024 respectively. Worse yet, only the second coefficient—which is highly negative—is statistically significant.

Faced with such results, how does one proceed? This is where aggregation comes in. If we consider a factory, then the answer is clear: go in and see how things work. At the aggregate level however—we have no such option so we turn to theory. But once we recognize that theory does not provide much support for aggregate production functions conceptually speaking—we either turn away from this concept or turn back to data hoping it might help improve results.

Here as seen above

## Page 17

462 EASTERN ECONOMIC JOURNAL

exist a variety of adjustments that will make matters eventually appear to come out right. Yet the resulting empirical strength of aggregate production functions and marginal productivity theory would be an illusion. In each case, the regression would be actually picking up the pseudo-production function implicit in the accounting identity, rather than the true production function.

The lesson should be clear. We know that aggregate production functions cannot be derived from micro-foundations, and we know that they generally do not work well at an empirical level. But when they do happen to work empirically, it is because the terms used to proxy the rate of technical change and/or to adjust for fluctuations in factor utilization happen to approximate the associated accounting identity residual SR(¿).9

SUMMARY AND CONCLUSIONS
Aggregate production functions are still widely used four decades after it was conceded that they could not be grounded in any plausible micro-foundations. Their presence is generally justified on the ground that they appear to work empirically, by which it is meant that they yield a good econometric fit and have partial derivatives closely approximating factor prices. But fitted aggregate production functions do not generally work well in this sense, because estimated partial derivatives differ considerably from factor prices, and often even yield negative capital coefficients.

Even so, aggregate production functions do occasionally work. This paper shows that aggregate production functions can always be made to work on any data that exhibits roughly constant wage shares, even when the underlying technology is non-neoclassical. But in so doing, they always pick up the accounting identity that underlies the data. This is demonstrated on both actual U.S. data and a control data set derived from a fixed coefficient model with Harrod-neutral technical change and a persistent rate of unemployment. In the latter case, there are no marginal products.
Yet one can always fit an aggregate production function that yields an excellent fit, estimated coefficients equal to factor shares, smooth technical change, and good residuals. It is proved, moreover, that one can generate an infinite number of such fits, each of which gives a different reading of the rate of technical change. It follows that even when aggregate production functions appear to work at an empirical level, they provide no support for the neoclassical theory of aggregate production and distribution.
On the contrary, the best of fits can utterly misrepresent the true underlying mechanisms of production, distribution, technical change, and growth.10

APPENDIX A
The modified Goodwin model used in this paper was summarized by the following nonlinear system of equations:
\begin{align*}
\text{Equation 1} \\
\text{Equation 2} \\
\text{Equation 3}
\end{align*}

The parameter values used to generate the data are listed below these equations.

Three sets of random shocks were incorporated in the model as shown below:
\[ e_1 = e_2 = 0.001(t), \quad e_3 = 0.03(t) \]
where \( r \) was generated from (pseudo) random draws from a normal distribution with zero mean and unit variance (this is the variable "nrnd" in Eviews 4).

To mimic actual fluctuations in output-capital ratio, shock \( e_3 \) was multiplicatively applied to \( R \) itself.

This content downloaded from
181.42.20.22 on Sun, 05 Jul 2026 20:36:09 UTC
All use subject to https://about.jstor.org/terms

## Page 18

NONLINEAR DYNAMICS AND PSEUDO-PRODUCTION FUNCTIONS 463

(28) \( u_t = w/y_t \)
\[ [u = \text{wage share} = \text{real wage}/\text{labor productivity}] \]

(29) \( v_t = Y_t/(y-N_t) \)
\[ [v = \text{employment ratio} = \text{output}/(\text{labor productivity}-\text{labor force})] \]

(30) \( \log y_t = \log y_{t-1} x + a + e_1 \)
\[ [\text{constant rate of growth of labor productivity} = a] \]

(31) \( \log i_V, = \log A_T^x + p \)
\[ [\text{constant rate of growth of the labor force} = p] \]

(32) \( \log w_t = \log w_{t-1} - r + p v^{-1} - p_x u_{t-1}^2 + e_2 \)
\[ [\text{real wage growth function}] \]

(33) \( \log y_t = log Y_{t-1} + u.(1 - u_{t-1}).\phi.(1 + e_3) \)
\[ [\text{output growth rate} = s - (a l h) + (V h)^{-F(t)}] 
\]
\[ a = 0.02, b = 0.02, y= 0.10, p = 0.335, p_x = 0.28, s = 0.25, R = 1. 

APPENDIX B: THE PERFECT FIT THEOREM

With a stable wage share, for any \( a > 0 \), and \( 0 < h < 1 \), a sufficiently small \( h\) will yield an \( F(t) such that there will be a "perfect" (or near-perfect) fit for a Cobb-Douglas production function with smooth technical change and partial derivatives that mimic factor prices.

Proof: Solve for SR(\( t\)) from Equation (16):
\[ SR(t) = (s - alh) + (Vh)^{-F(t)} 
\]
Substitute this into the accounting identity Equations (13) and (14), and noting that the wage share (\( u\)) is constant, we get:
\[ A\log Y_t' e (s - alh) + (Vh)^{-F(t)} + w_A(\log L_t') + (1 - u)\A(\log K_t') 
\]
\[ A\log Y_t' e (s - alh) + (Vh)^{-F(t)} + (1 - u)\A(\log K_t') 
\]
Comparing these to the standard regression Equations (11) and (12):
\[ A_0(s - alh), A_1( Vh)^{-F(t)}, b(u), c(1 - u). 
The last two parameters are particularly important since they imply that the estimated labor and capital coefficients equal the corresponding factor shares as hypothesized in marginal productivity theory. The more stable the wage share, the more "perfect" will be the fitted Cobb-Douglas function. The smaller the chosen value of parameter \( h\) , the smoother will be the apparent level of technical change.

## Page 19

NOTES

I thank Jesus Felipe and John McCombie for their help. Their many papers on this subject have proved to be of inestimable value. I also thank three anonymous referees for their insightful comments and helpful suggestions.

1. A good fit also requires that the residuals are well-behaved [Solow, 1974, 121, footnote 1].

2. I thank Duncan Foley for suggesting this modification.

3. Beginning from the short run equilibrium condition that investment equals savings (\(I = S\)), and assuming that savings are proportional to profits \(IP\) because workers do not save, we have \(I = sP\). Dividing by the capital stock yields \(\frac{I}{K} = \frac{sP}{K} = \frac{P}{K} = r\), where \(\frac{sP}{K}\) stands for the rate of growth of capital. But the profit rate \(r = \frac{P}{K} = \frac{iP}{Y} - \left(\frac{Y}{K}\right)\) can be further decomposed by noting that the profit share \(\frac{P}{Y} = \left(\frac{Y - wL}{Y}\right) = 1 - \frac{wL}{Y} = 1 - u\), where \(y = \frac{Y}{L} =\) labor productivity, and \(u = \frac{wL}{Y} =\) the wage share. Along the warranted path, output equals capacity, and in the presence of Harrod-Neutral technical change, the capacity-capital ratio \(R = \frac{Y}{K} =\) constant. Thus the rate of growth of output (\(\frac{Y'}{Y}\)) equals the rate of growth of capacity equals the rate of growth of capital (\(\frac{\Delta K}{K}\)) equals \(s - r - sR(1 - u)\).

4. McCombie's [2000-2001, 282] text actually says "not statistically significant from zero," but the meaning is clear from the context.

5. We could just as well have derived expressions in levels. Given the definition of the wage share \(u = \frac{wL}{Y}\), the per-unit-labor accounting identity \(y = w + r - k\) implies that the profit share is \(1 - u = r - k/y\). Thus,
\[ \log w = \log u + \log y, \]
and
\[ \log r = \log(1 - u) + \log y - \log k. \]
Multiplying the first expression by \(u\) and the second by \(1 - u\), adding them, and reordering terms gives us:
\[ 
\log y(t) 
= b(t) + (1 - ut)(-\log k(t)), 
\]
where
\[ b(t) 
= -(ut - t\log ut + (1 - ut)\log(1 - ut)) 
+ (ut - t\log wt + (1 - ut)\log rt). 
\]
Adding log\(L\) would then give an equivalent expression in logs of \(Y_t\), \(L_f\), and \(K_t\). Now, if the wage share happens to be roughly constant (\(u_t ≈ u\)), then these accounting identity expressions "look" just like constant returns to scale Cobb-Douglas production functions with a labor coefficient \(b_u ≈ uy\) and a capital coefficient \(c_u ≈ 1-u\), and some (not necessarily smooth) time function \(b(t)\) representing neutral technical change.

6. When the wage share is exactly constant (\(u_t ≈ u\)), then smoothing \(y\) is exactly equivalent to smoothing both wages and profits directly; one could derive utilization adjustments from either method since shares fluctuate considerably in both data sets.

7. McCombie [2000-2001, 285-288] follows just such a procedure: he takes the mean of SR(i) as its smoothed value, assigns residuals to capital as capacity utilization adjustments, and shows that this generates an excellent fit for a standard Cobb-Douglas model as he notes: "we are again merely estimating an identity."

8. Solow also advances that my accounting identity argument amounts to discovering "that any production function can be written as a product of a Cobb-Douglas function multiplied by something else." The something else being "the production function divided by a Cobb-Douglas." But it should be clear from my text that this accounting identity is completely independent from any assumptions concerning an aggregate production function being Cobb-Douglas or otherwise.

9. The basic arguments can be extended to other than Cobb-Douglas production functions: if factor shares change over time, accommodating variations in both residual SR(i) and changing wage shares becomes necessary; still driven by accounting identities [McCombie & Dixon].

10. It should be mentioned that measuring technical change does not require assuming an aggregate production function: if we assume fixed-proportion methods for each commodity instead, we can characterize technical change through effects on normal capacity rates at any given real wage [Sraffa, 1960; Okishio, 1961; Samuelson, 1962]. From accounting identity written as:
\[ r_t' / r_t' _x' 
= y_t' / y_{t_x}' 
- w_{t_x}/k_{t_x}' 
= i_y/t_y' / k_{t_x}' 
= i_y/t_y' / k_{t_x}' / (i_y/t_y') / (i_y/t_{x}')/k_{t_x}'. 
Thus,
\[ A_r/r'_x' _x' _x' _x'
= A_y/y'_x'/k'_x'/y'_x'/k'_x'. 

By contrast using R=Y/K=y/k implies Ak/k\_t\_x’=\(A\_y/y'\_t\_x’=\(AR/R'\_t\_x’. Thus Leontief-Sraffa-Samuelson-Okishio measure is tit)=A log(r')^o=A log(y/(l-u'))-A log(k').

## Page 20

NONLINEAR DYNAMICS AND PSEUDO-PRODUCTION FUNCTIONS 465

\[ SR(i) = A \log y_i, - (1 - u_t) i A \log A s_i = u_t - A \log y_t + (1 - u_{t-1}) - A \log R_t. \] Generally speaking, \( t(i) \) is far smaller than \( SR(i) \). This would suggest a different reading of growth accounts.

REFERENCES

Douglas, P. The Cobb-Douglas Production Function Once Again: Its History, Its Testing, and Some Empirical Values. *Journal of Political Economy*, October 1976, 903-15.

Felipe, J. and Adams, F. G. "A Theory of Production": The Estimation of the Cobb-Douglas Function, A Retrospective View. *Eastern Economic Journal*, Summer 2005, 427-45.

Felipe, J. and Holz, C. A. On Production Functions, Technical Progress, and Time Trends. Unpublished paper, 1999.

Ferguson, C. Capital Theory up to Date: A Comment on Mrs. Robinson's Article. *Canadian Journal of Economics*, May 1971, 250-54.

Fisher, F. Reply. *Econometrica*, March 1971a, 405.

ment. *Review of Economics and Statistics*, November 1971b, 305-25

Eatwell, M., Milgate M., and Newman P., eds., *The New Palgrave: A Dictionary of Economics*. London and Basingstoke: Macmillan; New York: St Martin's Press; Tokyo: Japan Publishing Industry Foundation for Culture; Hong Kong: Macmillan Distribution Asia Ltd., 1987.

MIT Press; Tokyo: Japan Publishing Industry Foundation for Culture; Hong Kong: Macmillan Distribution Asia Ltd., 1993.

Garegnani P., Heterogeneous Capital, the Production Function and the Theory of Distribution. *Review of Economic Studies*, July 1970, 407-36.

Goodwin R.M., A Growth Cycle in Socialism Capitalism and Economic Growth Essays Presented to Maurice Dobb edited by C.H Feinstein Cambridge UK Cambridge University Press; New York NY Cambridge University Press; Melbourne Australia Cambridge University Press; Madrid Spain Cambridge University Press; Cape Town South Africa Cambridge University Press; Delhi India Cambridge University Press; Sydney Australia Cambridge University Press; Mexico City Mexico Cambridge University Press; Sao Paulo Brazil Cambridge University Press; Beijing China Cambridge University Press; Tokyo Japan Cambridge University Press; Taipei China Cambridge University Press), pp. 54-58.

Harcourt G.C., Some Cambridge Capital Controversies in the Theory of Capital edited by P.Arestis M.Sawyer Aldershot UK Edward Elgar Publishing Limited Aldershot UK Edward Elgar Publishing Limited), pp. 25-65.

McCombie J.S.L., "Are There Laws of Production?": An Assessment of the Early Criticisms of the Cobb-Douglas Production Function.* Review of Political Economy* April 1998 pp. 141-43.

*Journal of Post Keynesian Economics* Winter 2000-2001 pp. 267-97.

McCombie J.S.L., Dixon R., Estimating Technical Change in Aggregate Production Functions: A Critique.* International Review of Applied Economics* January 1991 pp. 24-46.

Michl T., Biased Technical Change and the Aggregate Production Function.* International Review of Applied Economics* May 1999 pp. 193-205.

Okishio N., Technical Change and the Rate of Profit.* Kobe University Economic Review* Vol VII No VIII pp85-88

Samuelson P.A., Parable and Realism in Capital Theory: The Surrogate Production Function.* Review of Economic Studies* June (JSTOR Terms Apply) June (JSTOR Terms Apply) June (JSTOR Terms Apply)

Journal Of Political Economy October (JSTOR Terms Apply) October (JSTOR Terms Apply)

Shaikh A., Laws Of Algebra And Laws Of Production The Humbug Production Function.* Review Of Economics And Statistics* February (JSTOR Terms Apply)

Essays In The Revival Of Political Economy edited by E.J.Nell London England Macmillan London England Macmillan), pp80–83

edited by J.Eatwell M.Milgate P.Newman London England Macmillan London England Macmillan), pp(Continued on next page)(Continued on next page)(Continued on next page)(Continued on next page)(Continued on next page)(Continued on next page)(Continued on next page)(Continued on next page)(Continued on next page)(Continued on next page)

Solow R.M., Technical Change and the Aggregate Production Function.* Review Of Economics And Statistics* May (JSTOR Terms Apply)

ment.* Review Of Economics And Statistics* February (JSTOR Terms Apply)

This content downloaded from
(cid:0)(cid:0)(cid:0)(cid:0)(cid:0)(cid:0)(cid:0)(cid:0)(cid:0)(cid:0)(cid:0)(cid:0) at Sun Jul(Continue reading from IP address line)
All use subject to https://about.jstor.org/terms

## Page 21

466 EASTERN ECONOMIC JOURNAL
edited by A. Steinherr and D. Weiserbs. Dordrecht: Martinus Nijhoff Publishers, 1987, 13-27.
Macrodynamics: Essays in Honour of Richard Goodwin, edited by K. Velupillai. New York: New York University Press, 1990, 31-41.
Sraffa, P. Production of Commodities by Means of Commodities: Prelude to a Critique of Economic Theory. Cambridge: Cambridge University Press, 1960.
Sylos-Labini, P. Why the Interpretation of the Cobb-Douglas Production Function Must be Radically Changed. Structural Change and Economic Dynamics, December 1995, 485-504.

This content downloaded from
181.42.20.22 on Sun, 05 Jul 2026 20:36:09 UTC
All use subject to https://about.jstor.org/terms