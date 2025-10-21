select * from messy_googleads;

 -- check for data types 
    SELECT column_name, data_type 
    FROM information_schema.columns 
    WHERE table_name = 'your_table_name';

 /* Data types of the Table 
'Ad_ID','text','YES','',NULL,''
'Campaign_Name','text','YES','',NULL,''
'Clicks','int','YES','',NULL,''
'Impressions','int','YES','',NULL,''
'Cost','text','YES','',NULL,'' -> number
'Leads','int','YES','',NULL,''
'Conversions','int','YES','',NULL,''
'Conversion Rate','text','YES','',NULL,'' -> number
'Sale_Amount','text','YES','',NULL,'' -> number
'Ad_Date','text','YES','',NULL,'' -> date format
'Location','text','YES','',NULL,''
'Device','text','YES','',NULL,''
'Keyword','text','YES','',NULL,''
*/

-- Created a Copy of raw data set 
CREATE TABLE google_ads like messy_googleads;

insert into google_ads
select * from messy_googleads;


select `Conversion Rate` from google_ads
group by `Conversion Rate`;


-- Update Campaign_Name
   update google_ads
    set Campaign_Name = lower(trim(Campaign_Name));
    
/*  'dataanalyticscourse'
    'data anlytics corse'
    'data analytcis course'
    'data analytics corse'
*/

