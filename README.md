# PitchBook_Deals_Data

### Columns - Variables
| Name | Type | Tag | Description |
| --- | --- | --- | --- |
TRAIN_OR_TEST | ```string``` 
IMPLIED_RETURN_CLEAN | ```numerical```
DEAL_ID | ```string```
COMPANIES | ```string```
COMPANY_ID | ```string```
DESCRIPTION | ```string```
FINANCING_STATUS_NOTE | ```string```
PRIMARY_INDUSTRY_SECTOR | ```string```
PRIMARY_INDUSTRY_GROUP | ```string```
PRIMARY_INDUSTRY_CODE | ```string```
ALL_INDUSTRIES | ```string```
VERTICALS | ```string```
KEYWORDS | ```string```
CURRENT_FINANCING_STATUS | ```string```
CURRENT_BUSINESS_STATUS | ```string```
UNIVERSE | ```string```
CEO_AT_TIME_OF_DEAL | ```string```
CEO_PBID | ```string```
CEO_PHONE | ```string```
CEO_EMAIL | ```string```
CEO_BIOGRAPHY | ```string```
CEO_EDUCATION | ```string```
DEAL_NUMBER | ```string```
DEAL_ID_2 | ```string```
ANNOUNCED_DATE | ```datetime``` | $${\color{orange}\text{missing data}}$$
DEAL_DATE | ```datetime``` | $${\color{orange}\text{missing data}}$$
DEAL_SIZE | ```numerical``` | $${\color{orange}\text{missing data}}$$ | The monetary value of the current deal
DEAL_SIZE_STATUS | ```string```
PRE_MONEY_VALUATION | ```numerical``` | $${\color{orange}\text{missing data}}$$ | Company's valuation before the current investment
POST_VALUATION | ```numerical``` | $${\color{orange}\text{missing data}}$$ | Company's valuation after the current investment
POST_VALUATION_STATUS | ```string```
PCT_ACQUIRED | ```string```
RAISED_TO_DATE | ```numerical``` | $${\color{orange}\text{missing data}}$$ | Total amount of money raised by the company to date!
VC_ROUND | ```string```
VC_ROUND_UP_DOWN_FLAT | ```string```
PRICE_PER_SHARE | ```numerical``` | $${\color{orange}\text{missing data}}$$ | Cost of a single share of the company
SERIES | ```string```
DEAL_TYPE | ```string```
DEAL_TYPE_2 | ```string```
DEAL_TYPE_3 | ```string```
DEAL_CLASS | ```string```
DEAL_SYNOPSIS | ```string```
TOTAL_INVESTED_EQUITY | ```numerical``` | $${\color{orange}\text{missing data}}$$ | Total equity investment in the company
ADD_ON | ```string```
ADD_ON_SPONSOR | ```string```
ADD_ON_PLATFORM | ```string``` | $${\color{red}\text{no data}}$$
DEBTS | ```string```
TOTAL_NEW_DEBT | ```numerical``` | $${\color{orange}\text{missing data}}$$ | New debt acquired by the company
DEBT_RAISED_IN_RECORD | ```numerical``` | $${\color{orange}\text{missing data}}$$ | Amount of debt raised in the current record
CONTINGENT_PAYOUT | ```numerical``` | $${\color{orange}\text{missing data}}$$ | Payment amount dependent on future events or condition
DEAL_STATUS | ```string```
BUSINESS_STATUS | ```string```
FINANCING_STATUS | ```string```
EMPLOYEES | ```numerical``` | $${\color{orange}\text{missing data}}$$ | Total number of employees in the company
NUM_INVESTORS | ```numerical``` | $${\color{orange}\text{missing data}}$$ | Total number of investors in the company
NEW_INVESTORS | ```string```
NUM_NEW_INVESTORS | ```numerical``` | $${\color{orange}\text{missing data}}$$ | Number of new investors in the current deal
FOLLOW_ON_INVESTORS | ```string```
NUM_FOLLOW_ON_INVESTORS | ```numerical``` | $${\color{orange}\text{missing data}}$$ | Number of existing investors participating in the current deal |
LENDERS | ```string```
INVESTORS_WEBSITES | ```string```
INVESTORS | ```string```
LEAD_SOLE_INVESTORS | ```string```
INVESTOR_FUNDS | ```string```
SELLERS | ```string```
EXITERS_W_NO_PROCEEDS | ```string```
DIVIDEND_DISTRIBUTION_BENEFICIARIES | ```string``` | $${\color{red}\text{no data}}$$
SERVICES_PROVIDERS_ALL | ```string```
SERVICE_PROVIDERS_SELL_SIDE | ```string```
SERVICE_PROVIDERS_SELL_SIDE_INTERMEDIARIES | ```string```
SERVICE_PROVIDERS_BUY_SIDE | ```string```
DEBT_AND_LENDORS | ```string```
IMPLIED_EV | ```numerical``` | $${\color{red}\text{no data}}$$
REVENUE | ```numerical``` | $${\color{orange}\text{missing data}}$$ | Company's total income
REVENUE_GROWTH_SINCE_LAST_DEAL | ```numerical``` | $${\color{orange}\text{missing data}}$$ | Growth in revenue since the last deal
GROSS_PROFIT | ```numerical``` | $${\color{orange}\text{missing data}}$$ | Company's profit after deducting the cost of goods sold!
NET_INCOME | ```numerical``` | $${\color{orange}\text{missing data}}$$ | Company's total profit after all expenses
EBITDA | ```numerical``` | $${\color{orange}\text{missing data}}$$ | Earnings before interest, taxes, depreciation, and amortization
EBIT | ```numerical``` | $${\color{orange}\text{missing data}}$$ | Earnings before interest and taxes
TOTAL_DEBT_FROM_FINANCIALS | ```numerical``` | $${\color{orange}\text{missing data}}$$ | Company's total debt as per financial records
FISCAL_YEAR | ```datetime``` | $${\color{orange}\text{missing data}}$$
VALUATION_OVER_EBITDA | ```numerical``` | $${\color{orange}\text{missing data}}$$ | Company's valuation relative to its EBITDA
VALUATION_OVER_EBIT | ```numerical``` | $${\color{orange}\text{missing data}}$$ | Company's valuation relative to its EBIT
VALUATION_OVER_NET_INCOME | ```numerical``` | $${\color{orange}\text{missing data}}$$ | Company's valuation relative to its net income
VALUATION_OVER_REVENUE | ```numerical``` | $${\color{orange}\text{missing data}}$$ | Company's valuation relative to its revenue
VALUATION_OVER_CASH_FLOW | ```numerical``` | $${\color{orange}\text{missing data}}$$ | Company's valuation relative to its cash flow
DEAL_SIZE_OVER_EBITDA | ```numerical``` | $${\color{orange}\text{missing data}}$$ | Deal size in relation to the company's EBITDA
DEAL_SIZE_OVER_EBIT | ```numerical``` | $${\color{orange}\text{missing data}}$$ | Deal size in relation to the company's EBIT
DEAL_SIZE_OVER_NET_INCOME | ```numerical``` | $${\color{orange}\text{missing data}}$$ | Deal size in relation to the company's net income
DEAL_SIZE_OVER_REVENUE | ```numerical``` | $${\color{orange}\text{missing data}}$$ | Deal size in relation to the company's revenue
DEAL_SIZE_OVER_CASH_FLOW | ```numerical``` | $${\color{orange}\text{missing data}}$$ | Deal size in relation to the company's cash flow
DEBT_OVER_EBITDA | ```numerical``` | $${\color{orange}\text{missing data}}$$ | Company's debt in relation to its EBITDA
DEBT_OVER_EQUITY | ```numerical``` | $${\color{orange}\text{missing data}}$$ | Ratio of the company's total debt to its total equity
IMPLIED_EV_OVER_EBITDA | ```numerical``` | $${\color{red}\text{no data}}$$
IMPLIED_EV_OVER_EBIT | ```numerical``` | $${\color{red}\text{no data}}$$
EMPLIED_EV_OVER_NET_INCOME | ```numerical``` | $${\color{red}\text{no data}}$$
IMPLIED_EV_OVER_REVENUE | ```numerical``` | $${\color{red}\text{no data}}$$
IMPLIED_EV_OVER_CASH_FLOW | ```numerical``` | $${\color{red}\text{no data}}$$
EBITDA_MARGIN_PCT | ```numerical``` | $${\color{orange}\text{missing data}}$$ | Percentage of EBITDA in relation to the company's total revenue
CURRENT_EMPLOYEES | ```numerical``` | $${\color{orange}\text{missing data}}$$ | Number of employees currently working in the company
NATIVE_CURRENCY_OF_DEAL | ```string```
HQ_LOCATION | ```string```
HQ_GLOBAL_REGION | ```string```
HQ_GLOBAL_SUB_REGION | ```string```
COMPANY_CITY | ```string```
COMPANY_STATE_PROVINCE | ```string```
COMPANY_POST_CODE | ```string```
COMPANY_COUNTRY_TERRITORY | ```string```
YEAR_FOUNDED | ```datetime``` | $${\color{orange}\text{missing data}}$$
COMPANY_WEBSITE | ```string```
TOTAL_PATENT_DOCUMENTS | ```numerical``` | $${\color{orange}\text{missing data}}$$ | The total number of patent documents associated with the company, which can include applications, granted patents, and other related documents
TOTAL_PATENT_FAMILIES | ```numerical``` | $${\color{orange}\text{missing data}}$$ | The total number of unique patent families the company has. A patent family groups together patents that are based on the same invention and are filed in multiple countries
ACTIVE_PATENTS | ```numerical``` | $${\color{orange}\text{missing data}}$$ | The number of patents currently held by the company that are in force, meaning they are legally protected and have not expired
PENDING_PATENTS | ```numerical``` | $${\color{orange}\text{missing data}}$$ | The number of patent applications submitted by the company that are awaiting approval or rejection by the patent office
PATENTS_EXPIRING_IN_NEXT_12_MONTHS | ```numerical``` | $${\color{orange}\text{missing data}}$$ | The number of patents held by the company that are set to expire within the next 12 months
INACTIVE_PATENTS | ```numerical``` | $${\color{orange}\text{missing data}}$$ | Patents that the company once held but are no longer in force, either due to expiration, abandonment, or other reasons
TOP_CPC_CODES | ```string```
EMERGING_SPACES | ```string```
IMPLIED_RETURN | ```string```
INCLUDE | ```string``` | $${\color{orange}\text{missing data}}$$
IS_5X | ```string``` | $${\color{orange}\text{missing data}}$$
IS_10X | ```string``` | $${\color{orange}\text{missing data}}$$
IS_50X | ```string``` | $${\color{orange}\text{missing data}}$$
RETURN_TIER | ```string```
