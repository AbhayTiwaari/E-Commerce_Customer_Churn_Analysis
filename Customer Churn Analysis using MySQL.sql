                                              # DATA CLEANING 

# Load & Check Data
SELECT * FROM `cus churn`;

# Count Dataset
SELECT count(*) as TotalNumberOfCustomers FROM `cus churn`;

# Check Any Duplicate Value by Help Of CustomerID
SELECT CustomerID, count(CustomerID) as Count
FROM `cus churn`
GROUP BY CustomerID
Having count(CustomerID) > 1;

# Check Any Null Value Has
SELECT 'Tenure' as ColumnName, COUNT(*) AS NullCount 
FROM `cus churn`
WHERE Tenure IS NULL
UNION
SELECT 'WarehouseToHome' as ColumnName, COUNT(*) AS NullCount 
FROM `cus churn`
WHERE warehousetohome IS NULL 
UNION
SELECT 'HourSpendonApp' as ColumnName, COUNT(*) AS NullCount 
FROM `cus churn`
WHERE hourspendonapp IS NULL
UNION
SELECT 'OrderAmountHikeFromLastYear' as ColumnName, COUNT(*) AS NullCount 
FROM `cus churn`
WHERE orderamounthikefromlastyear IS NULL 
UNION
SELECT 'CouponUsed' as ColumnName, COUNT(*) AS NullCount 
FROM `cus churn`
WHERE couponused IS NULL 
UNION
SELECT 'OrderCount' as ColumnName, COUNT(*) AS NullCount 
FROM `cus churn`
WHERE ordercount IS NULL 
UNION
SELECT 'DaySinceLastOrder' as ColumnName, COUNT(*) AS NullCount 
FROM `cus churn`
WHERE daysincelastorder IS NULL;

# Creating a new column from an already existing “churn” column
ALTER TABLE `cus churn`
ADD CustomerStatus NVARCHAR(50);

# SomeTime MySQl Can't UPDATE so That Time Use This
SET SQL_SAFE_UPDATES = 0;        

UPDATE `cus churn`
SET CustomerStatus = 
CASE 
    WHEN Churn = 1 THEN 'Churned' 
    WHEN Churn = 0 THEN 'Stayed'
END;

# Creating a new column from an already existing “complain” column
ALTER TABLE `cus churn`
ADD ComplainRecieved NVARCHAR(10);

UPDATE `cus churn`
SET ComplainRecieved =  
CASE 
    WHEN complain = 1 THEN 'Yes'
    WHEN complain = 0 THEN 'No'
END;

# Checking values in each column for correctness and accuracy
   # Fixing redundancy in "preferredlogindevice" Column
   select distinct preferredlogindevice
   from `cus churn`;

   # But Phone & Mobile Phone is Same, So Do UPADTE
   UPDATE `cus churn`
   SET preferredlogindevice = 'Phone'
   WHERE preferredlogindevice = 'mobile phone';
   
   # Fixing redundancy in “preferedordercat ” Column
   select distinct preferedordercat 
   from `cus churn`;

   # But Mobile & Mobile Phone is Same, So Do UPADTE
   UPDATE `cus churn`
   SET preferedordercat = 'Mobile Phone'
   WHERE Preferedordercat = 'Mobile';

   # Fixing redundancy in “PreferredPaymentMode” Column
   select distinct PreferredPaymentMode 
   from `cus churn`;
   
   # But Cash on Delivery & COD Phone is Same, So Do UPADTE
   UPDATE `cus churn`
   SET PreferredPaymentMode  = 'Cash on Delivery'
   WHERE PreferredPaymentMode  = 'COD';
   
   # Fixing wrongly entered values in “WarehouseToHome” column
   SELECT DISTINCT warehousetohome
   FROM `cus churn`;
   
   # Notice the 126 and 127 values; they are definitely outliers and most likely wrongly entered. To fix with correct the values to 26 and 27
   UPDATE `cus churn`
   SET warehousetohome = '27'
   WHERE warehousetohome = '127';

   UPDATE `cus churn`
   SET warehousetohome = '26'
   WHERE warehousetohome = '126';
   
                                       # DATA EXPLORATION -- Answering business questions

