WITH customer_transaction_stats AS (
  SELECT
    u.id AS customer_id,
    -- Calculate account tenure in months
    TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,
    -- Total transactions per customer
    COUNT(s.id) AS total_transactions,
    -- Average transactions per month (handle zero tenure safely)
    CASE 
      WHEN TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) > 0 THEN
        COUNT(s.id) / TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE())
      ELSE 0
    END AS avg_transactions_per_month
  FROM users_customuser u
  LEFT JOIN savings_savingsaccount s ON s.owner_id = u.id
  GROUP BY u.id, u.date_joined
)

SELECT
  -- Categorize based on avg_transactions_per_month
  CASE
    WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
    WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
    ELSE 'Low Frequency'
  END AS frequency_category,
  
  -- Count customers per category
  COUNT(customer_id) AS customer_count,
  
  -- Average of avg_transactions_per_month per category
  ROUND(AVG(avg_transactions_per_month), 1) AS avg_transactions_per_month

FROM customer_transaction_stats

GROUP BY frequency_category

ORDER BY
  CASE frequency_category
    WHEN 'High Frequency' THEN 1
    WHEN 'Medium Frequency' THEN 2
    WHEN 'Low Frequency' THEN 3
  END;
