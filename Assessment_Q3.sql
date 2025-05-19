-- Get last transaction dates for active investment plans
WITH last_plan_transactions AS (
  SELECT
    id AS plan_id,
    owner_id,
    'Investment' AS type,
    -- Use GREATEST to get the most recent date from these columns
    GREATEST(
      COALESCE(last_charge_date, '1900-01-01'),
      COALESCE(last_returns_date, '1900-01-01'),
      COALESCE(next_charge_date, '1900-01-01')
    ) AS last_transaction_date,
    -- Calculate inactivity days from last transaction date till today
    DATEDIFF(CURDATE(), GREATEST(
      COALESCE(last_charge_date, '1900-01-01'),
      COALESCE(last_returns_date, '1900-01-01'),
      COALESCE(next_charge_date, '1900-01-01')
    )) AS inactivity_days
  FROM plans_plan
  WHERE status_id = 1  -- Adjust status_id for 'active' as per your schema
    AND is_deleted = 0 -- Exclude deleted plans
),

-- Get last transaction dates for savings accounts
last_savings_transactions AS (
  SELECT
    plan_id,
    owner_id,
    'Savings' AS type,
    MAX(transaction_date) AS last_transaction_date,
    DATEDIFF(CURDATE(), MAX(transaction_date)) AS inactivity_days
  FROM savings_savingsaccount
  GROUP BY plan_id, owner_id
)

-- Combine both sets of accounts and filter inactive ones
SELECT
  plan_id,
  owner_id,
  type,
  last_transaction_date,
  inactivity_days
FROM (
  SELECT * FROM last_plan_transactions
  UNION ALL
  SELECT * FROM last_savings_transactions
) AS combined
WHERE inactivity_days > 365
ORDER BY inactivity_days DESC;

