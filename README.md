# *Bacillus cereus* in reconstituted infant milk: statistical analysis

Analysis of *B. cereus* counts (vegetative cells and spores) in reconstituted infant milk,
comparing two reconstitution methods (FDA, WHO) over time at three storage temperatures.
The analysis is delivered as an R Markdown report.

## Study design

- **Outcomes:** log10 counts of vegetative cells and of spores (already log-transformed in the data file).
- **Factors:** Time (0, 6, 24, 30, 36, 48, 54, 72 h), Treatment (FDA, WHO), Temperature (4, 10, 20 °C).
- **Replication:** 3 replicates per combination (balanced: 8 × 2 × 3 cells, 144 observations per outcome).
- **Time 0** is a single baseline measurement shared by all temperatures (copied to each temperature in the data).
- **Independence:** three independent milk samples were prepared; a separate tube was used for each time point
  and temperature. Tubes are therefore neither fully independent nor repeated measures on the same unit.
  All p-values should be read as indicative.

## Data

`Cereous.xlsx`, one sheet per outcome (first row is a title row, the table starts in row 2):

| Sheet               | Outcome          |
|---------------------|------------------|
| `Forme vegetative`  | vegetative cells |
| `Spore`             | spores           |

Long format, one row per observation: `Time`, `Treatment`, `Temperature`, followed by the log10 count
in the fourth column.

## Analysis

1. **Exploratory plots:** time courses, change from time 0, difference between methods.
2. **Three-way ANOVA** (Time × Treatment × Temperature, type III sums of squares, sum-to-zero contrasts),
   fitted because it was requested in the review. Holm correction over the 7 terms.
   Every term contains Time or Temperature, so one large effect (growth at 20 °C) makes almost every term significant.
3. **Diagnostics:** residual normality (Q–Q plots, Shapiro–Wilk) and equality of variances
   (pooled within-cell SD by temperature).
4. **Main analysis, stratified by temperature:** two-way ANOVA (Time × Treatment) within each temperature,
   with its own error variance (32 residual df). Holm correction over the 9 tests per outcome.
   Follow-up contrasts with `emmeans`:
   - effect of time within each treatment (Holm over 6 tests);
   - Dunnett comparison of each time against time 0, within temperature and treatment;
   - WHO − FDA at each time (Holm over 24 comparisons per outcome).
5. **Appendix:** sensitivity of the treatment effect to the time-0 baseline (models with and without time 0).

![Longitudinal trend](plot/Time%20courses.png)

## Contents of the report

| Section | Content |
|---|---|
| Introduction and design | Aim, design, limitation on independence |
| Exploratory analysis | Figure 1 (time courses) |
| Three-way ANOVA | Tables 1–2 |
| Diagnostics | Table 3, Figure S1 |
| Two-way ANOVA within temperature | Table 4, Figures 2–3 |
| Appendix | Tables 5–6, Figure A1 (with and without time 0) |
| Conclusions | Summary and limitations |

## Main results

- Growth occurs essentially only at 20 °C: vegetative cells increase by about 6.5 log10 within 48 h;
  spores increase only at 72 h (about +2.5 log10).
- At 20 °C the WHO method gives faster growth of vegetative cells between 6 and 36 h; both reach the same plateau.
- At 4 and 10 °C no change over time was detected. For spores WHO is lower than FDA at all time points
  (about −0.25 log10 at 4 °C and −0.44 log10 at 10 °C); the offset is already present at time 0.

## Limitations

- Tubes drawn from the same milk sample are not independent, and there are only three replicates per cell.
- Residuals for spores are not normal, and their variance is larger at 20 °C (pooled SD 0.42 vs about 0.20).
- A non-significant result does not show equivalence.
- Several findings are borderline (for example the spore difference at 30 h and 20 °C) and should be confirmed on more data.

## Repository Structure
```
├── data/
│   ├── raw/              # Original dataset
│   └── results/          # csv tables with results
├── plot/                 # All generated figures
├── settings.R            # Global settings and package loading
├── source_all.R          # Source all custom functions
└── report.Rmd            # Full analysis report
```
