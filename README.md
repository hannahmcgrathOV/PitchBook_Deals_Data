# Predicting Company Returns

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

## EDA
1. Number of duplicate entries on COMPANIES column: 445
2. Distribution of Implied Return
![alt text](https://github.com/krishna-ov/PitchBook_Deals_Data/blob/main/eda_viz/TargetVar.png)
3. Percentage of Missing Values in Numerical Variables:
     | Variable | # of Missing Values | % of Missing Values |
     |---- | ---- | ---- |
     |PRE_MONEY_VALUATION| 36 | 0.021661 |
     |POST_VALUATION | 33 | 0.019856 |
     |DEAL_SIZE | 3 | 0.001805 |
     |RAISED_TO_DATE | 3 | 0.001805 |

4. Relation between Implied Return and Missing Data:
![DEAL_SIZE](https://github.com/krishna-ov/PitchBook_Deals_Data/blob/main/eda_viz/DealSize.png)      