UPDATE google_ads
SET Campaign_Name = 
  CASE 
    WHEN LOWER(REPLACE(Campaign_Name, ' ', '')) IN ('dataanalyticscourse', 'dataanlyticscorse', 'dataanalytciscourse', 'dataanalyticscorse')
      THEN 'data analytics course'
    ELSE Campaign_Name
  END;

    
 select Campaign_Name from google_ads
  group by Campaign_Name;
    
  -- update null values with 0 and unknown
           
			-- update cost 
      UPDATE google_ads
          SET Cost = (
			  CASE
				WHEN TRIM(REPLACE(REPLACE(REPLACE(Cost, '$', ''), ',', ''), ' ', '')) REGEXP '^[0-9]+(\\.[0-9]+)?$'
				  THEN CAST(REPLACE(REPLACE(REPLACE(TRIM(Cost), '$', ''), ',', ''), ' ', '') AS DECIMAL(10,2))
				ELSE 0   -- or use 0 if that fits your use case better
			  END
			);
         05:10:05	select cost,`Conversion Rate`,Sale_Amount from google_ads   
         group by cost,`Conversion Rate`,Sale_Amount   order by cost,`Conversion Rate`,Sale_Amount LIMIT 
         0, 50000	2326 row(s) returned	0.013 sec / 0.00051 sec

    
     -- Update the values for uniformity of length in columns 
            UPDATE google_ads
            SET 
            Cost = ROUND(CAST(Cost AS DECIMAL(10,2)),2),
            `Conversion Rate` = ROUND(CAST(`Conversion Rate` AS DECIMAL(10,2)), 2),
             Sale_Amount = ROUND(CAST(Sale_Amount AS DECIMAL(10,1)), 1);
            

            
	-- replacing value 0 with average 
         
           update google_ads
              set Cost = (
	             select avg_value from (
                     select avg(cast(Cost as decimal(10,2))) as avg_value from google_ads
					 where Cost is not null and trim(Cost) <> '' and Cost <> 0 ) as temp_table
				)
			where Cost = 0;
            
		update google_ads
          SET Cost = round(Cost,1);
                 


  SELECT * from google_ads;
	-- update sale_amount
  
    UPDATE google_ads
          SET Sale_Amount = (
			  CASE
				WHEN TRIM(REPLACE(REPLACE(REPLACE(Sale_Amount, '$', ''), ',', ''), ' ', '')) REGEXP '^[0-9]+(\\.[0-9]+)?$'
				  THEN CAST(REPLACE(REPLACE(REPLACE(TRIM(Sale_Amount), '$', ''), ',', ''), ' ', '') AS DECIMAL(10,2))
				ELSE 0   -- or use 0 if that fits your use case better
			  END
			);
         -- replacing value 0 with average 
         
           update google_ads
              set Sale_Amount = (
	             select avg_value from (
                     select avg(cast(Sale_Amount as decimal(10,2))) as avg_value from google_ads
					 where Sale_Amount is not null and trim(Cost) <> '' and Sale_Amount <> 0 ) as temp_table
				)
			where Sale_Amount = 0;
            
            	update google_ads
                  SET Sale_Amount = round(Sale_Amount,1);
             
             select * from google_ads;
                 
	-- update conversion_rate
					  UPDATE google_ads
					SET  `Conversion Rate`= 
					  ROUND(
						CAST(
						  NULLIF(TRIM(`Conversion Rate`), '') AS DECIMAL(10,4)
						), 2
					  )
					WHERE `Conversion Rate` IS NOT NULL OR TRIM(`Conversion Rate`) <> '';
					 
					 select * from google_ads;

					  UPDATE google_ads
					  SET `Conversion Rate` = 0.00
					  WHERE `Conversion Rate` IS NULL;
  
			-- updating 0.00 to average 
					update google_ads
						set `Conversion Rate` = (
						 select avg_value from (
						 select avg(`Conversion Rate`) as avg_value from google_ads
							where `Conversion Rate` <> 0.00 and `Conversion Rate` is not null
								) as temp_table
								 )
							where `Conversion Rate`=0.00;
							  
							update google_ads
							set `Conversion Rate` = round(`Conversion Rate`,2);
							  
  select cost,`Conversion Rate`,Sale_Amount from google_ads
  group by cost,`Conversion Rate`,Sale_Amount
  order by cost,`Conversion Rate`,Sale_Amount ;
  
  
              -- count of null values 
					SELECT
					  COUNT(*) AS TotalRows,
					  COUNT(Ad_ID) AS NonNull_Ad_ID, COUNT(*) - COUNT(Ad_ID) AS Null_Ad_ID,
					  COUNT(Campaign_Name) AS NonNull_Campaign_Name, COUNT(*) - COUNT(Campaign_Name) AS Null_Campaign_Name,
					  COUNT(Clicks) AS NonNull_Clicks, COUNT(*) - COUNT(Clicks) AS Null_Clicks,
					  COUNT(Impressions) AS NonNull_Impressions, COUNT(*) - COUNT(Impressions) AS Null_Impressions,
					  COUNT(Cost) AS NonNull_Cost, COUNT(*) - COUNT(Cost) AS Null_Cost,
					  COUNT(Leads) AS NonNull_Leads, COUNT(*) - COUNT(Leads) AS Null_Leads,
					  COUNT(Conversions) AS NonNull_Conversions, COUNT(*) - COUNT(Conversions) AS Null_Conversions,
					  COUNT(`Conversion Rate`) AS NonNull_Conversion_Rate, COUNT(*) - COUNT(`Conversion Rate`) AS Null_Conversion_Rate,
					  COUNT(Sale_Amount) AS NonNull_Sale_Amount, COUNT(*) - COUNT(Sale_Amount) AS Null_Sale_Amount,
					  COUNT(Ad_Date) AS NonNull_Ad_Date, COUNT(*) - COUNT(Ad_Date) AS Null_Ad_Date,
					  COUNT(Location) AS NonNull_Location, COUNT(*) - COUNT(Location) AS Null_Location,
					  COUNT(Device) AS NonNull_Device, COUNT(*) - COUNT(Device) AS Null_Device,
					  COUNT(Keyword) AS NonNull_Keyword, COUNT(*) - COUNT(Keyword) AS Null_Keyword
                   FROM google_ads;


    select * from google_ads;

-- update date and time 
  UPDATE google_ads
    SET Ad_Date = STR_TO_DATE(Ad_Date, '%d/%m/%y');

select * from google_ads;

-- update keyword 
update google_ads
 set keyword = lower(trim(keyword));
-- update location 
 update google_ads
    set location = 'Hyderabad';
-- update Device 
update google_ads
  set Device = lower(trim(Device));
  


select * from google_ads;
--  Check for Duplicate values based on Ad_ID
select * from 
  ( select *, row_number() over(partition by Ad_ID) as 'rank' from google_ads) as t
where t.rank >1;





					

