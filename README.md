# Predicting Company Returns

## EDA
1. Number of duplicate entries on COMPANIES column: 445
2. Distribution of Implied Return
![alt text](https://github.com/krishna-ov/PitchBook_Deals_Data/blob/main/eda_viz/TargetVar.png)
3. Percentage of Missing Values in Numerical Variables
   
| Variable | # of Missing Values | % of Missing Values |
|---- | ---- | ---- |
|PRE_MONEY_VALUATION| 36 | 0.021661 |
|POST_VALUATION | 33 | 0.019856 |
|DEAL_SIZE | 3 | 0.001805 |
|RAISED_TO_DATE | 3 | 0.001805 |

4. Relation between Implied Return and Missing Data
   
![DEAL_SIZE](https://github.com/krishna-ov/PitchBook_Deals_Data/blob/main/eda_viz/DealSize.png)

![DEAL_SIZE](https://github.com/krishna-ov/PitchBook_Deals_Data/blob/main/eda_viz/PreMonVal.png)

![DEAL_SIZE](https://github.com/krishna-ov/PitchBook_Deals_Data/blob/main/eda_viz/PostMonVal.png)

![DEAL_SIZE](https://github.com/krishna-ov/PitchBook_Deals_Data/blob/main/eda_viz/RaisedToDate.png)

- Comparing Medians
    - The median return is much higher for observations with missing data for DEAL_SIZE and RAISED_TO_DATE.
    - It might indicate that higher returns are associated with missing data for some reason.
    - The missing data might not be random and could be related to IMPLIED_RETURN.

- Comparing Standard Deviation
    -  The std for observations with missing data for DEAL_SIZE and RAISED_TO_DATE observations has a higher variability.
    - It might indicate that there's nire uncertainity or risk associated with those observation.

 5. Discrete Variables
    
![DEAL_SIZE](https://github.com/krishna-ov/PitchBook_Deals_Data/blob/main/eda_viz/MSE_Distr..png)

- We can expect higher returns for bigger market sizes

6. Continuous Variable

![DEAL_SIZE](https://github.com/krishna-ov/PitchBook_Deals_Data/blob/main/eda_viz/ContiVars_DIstr.png)

- All the continous variables are highly skewed!
- Skewness of the varaibles with respect to target variable

![DEAL_SIZE](https://github.com/krishna-ov/PitchBook_Deals_Data/blob/main/eda_viz/DealSize_skew.png)

![DEAL_SIZE](https://github.com/krishna-ov/PitchBook_Deals_Data/blob/main/eda_viz/PostMonVal_skew.png)

![DEAL_SIZE](https://github.com/krishna-ov/PitchBook_Deals_Data/blob/main/eda_viz/PostMonVal_skew.png)

![DEAL_SIZE](https://github.com/krishna-ov/PitchBook_Deals_Data/blob/main/eda_viz/RaisedToDate_skew.png)

- Since we are using tree-based methods: Random Forest Regressor and XGBoost Regressor, we are not dealing with skewness.


7. Temporal Variable Analysis

- Trend of Implied Return with respect to Year Founded

![DEAL_SIZE](https://github.com/krishna-ov/PitchBook_Deals_Data/blob/main/eda_viz/ReturnYearFound.png)

- Trend of Implied Return with respect to Deal Date

![DEAL_SIZE](https://github.com/krishna-ov/PitchBook_Deals_Data/blob/main/eda_viz/ReturnDealD.png)

- Trend of Implied Return with respect to Month of the Deal

![DEAL_SIZE](https://github.com/krishna-ov/PitchBook_Deals_Data/blob/main/eda_viz/ReturnDealM.png)


- Trend of Implied Return with respect to Number of Days from the Deal

![DEAL_SIZE](https://github.com/krishna-ov/PitchBook_Deals_Data/blob/main/eda_viz/ReturnDealDays.png)


8. Categorical Variable Analysis

- Cardinality

![DEAL_SIZE](https://github.com/krishna-ov/PitchBook_Deals_Data/blob/main/eda_viz/CatVarsDist.png)

  - Significant amount of columns have lower occurances of rare categorical labels. This might effect the model's performance.


9. Qualitative Variables

- SERIES: ['Series A', 'Series B', 'Series A1', 'Series A2', 'Series B1', 'Series B2', 'Series A3']
  
![DEAL_SIZE](https://github.com/krishna-ov/PitchBook_Deals_Data/blob/main/eda_viz/Series.png)


- Market Size Estimate: [1, 2, 3, 4, 5]
  
![DEAL_SIZE](https://github.com/krishna-ov/PitchBook_Deals_Data/blob/main/eda_viz/MSE_Distr..png)


- Valuation Tier: [$5M - $25M, $25M - $50M, $50M - $100M, $100M - $150M, >$1B]
![DEAL_SIZE](https://github.com/krishna-ov/PitchBook_Deals_Data/blob/main/eda_viz/ValuationTier.png)



## Model v1 - Baseline
- Model: Random Forest Regressor
- Test Data Evaluations:
  -   Mean Squared Error(MSE): 87.16560688505758

  -   Root Mean Squared Error(RMSE): 9.336252293348632

  -   Mean Absolute Error(MAE): 4.166229740336452

- Fetures:
  -  RAISED_TO_DATE
  -  DAYS_FROM_DEAL
  -  DEAL_SIZE
  -  POST_VALUATION
  -  Market Size Estimate
  -  FOUNDED_YEAR
  -  PRE_MONEY_VALUATION
  -  DEAL_MONTH
  -  PRIMARY_INDUSTRY_SECTOR
  -  Firms: Best Investors
  -  S&M Prior Role
  -  Valuation Tier
  -  Top Law Firm
  -  Finance Prior Role
  -  Firm: Worst
  -  Quality Deals Investors
 


## Results (top 20)

 | Company |	Actual Return	| Predicted Return | Actual Rank	 | Predicted Rank
 | ----- | ----- | ----- | ----- | ----- |
| Lendable (London)	| 100.691246	| 2.742442	| 1	| 242
| Socure |	44.234405	| 4.294435	| 2	| 159
| Aviatrix | 	41.600000	| 14.448822	| 3	| 28
| Whoop	| 38.749741	| 4.574037	| 4	| 147
| Weights & Biases	| 35.880000	| 7.473577	| 5	| 82
| Root Insurance (NAS: ROOT)	| 34.627885	| 4.410215	|6	| 154
| Better (NAS: BETR)	| 31.500000	| 4.578270 | 7	| 146
| Mux	| 28.848946	| 14.845385	| 8	| 26
| DataRobot	| 26.828270	| 21.933786	| 9	| 9
| Deel	| 21.043478	| 6.424968	| 10	| 94
| Pipedrive	| 18.947368	| 7.049248	| 11	| 86
| Starburst	| 18.611111	| 2.583623	| 12	| 259
| Shippo	| 15.294118	| 18.758218	| 13	| 15
| Lattice	| 15.000000	| 2.486096	| 14	| 266
| LeanIX	| 13.624070	| 3.419212	| 15	| 198
| Algolia	| 13.236791	| 8.751407	| 16	| 61
| Miro	| 12.551724	| 2.241039	| 17	| 288
| Built Technologies	| 11.142857	| 4.491506	| 18	| 151
| Density	| 10.920000	| 1.608605	| 19	| 324
| Ethos Life	| 10.400000	| 6.576403	| 20	| 91
