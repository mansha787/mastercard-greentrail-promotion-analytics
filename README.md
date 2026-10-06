# GreenTrail Outdoors: Promotion Strategy Analysis

SQL-based analysis of historical in-store promotions for GreenTrail Outdoors, a fictional outdoor-gear retailer, with a recommended Test & Learn framework for future promotions that fit the company's sustainability values.

> Dataset provided by Mastercard (Data Analytics Job Simulation). It contains **25 store-promotion observations**. The findings are observational and are treated as hypotheses to be confirmed by a controlled test, not as proof of causal impact.

---

## Business Problem

GreenTrail's promotions are not delivering the impact the company wants, and they must also respect its sustainability ethos. This project answers five questions:

1. What happened in past promotions?
2. What additional data is needed?
3. How should a fair control group be built?
4. How long should a test run?
5. What does a data-driven, sustainable promotion strategy look like?

## Dataset

| Item | Description |
|---|---|
| Observations | 25 store-promotions (one per store), 14 variables |
| Promotion types | Buy-One-Get-One (BOGO), Discount, Special Event |
| Store types | Urban (13), Suburban (12) |
| Timing | Promotions started April to August 2023; 14 to 15 days long |
| Metrics | Weekly sales and average daily visits, before, during and after each promotion |

## Method

- **Data cleaning (SQL):** renamed columns, checked missing values, duplicate store IDs, negative values, invalid dates and sales anomalies. No issues found.
- **Uplift convention:** store-level % uplift is calculated first, then averaged for group comparisons. Pooled uplift (ratio of totals) was used as a cross-check and gives the same conclusions.
- **Segmentation:** results by promotion type, store type, and promotion x store type.
- **Store-mix adjustment:** each promotion's within-store-type results were re-weighted to the overall urban/suburban mix (52% / 48%), because Special Event ran in more urban stores.
- **Persistence:** post-promotion uplift and uplift decay were used to judge how much of the lift lasted.
- **Correlations:** Pearson correlation built in MySQL using `AVG` and `STDDEV_POP`.

## Key Results

**Overall**

| Metric | Before | During | After |
|---|---|---|---|
| Average weekly sales | $36,800 | $49,440 | $38,280 |
| Average daily visits | 357.2 | 447.0 | 380.2 |
| Avg store-level sales uplift | - | +35.23% | +4.59% |
| Avg store-level visit uplift | - | +25.67% | +7.00% |

**By promotion type**

| Promotion | Stores | Sales uplift during | Sales uplift after | Mix-adjusted during | Mix-adjusted after |
|---|---|---|---|---|---|
| BOGO | 8 | +30.44% | -1.94% | +30.78% | -1.78% |
| Discount | 9 | +36.84% | +5.64% | +38.09% | +6.37% |
| Special Event | 8 | +38.20% | +9.94% | +37.51% | +9.42% |

**Main findings**

- Promotions produce a strong short-term lift (+35.23%) that largely fades afterwards (+4.59%). Only about 13% of the lift remains once promotions end.
- Traffic drives the response: visit uplift and sales uplift have a correlation of 0.85. Spend per visit was about $14.72 before, $15.80 during and $14.38 after, so promotions appear to buy footfall more than larger baskets.
- BOGO is the weakest promotion in both store types and the only one with negative post-promotion uplift. 4 of 8 BOGO stores ended below their pre-promotion sales.
- Discount and Special Event are effectively tied during the promotion once store mix is accounted for. Special Event keeps more lift afterwards, and none of its 8 stores ended below baseline.
- Urban stores respond more than suburban stores (+41.76% vs +28.15% during). Store type, size (correlation with uplift 0.62) and promotion type overlap, so they need matching in any test.

## Recommendation

Run a controlled Test & Learn programme:

| Arm | Treatment | Role |
|---|---|---|
| A | Sustainability-themed Special Event (repair clinics, gear swaps, trail clean-ups) | Lead candidate |
| B | Targeted Discount on durable, repairable or sustainably made products | Second candidate |
| C | BOGO | Benchmark only |
| D | Matched control stores with no new promotion | Control |

- **Duration:** 4-week intervention plus 2-week post-period to measure persistence.
- **Measurement:** Difference-in-Differences against matched control stores.
- **Sample size:** about 60 stores in total to detect a 15-point difference in uplift (5% significance, 80% power). This is a planning estimate to be confirmed with real store data.
- **Extra data needed:** non-promoted comparison stores, transaction-level data, customer segments, promotion cost and discount depth, external factors (weather, events, competitors), and sustainability KPIs.

## Repository Structure

```
.
├── README.md
├── data/
│   └── GreenTrail_Store_Data.csv
├── sql/
│   ├── 01_GreenTrail_DataCleaning.sql
│   ├── 02_Greentrail_Analysis_v2.sql
│   └── 03_GreenTrail_Storytelling.sql
└── reports/
    ├── GreenTrail_Final_Report_Revised.pdf
    └── GreenTrail_Promotion_Insights.pptx
```

| File | Purpose |
|---|---|
| `01_GreenTrail_DataCleaning.sql` | Column standardisation and data-quality checks |
| `02_Greentrail_Analysis_v2.sql` | Main analysis: uplift, promotion and store segments, mix adjustment, correlations, persistence |
| `03_GreenTrail_Storytelling.sql` | Extra queries for the presentation (spend per visit, lift retained, stores below baseline) |
| `GreenTrail_Final_Report_Revised.pdf` | Full written report |
| `GreenTrail_Promotion_Insights.pptx` | Presentation deck |

## How to Reproduce

1. Create a MySQL database named `mastercard`.
2. Import `GreenTrail_Store_Data.csv` into a table called `greentrail_store_data`.
3. Run the scripts in order: `01`, then `02`, then `03`.

## Limitations

- Small sample: 25 observations, with 3 to 5 stores per promotion and store-type group.
- No clean control group, so causal impact cannot be identified.
- Promotion type, store type and store size overlap.
- All promotions ran in the same April to August window, so seasonality, weather, events and competitor activity are not separated.
- No transaction, customer, cost or sustainability data, so conversion and profit cannot be calculated.
- Each location appears once, so location-level results are single-store values and are not interpreted as location effects.

## Tools

MySQL(CTEs, window functions, aggregate statistics), Test & Learn design.

## Author

*Mansha Maulee*
