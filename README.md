 You will expand it into a full write-up in Part 2.

## Project Title: New York City's Bike Share Program
        Project Goal: To understand what drives daily ridership so that the Operations Team can plan bike availability and staffing.
        1. Code Folder
                1. eda.ipynb exploratory data analysis
                2. model.ipynb data modeling
                3. preprocessing.ipynb data processing
        2. Data Folder
                1. citibike_weather_daily.csv final joined table
                2. Step 9: build_dataset.sql final query 
        3. Docs Folder
                1. data dictionary 
                2. notes 
                3. supporting material
        4. Queries
                1. Step 9: final SQL
        5. Data Quality Issues
                During the initial exploratory data analysis (EDA), the dataset contained one missing values for precipitation (`precip_in`). 
                During pre-processing, it was converted to a NaN and eventually dropped entireluy from the dataset. 
                Ride dates and obs_dates are both columns that were initially strings, these were converted to date data types.
                The days of the week were hot encoded as categorical data.
        6. Model Performance
                Testing R² = 0.7588 determined how much variation in the dependent variable is expained by the model. 
                In this case, it is 75.88%. The training model actually learned the trends in the data.
                Our prediction was typically off by about 6,660 rides. The gap between the MAE and  RMSE was not very wide, the total error was dominated by a few missed days. 
                The suspect days are thanksgiving or major holidays or weekends.
                Each additional inch of rain costs us roughly 3,656 rides. 
                On Sunday ride demand dropped by roughly  6559 rides.For every 1 degree increase in temperature, we gain roughly 5,736 rides.




```