SELECT
  u.id AS customer_id,
  CONCAT(u.first_name, ' ', u.last_name) AS name,
  
  -- Calculate tenure in months since signup
  TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,
  
  -- Count total transactions for the user
  COALESCE(COUNT(s.id), 0) AS total_transactions,
  
  -- Calculate average profit per transaction (0.1% of avg transaction amount)
  COALESCE(AVG(s.amount), 0) * 0.001 AS avg_profit_per_transaction,
  
  -- Estimated CLV formula: ((total_transactions / tenure) * 12) * avg_profit_per_transaction
  CASE 
    WHEN TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) > 0 THEN
      (COUNT(s.id) / TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE())) * 12 * (COALESCE(AVG(s.amount), 0) * 0.001)
    ELSE 0
  END AS estimated_clv

FROM users_customuser u
LEFT JOIN savings_savingsaccount s ON s.owner_id = u.id
GROUP BY u.id, u.first_name, u.last_name, u.date_joined
ORDER BY estimated_clv DESC;
