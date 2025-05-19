# Adashi_assessment

## Question 1
1. High-Value Customers with Multiple Products
   To tackle this question, I had to create two CTEs (Common Table Expressions); `saving_data` and `investment_data`. `saving_data` calculates the total amount by each user and total count of the users. `investment_data` calculates the total investments and total count of users, using `confirmed_amount` as the total amount deposited. From the above tables, I calculated the count of savings and investment, total amount deposited by each user.

## Question 2
2. Transaction Frequency Analysis
  Created CTEs that calculates account tenure by months, total transaction per customer, average transaction per month, and then went ahead to categorize based on category frequencies, customers per categories, and average transaction per category.

## Question 3
3. Account Inactivity Alert
  The goal is to identify accounts (savings or investment) with no inflow transactions in the past year (365 days)
  Created CTEs, filter `plans_plan` and `savings_savingsaccount` for active plans with a last transaction older than 365 days. Computed inactivity_days using DATEDIFF(CURDATE(),     last_transaction_date) and combined the results from both.

## Question 4
4.  Customer Lifetime Value (CLV) Estimation
  The goal is to estimate CLV for each customer
  Used `users_customuser` for account creation date. Joined with `savings_savingsaccount` to count transactions and sum values. Calculate tenure in months and average profit (0.1% of each transaction value). Ordered by estimated CLV descending.

## Challenges 
1. Tenure was sometimes zero, leading to division-by-zero errors.
Solution: Used CASE statements to handle such cases safely in tenure-based calculations.

2. Amount fields were stored in kobo, but analysis required naira.
Solution: Ensured all monetary aggregations were divided by 100 and rounded.

3. Some of the questions required complex joins 
