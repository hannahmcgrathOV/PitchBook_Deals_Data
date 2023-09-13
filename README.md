# Predicting Company Returns

## EDA
### 1. Distribution of Implied Return
![alt text](https://github.com/krishna-ov/PitchBook_Deals_Data/blob/main/eda_viz/TargetVar.png)

- The Implied Return data is highly skewed.
- We can observe some outliers with unsual returns(>400).
---- 

### 2. Percentage of Missing Values in Numerical Variables
   
| Variable | # of Missing Values | % of Missing Values |
|---- | ---- | ---- |
|PRE_MONEY_VALUATION| 36 | 0.021661 |
|POST_VALUATION | 33 | 0.019856 |
|DEAL_SIZE | 3 | 0.001805 |
|RAISED_TO_DATE | 3 | 0.001805 |


### 3. Percentage of Missing Values in Categorical Variables

| Variable | # of Missing Values | % of Missing Values |
|---- | ---- | ---- |
| Technical Degree | 457 |0.256310 | 
| Top University | 457 |0.256310 |
| Individual Investor: Midas List | 62 |0.034773 | 
| Individual Investor: Super Angel | 62 | 0.034773|
| Individual Investor: Best Performance | 62 | 0.034773| 
| Valuation Tier | 37 | 0.020752|
| Technical Prior Role | 14 |0.007852 | 
| FAANG Employee | 14 |0.007852 |
| SERIES | 13 | 0.007291 | 
| HQ_LOCATION | 7 |0.003926 |
| HQ_GLOBAL_REGION | 7 |0.003926 | 
| HQ_GLOBAL_SUB_REGION | 7 |0.003926 |
| COMPANY_COUNTRY_TERRITORY| 7 |0.003926|
| Quality Deals Investors | 1 |0.000561 |
| Firms: Best Investors | 1 | 0.000561|
| Firm: Worst | 1 | 0.000561|
| Software Sector | 1 |0.000561 |

----

### 4. Relation between Implied Return and Missing Data

- Analysing the impact of missing data on Implied Return:
     -   We separate the Implied Returns into two groups: missing information and information is present for each variable
     -   We then calculate the average(mean) Implied Return for each group and also a range around this average to indicate the typical variation(standard deviation) we might expect
     -   If there's a notable difference in Implied Return between the two groups, it suggests that missing information might be influencing the Implied Returns in some way. 

#### Numerical Variables

![DEAL_SIZE](https://github.com/krishna-ov/PitchBook_Deals_Data/blob/main/eda_viz/NumMissingRel.png)

- Comparing Mean
    - The mean return is much higher for observations with missing data for DEAL_SIZE and RAISED_TO_DATE.
    - It might indicate that higher returns are associated with missing data for some reason.

- Comparing Standard Deviation
    -  The variation for observations with missing data for DEAL_SIZE and RAISED_TO_DATE has a higher variability.
    - It might indicate that there's an uncertainity or risk associated with those missing observations.

#### Categorical Variables

![DEAL_SIZE](https://github.com/krishna-ov/PitchBook_Deals_Data/blob/main/eda_viz/CatMissingRel.png)

- Comparing Mean
    - The mean return is much higher for observations with missing data for QUALITY_DEALS_INVESTORS, 'Firms: Best Investors', 'Firms: Worst'.
    - It might indicate that higher returns are associated with missing data for some reason.

- Comparing Standard Deviation
    - The variation for observations with missing data isn't significant.
    - We cannot drop these missing values without further analysis.
----

### 5. Distribution of Numerical Variables

![DEAL_SIZE](https://github.com/krishna-ov/PitchBook_Deals_Data/blob/main/eda_viz/ContiVars_DIstr.png)

- All the numerical variables are highly skewed!
  
- Skewness of the numerical varaibles with respect to Implied Return

![DEAL_SIZE](https://github.com/krishna-ov/PitchBook_Deals_Data/blob/main/eda_viz/NumVarSkew.png)

- Since we are using tree-based methods: Random Forest Regressor and XGBoost Regressor, we are not dealing with skewness.

----

### 6. Temporal Variable Analysis

#### Trend of Implied Return with respect to Year Founded

![DEAL_SIZE](https://github.com/krishna-ov/PitchBook_Deals_Data/blob/main/eda_viz/ReturnYearFound.png)

#### Trend of Implied Return with respect to Deal Date

![DEAL_SIZE](https://github.com/krishna-ov/PitchBook_Deals_Data/blob/main/eda_viz/ReturnDealD.png)

#### Trend of Implied Return with respect to Number of Days from the Deal

![DEAL_SIZE](https://github.com/krishna-ov/PitchBook_Deals_Data/blob/main/eda_viz/ReturnDealDays.png)


- The older the company is the higher the returns are. This is common to expect.
- Why shouldn't we drop these varialbes from the data?
  -   Our goal is to predict the returns of a company no matter when it is founded.
  -   Also, we are not intrested in newly founded companies as of now. Or we could group the companies based on specific criteria.

#### Trend of Implied Return with respect to Month of the Deal

![DEAL_SIZE](https://github.com/krishna-ov/PitchBook_Deals_Data/blob/main/eda_viz/ReturnDealM.png)


- Higher returns are expected from companies when a deal happened in January.
- This trend dropped till March, and from March we can observe a rise in returns until July
- Lower returns are expected from companies when a deal happened from September to December.

----

### 7. Categorical Variable Analysis

- Cardinality

![DEAL_SIZE](https://github.com/krishna-ov/PitchBook_Deals_Data/blob/main/eda_viz/CatVarsDist.png)

  - Significant amount of columns have lower occurances of rare categorical labels. This might effect the model's performance.

----

### 8. Qualitative Variables

- SERIES: ['Series A', 'Series B', 'Series A1', 'Series A2', 'Series B1', 'Series B2', 'Series A3']
  
![DEAL_SIZE](https://github.com/krishna-ov/PitchBook_Deals_Data/blob/main/eda_viz/Series.png)


- Market Size Estimate: [1, 2, 3, 4, 5]
  
![DEAL_SIZE](https://github.com/krishna-ov/PitchBook_Deals_Data/blob/main/eda_viz/MSE_Distr..png)


- Valuation Tier: [$5M - $25M, $25M - $50M, $50M - $100M, $100M - $150M, >$1B]
![DEAL_SIZE](https://github.com/krishna-ov/PitchBook_Deals_Data/blob/main/eda_viz/ValuationTier.png)


----

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
