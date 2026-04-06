			# 1 задание
SELECT ID_client, DATE_FORMAT(date_new, '%Y-%m') AS month, Sum_payment
FROM Transactions;

SELECT ID_client FROM Transactions
	WHERE date_new BETWEEN '2015-06-01' AND '2016-05-31'
	GROUP BY ID_client
	HAVING COUNT(DISTINCT DATE_FORMAT(date_new, '%Y-%m')) = 12;
    
SELECT 
    t.ID_client,
    COUNT(*) AS total_operations,               
    AVG(t.Sum_payment) AS avg_check,          
    SUM(t.Sum_payment) / COUNT(DISTINCT DATE_FORMAT(t.date_new, '%Y-%m')) AS avg_monthly_spent 
FROM Transactions t
WHERE t.date_new BETWEEN '2015-06-01' AND '2016-05-31'
AND t.ID_client IN (
    SELECT ID_client
    FROM Transactions
    WHERE date_new BETWEEN '2015-06-01' AND '2016-05-31'
    GROUP BY ID_client
    HAVING COUNT(DISTINCT DATE_FORMAT(date_new, '%Y-%m')) = 12)
GROUP BY t.ID_client;

SELECT 
    ID_client,
    DATE_FORMAT(date_new, '%Y-%m') AS month,
    COUNT(*) AS operations,
    SUM(Sum_payment) AS total_spent,
    AVG(Sum_payment) AS avg_check
FROM Transactions
WHERE date_new BETWEEN '2015-06-01' AND '2016-05-31'
GROUP BY ID_client, month
ORDER BY ID_client, month;

			# 2 задание
            # a)
SELECT 
    DATE_FORMAT(date_new, '%Y-%m') AS month,
    AVG(Sum_payment) AS avg_check
FROM Transactions
GROUP BY month
ORDER BY month;
			
            # b)
SELECT 
    DATE_FORMAT(date_new, '%Y-%m') AS month,
    COUNT(*) AS operations
FROM Transactions
GROUP BY month
ORDER BY month;

SELECT AVG(monthly_ops) 
FROM (
	SELECT COUNT(*) AS monthly_ops
	FROM Transactions
	GROUP BY DATE_FORMAT(date_new, '%Y-%m')) t;
			
            # c)
SELECT 
    DATE_FORMAT(date_new, '%Y-%m') AS month,
    COUNT(DISTINCT ID_client) AS clients
FROM Transactions
GROUP BY month
ORDER BY month;

SELECT AVG(monthly_clients)
FROM (
	SELECT COUNT(DISTINCT ID_client) AS monthly_clients
    FROM Transactions
    GROUP BY DATE_FORMAT(date_new, '%Y-%m')) t;
			
            # d)
SELECT 
    DATE_FORMAT(date_new, '%Y-%m') AS month,
    COUNT(*) * 1.0 / SUM(COUNT(*)) OVER () AS operations_share
FROM Transactions
GROUP BY month;
			
SELECT 
    DATE_FORMAT(date_new, '%Y-%m') AS month,
    SUM(Sum_payment) / SUM(SUM(Sum_payment)) OVER () AS revenue_share
FROM Transactions
GROUP BY month
ORDER BY month;
			
            # e)
SELECT 
    DATE_FORMAT(t.date_new, '%Y-%m') AS month,
    COALESCE(c.Gender, 'NA') AS Gender,
    COUNT(DISTINCT t.ID_client) AS clients,
    COUNT(*) * 1.0 / SUM(COUNT(*)) OVER (PARTITION BY DATE_FORMAT(t.date_new, '%Y-%m')) AS gender_ratio,
    SUM(t.Sum_payment) / SUM(SUM(t.Sum_payment)) OVER (PARTITION BY DATE_FORMAT(t.date_new, '%Y-%m')) AS spend_ratio
FROM Transactions t
JOIN Customers c 
    ON t.ID_client = c.Id_client
GROUP BY month, c.Gender
ORDER BY month, c.Gender;

			# 3 задание
SELECT 
    CASE WHEN c.Age IS NULL THEN 'No Age'
	ELSE CONCAT(FLOOR(c.Age/10)*10, '-', FLOOR(c.Age/10)*10 + 9)
    END AS age_group,
	COUNT(*) AS operations,
    SUM(t.Sum_payment) AS total_spent,
	AVG(t.Sum_payment) AS avg_check,
	COUNT(*) * 1.0 / SUM(COUNT(*)) OVER () AS operations_share,
    SUM(t.Sum_payment) / SUM(SUM(t.Sum_payment)) OVER () AS revenue_share
FROM Transactions t
JOIN Customers c 
    ON t.ID_client = c.Id_client
WHERE t.date_new BETWEEN '2015-06-01' AND '2016-05-31'
GROUP BY age_group
ORDER BY age_group;

SELECT 
    CONCAT(YEAR(t.date_new), '-Q', QUARTER(t.date_new)) AS quarter,
	CASE WHEN c.Age IS NULL THEN 'No Age'
	ELSE CONCAT(FLOOR(c.Age/10)*10, '-', FLOOR(c.Age/10)*10 + 9)
    END AS age_group,
	COUNT(*) AS operations,
    SUM(t.Sum_payment) AS total_spent,
	AVG(t.Sum_payment) AS avg_check,
	COUNT(*) * 1.0 / SUM(COUNT(*)) OVER (
		PARTITION BY CONCAT(YEAR(t.date_new), '-Q', QUARTER(t.date_new))
    ) AS operations_share,
	SUM(t.Sum_payment) / SUM(SUM(t.Sum_payment)) OVER (
        PARTITION BY CONCAT(YEAR(t.date_new), '-Q', QUARTER(t.date_new))
    ) AS revenue_share
FROM Transactions t
JOIN Customers c 
    ON t.ID_client = c.Id_client
WHERE t.date_new BETWEEN '2015-06-01' AND '2016-05-31'
GROUP BY quarter, age_group
ORDER BY quarter, age_group;