-- 7 zevgaria xoron pou exoun ypostei tin idia katastrofi 
 
-- INSERT INTO disaster_situation (RGDP, financial_aid, recovery_time, Total_cost, Plan_title, country_name, disaster_id)
-- VALUES
-- (1, 5000.00, 30, 200000.00, 'Recovery Plan A', 'CountryD', 3) ; 
 

-- Using c.country_name < b.country_name instead of c.country_name != b.country_name ensures that you avoid duplicates in the output. 
-- This is because it establishes a consistent order when comparing pairs of countries.
-- When you use c.country_name != b.country_name, it checks for inequality, and both combinations of (c.country_name, b.country_name) and (b.country_name, c.country_name) would be considered separately. 
-- This could result in duplicate pairs in the output.
-- By using c.country_name < b.country_name, you are essentially ordering the pairs lexicographically based on country names. 
-- This way, you ensure that each pair is represented in a consistent manner, and you won't get both (A, B) and (B, A) in the result set.
-- In summary, the use of < establishes an order and helps in avoiding duplicates when you are comparing pairs or tuples of values.
 
SELECT  ds_1.country_name AS affected_country_1, ds_2.country_name AS affected_country_2 , d.disaster_name    
FROM disaster_situation ds_1 
JOIN disaster_situation ds_2 
	ON  ds_1.disaster_id  = ds_2.disaster_id  AND ds_1.country_name < ds_2.country_name 
JOIN disaster d 
	ON d.disaster_id  = ds_1.disaster_id ; 