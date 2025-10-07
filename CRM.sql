use crm;
# total Expected Amount
select SUM(CAST(REPLACE(REPLACE(Expected_Amount, '$', ''), ',', '') AS DECIMAL(15, 2))) AS total_expected
FROM oppty;

# Active oppty

select count(case when Closed="False" then 1 end)
from oppty;

# conversion rate
select count(case when Stage="Closed Won" then 1 end)/count(Closed)*100
from oppty;

# win rate
select count(case when Won = "True" then 1 end)/count(case when Stage="Closed Won" or Stage="Closed Lost" then 1 end)*100 as win_rate
from oppty;

# loss rate
select count(case when Stage="Closed Lost" then 1 end)/count(Closed)*100
from oppty;

# Expected Vs forecast comparision
SELECT 
    Fiscal_Year,
    Amount,
    Expected_Amount,
    SUM(CAST(REPLACE(REPLACE(Amount, '$', ''), ',', '') AS DECIMAL(15, 2)))
        OVER (ORDER BY Fiscal_Year) AS running_total_amount,
    SUM(CAST(REPLACE(REPLACE(Expected_Amount, '$', ''), ',', '') AS DECIMAL(15, 2)))
        OVER (ORDER BY Fiscal_Year) AS running_total_expected
FROM 
    oppty;
    
# Active vs total oppty
SELECT 
    Fiscal_Year,
    COUNT(*) AS total_oppty,
    COUNT(CASE WHEN Closed = 'False' THEN 1 END) AS active_oppty
FROM 
    oppty
GROUP BY 
    Fiscal_Year
    order by Fiscal_Year;
    
# Closed won vs total closed
SELECT 
    Fiscal_Year,
    COUNT(CASE WHEN Stage = 'Closed Won' THEN 1 END) AS closed_won,
    COUNT(CASE WHEN Closed = 'True' THEN 1 END) AS total_closed
FROM 
    oppty
GROUP BY 
    Fiscal_Year;

# closed won vs total oppty
SELECT 
    Fiscal_Year,
    COUNT(CASE
        WHEN Stage = 'Closed Won' THEN 1
    END) AS closed_won,
    COUNT(Closed) AS total_oppty
FROM
    oppty
GROUP BY Fiscal_Year;
    
# Expected amount by oppty type
SELECT 
Opportunity_Type,
SUM(CAST(REPLACE(REPLACE(Expected_Amount, '$', ''), ',', '') AS DECIMAL(15, 2))) AS total_expected
FROM 
oppty
GROUP BY Opportunity_Type;

# oppty by industry

SELECT 
    Industry, 
    COUNT(*) AS total_opportunities
FROM 
    oppty
GROUP BY 
    Industry;
    
-- KPI QUERIES FOR LEAD 
-- 1. Total Leads
SELECT COUNT(*) AS Total_Leads
FROM leads;

-- 4. Converted Accounts
SELECT distinct count(Converted_Account_ID) AS Converted_Accounts
FROM leads;

--  5. Converted Opportunities
SELECT SUM(CAST(REPLACE(`# Converted Opportunities`, ',', '') AS UNSIGNED)) AS total_converted_opportunities
FROM leads
WHERE Converted = 'True';


-- 6. Leads by Source
SELECT `Lead Source`, COUNT(*) AS Lead_Count
FROM Leads
GROUP BY `Lead Source`
ORDER BY Lead_Count DESC;

-- 7. Leads by Industry
SELECT Industry, COUNT(*) AS Lead_Count
FROM Leads
GROUP BY Industry
ORDER BY Lead_Count DESC;

-- 8. Leads by Stage
SELECT Status, COUNT(*) AS Lead_Count
FROM Leads
GROUP BY Status
ORDER BY Lead_Count DESC;


-- 9. lead by year and converted
SELECT 
    YEAR(STR_TO_DATE(`Created Date`, '%m/%d/%Y %H:%i')) AS lead_year,
    COUNT(*) AS total_leads,
    SUM(CASE WHEN Converted = 'True' THEN 1 ELSE 0 END) AS converted_leads
FROM leads
WHERE `Created Date` IS NOT NULL
GROUP BY lead_year
ORDER BY lead_year;



    