# 1. What is the overall customer churn rate?
SELECT TotalNumberofCustomers, 
       TotalNumberofChurnedCustomers,
       CAST((TotalNumberofChurnedCustomers * 1.0 / TotalNumberofCustomers * 1.0)*100 AS DECIMAL(10,2)) AS ChurnRate
FROM
(SELECT COUNT(*) AS TotalNumberofCustomers
FROM `cus churn`) AS Total,
(SELECT COUNT(*) AS TotalNumberofChurnedCustomers
FROM `cus churn`
WHERE CustomerStatus = 'churned') AS Churned;

# 2. How does the churn rate vary based on the preferred login device?
SELECT preferredloginDevice, 
        COUNT(*) AS TotalCustomers,
        SUM(churn) AS ChurnedCustomers,
        CAST(SUM(churn) * 1.0 / COUNT(*) * 100 AS DECIMAL(10,2)) AS ChurnRate
FROM `cus churn`
GROUP BY preferredloginDevice;

# 3. What is the distribution of customers across different city tiers?
SELECT citytier, 
       COUNT(*) AS TotalCustomer, 
       SUM(Churn) AS ChurnedCustomers, 
       CAST(SUM(Churn) * 1.0 / COUNT(*) * 100 AS DECIMAL(10,2)) AS ChurnRate
FROM `cus churn`
GROUP BY citytier
ORDER BY churnrate DESC;

# 4. Is there any correlation between the warehouse-to-home distance and customer churn?
ALTER TABLE `cus churn`
ADD warehousetohomerange NVARCHAR(50);

# SomeTime MySQl Can't UPDATE so That Time Use This
SET SQL_SAFE_UPDATES = 0;

UPDATE `cus churn`
SET warehousetohomerange =
CASE 
    WHEN warehousetohome <= 10 THEN 'Very close distance'
    WHEN warehousetohome > 10 AND warehousetohome <= 20 THEN 'Close distance'
    WHEN warehousetohome > 20 AND warehousetohome <= 30 THEN 'Moderate distance'
    WHEN warehousetohome > 30 THEN 'Far distance'
END;

   # Finding a correlation between warehouse to home and churn rate.
   SELECT warehousetohomerange,
       COUNT(*) AS TotalCustomer,
       SUM(Churn) AS CustomerChurn,
       CAST(SUM(Churn) * 1.0 /COUNT(*) * 100 AS DECIMAL(10,2)) AS Churnrate
   FROM `cus churn`
   GROUP BY warehousetohomerange
   ORDER BY Churnrate DESC;

# 5. Which is the most preferred payment mode among churned customers?
SELECT preferredpaymentmode,
       COUNT(*) AS TotalCustomer,
       SUM(Churn) AS CustomerChurn,
       CAST(SUM(Churn) * 1.0 /COUNT(*) * 100 AS DECIMAL(10,2)) AS Churnrate
FROM `cus churn`
GROUP BY preferredpaymentmode
ORDER BY Churnrate DESC;

# 6. What is the typical tenure for churned customers?
ALTER TABLE `cus churn`
ADD TenureRange NVARCHAR(50);

UPDATE `cus churn`
SET TenureRange =
CASE 
    WHEN tenure <= 6 THEN '6 Months'
    WHEN tenure > 6 AND tenure <= 12 THEN '1 Year'
    WHEN tenure > 12 AND tenure <= 24 THEN '2 Years'
    WHEN tenure > 24 THEN 'more than 2 years'
END;

   # Finding typical tenure for churned customers
   SELECT TenureRange,
       COUNT(*) AS TotalCustomer,
       SUM(Churn) AS CustomerChurn,
       CAST(SUM(Churn) * 1.0 /COUNT(*) * 100 AS DECIMAL(10,2)) AS Churnrate
   FROM `cus churn`
   GROUP BY TenureRange
   ORDER BY Churnrate DESC;
   
# 7. Is there any difference in churn rate between male and female customers?
SELECT gender,
       COUNT(*) AS TotalCustomer,
       SUM(Churn) AS CustomerChurn,
       CAST(SUM(Churn) * 1.0 /COUNT(*) * 100 AS DECIMAL(10,2)) AS Churnrate
