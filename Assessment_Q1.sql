-- Identify customers with both regular savings and investment plans and total deposits
WITH savings_data AS (
  SELECT
    sa.owner_id,
    COUNT(DISTINCT sa.plan_id) AS savings_count,
    SUM(sa.confirmed_amount) AS total_savings_kobo
  FROM savings_savingsaccount sa
  JOIN plans_plan pp ON sa.plan_id = pp.id
  WHERE pp.is_regular_savings = 1
    AND sa.confirmed_amount > 0
  GROUP BY sa.owner_id
),
investment_data AS (
  SELECT
    pp.owner_id,
    COUNT(DISTINCT pp.id) AS investment_count,
    SUM(sa.confirmed_amount) AS total_investment_kobo
  FROM plans_plan pp
  JOIN savings_savingsaccount sa ON sa.plan_id = pp.id
  WHERE pp.is_a_fund = 1
    AND sa.confirmed_amount > 0
  GROUP BY pp.owner_id
)

SELECT
  u.id AS owner_id,
  CONCAT(u.first_name, ' ', u.last_name) AS name,
  s.savings_count,
  i.investment_count,
  -- Total deposit in naira by summing confirmed amounts from savings and investment
  ROUND((COALESCE(s.total_savings_kobo, 0) + COALESCE(i.total_investment_kobo, 0)) / 100, 2) AS total_deposits
FROM users_customuser u
JOIN savings_data s ON u.id = s.owner_id
JOIN investment_data i ON u.id = i.owner_id
ORDER BY total_deposits DESC;