FROM `cus churn`
GROUP BY gender
ORDER BY Churnrate DESC;

# 8. How does the average time spent on the app differ for churned and non-churned customers?
SELECT customerstatus, round(avg(hourspendonapp),0) AS AverageHourSpentonApp
FROM `cus churn`
GROUP BY customerstatus;

# 9. Does the number of registered devices impact the likelihood of churn?

SELECT NumberofDeviceRegistered,
       COUNT(*) AS TotalCustomer,
       SUM(Churn) AS CustomerChurn,
       CAST(SUM(Churn) * 1.0 /COUNT(*) * 100 AS DECIMAL(10,2)) AS Churnrate
FROM `cus churn`
GROUP BY NumberofDeviceRegistered
ORDER BY Churnrate DESC;

# 10. Which order category is most preferred among churned customers?

SELECT preferedordercat,
       COUNT(*) AS TotalCustomer,
       SUM(Churn) AS CustomerChurn,
       CAST(SUM(Churn) * 1.0 /COUNT(*) * 100 AS DECIMAL(10,2)) AS Churnrate
FROM `cus churn`
GROUP BY preferedordercat
ORDER BY Churnrate DESC;

# 11. Is there any relationship between customer satisfaction scores and churn?

SELECT satisfactionscore,
       COUNT(*) AS TotalCustomer,
       SUM(Churn) AS CustomerChurn,
       CAST(SUM(Churn) * 1.0 /COUNT(*) * 100 AS DECIMAL(10,2)) AS Churnrate
FROM `cus churn`
GROUP BY satisfactionscore
ORDER BY Churnrate DESC;

# 12. Does the marital status of customers influence churn behavior?
SELECT maritalstatus,
       COUNT(*) AS TotalCustomer,
       SUM(Churn) AS CustomerChurn,
       CAST(SUM(Churn) * 1.0 /COUNT(*) * 100 AS DECIMAL(10,2)) AS Churnrate
FROM `cus churn`
GROUP BY maritalstatus
ORDER BY Churnrate DESC;

#13. How many addresses do churned customers have on average?
SELECT round(AVG(numberofaddress),0) AS Averagenumofchurnedcustomeraddress
FROM `cus churn`
WHERE customerstatus = 'stayed';

# 14. Do customer complaints influence churned behavior?
SELECT complainrecieved,
       COUNT(*) AS TotalCustomer,
       SUM(Churn) AS CustomerChurn,
       CAST(SUM(Churn) * 1.0 /COUNT(*) * 100 AS DECIMAL(10,2)) AS Churnrate
FROM `cus churn`
GROUP BY complainrecieved
ORDER BY Churnrate DESC;

# 15. How does the use of coupons differ between churned and non-churned customers?
SELECT customerstatus, SUM(couponused) AS SumofCouponUsed
FROM `cus churn`
GROUP BY customerstatus;

# 16. What is the average number of days since the last order for churned customers?
SELECT round(AVG(daysincelastorder),0) AS AverageNumofDaysSinceLastOrder
FROM `cus churn`
WHERE customerstatus = 'churned';

# 17. Is there any correlation between cashback amount and churn rate?
ALTER TABLE `cus churn`
ADD cashbackamountrange NVARCHAR(50);

UPDATE `cus churn`
SET cashbackamountrange =
CASE 
    WHEN cashbackamount <= 100 THEN 'Low Cashback Amount'
    WHEN cashbackamount > 100 AND cashbackamount <= 200 THEN 'Moderate Cashback Amount'
    WHEN cashbackamount > 200 AND cashbackamount <= 300 THEN 'High Cashback Amount'
    WHEN cashbackamount > 300 THEN 'Very High Cashback Amount'
END;

    # Finding the correlation between cashback amount range and churned rate

      SELECT cashbackamountrange,
         COUNT(*) AS TotalCustomer,
         SUM(Churn) AS CustomerChurn,
         CAST(SUM(Churn) * 1.0 /COUNT(*) * 100 AS DECIMAL(10,2)) AS Churnrate
      FROM `cus churn`
      GROUP BY cashbackamountrange
      ORDER BY Churnrate DESC;