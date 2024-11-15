# OpenTable Restaurant Data Analysis Project

## Introduction

The OpenTable Restaurant Data Analysis project focuses on analyzing restaurant data from five major cities in the USA: **San Francisco**, **San Diego**, **New York**, **Chicago**, and **Los Angeles**. The project is a comprehensive end-to-end data analysis task that includes data collection, cleaning, exploratory data analysis (EDA), statistical testing, database management, interactive dashboard creation, and insights extraction using large language models (LLM). 

By leveraging Python, SQL, Dash, Power BI, and other tools, the project helps in uncovering valuable insights into customer preferences, restaurant performance, and trends in different cities.


## Project Overview

This project covers a variety of steps, which are summarized below:

1. **Data Collection**: Web scraping restaurant data from OpenTable using Python.
2. **Data Cleaning**: Preparing the scraped data for analysis.
3. **Exploratory Data Analysis (EDA)**: Understanding the dataset and creating visualizations.
4. **Statistical Testing**: Hypothesis testing to validate assumptions and explore relationships in the data.
5. **Database Management**: Storing data in a PostgreSQL database and running complex SQL queries.
6. **Dashboard Development**: Creating an interactive web application using Dash to visualize insights.
7. **LLM Analysis**: Extracting insights from text data using natural language processing (NLP).
8. **Power BI Dashboard**: Creating a polished final dashboard to present findings.

## Steps Involved

### Step 1: Data Collection (Web Scraping)

The first phase of the project involved collecting restaurant data from the OpenTable website using web scraping techniques. The data includes key restaurant information such as:

- `rest_name`: Name of the restaurant
- `number_of_reviews`: The total number of reviews
- `rating`: Average rating of the restaurant
- `food_type`: Type of cuisine offered
- `coupon`: Any promotional offers
- `food`: Rating of the food quality
- `ambience`: Rating of the atmosphere
- `service`: Rating of the service
- `value`: Rating of the price/quality ratio
- `about_rest`: Brief description of the restaurant
- `comments`: Customer reviews and comments
- `image_url`: URL to an image of the restaurant

**Tools Used**:
- **Selenium**: For automating web browser actions to extract data.
- **Pandas**: For data manipulation and cleaning.
- **NumPy**: For data transformation.
- **Time & Random**: For controlling the scraping flow and mimicking human behavior.

The data was collected for five cities: San Francisco, San Diego, New York, Chicago, and Los Angeles.

### Step 2: Data Cleaning

Once the data was collected, it required cleaning to ensure it was ready for analysis. Using **Pandas** and **NumPy**, I performed the following data cleaning tasks:

- Removed leading and trailing whitespaces in all column values.
- Filled in missing values (NaNs) or dropped rows with missing critical data.
- Removed duplicate entries.
- Standardized column names (e.g., converted all column names to lowercase).
- Identified and addressed incomplete data entries (e.g., rows with missing restaurant names or ratings).

The cleaned dataset was then stored in a structured format, ready for further analysis.

### Step 3: Exploratory Data Analysis (EDA)

After cleaning the data, I performed exploratory data analysis (EDA) to gain deeper insights into the dataset. This stage involved creating various visualizations to better understand the trends and relationships between variables. Using **Pandas**, **Seaborn**, **Matplotlib**, and **WordCloud**, the following visualizations were generated:

- **Top 10 Restaurants by Rating**: A bar chart showing the restaurants with the highest customer ratings.
- **Distribution of Coupon Types**: A pie chart showing the distribution of various coupon types offered by restaurants.
- **Correlation Heatmap**: A heatmap that visualized the correlation between different variables such as food, service, ambience, and value.
- **Top 10 Restaurants by Number of Reviews**: A bar chart displaying the most reviewed restaurants, indicating customer engagement.
- **Most Common Food Types Across Cities**: A stacked bar chart displaying the most common food types in each city.
- **Word Cloud from Customer Comments**: A word cloud visualizing the most frequently mentioned terms in customer reviews, giving insights into customer sentiments.
- **Distribution of Various Ratings**: Histograms/Box plots showing the distribution of ratings for food, service, ambience, and value.

These visualizations helped in understanding key patterns and differences between cities, as well as identifying trends in customer satisfaction.

### Step 4: Statistical Testing

To validate assumptions and explore relationships between variables, I used statistical tests:

- **T-test**: Used to compare the means of two groups (e.g., comparing average ratings between two cities).
- **ANOVA**: Used to test the differences in means between multiple groups (e.g., comparing restaurant ratings across five cities).

These tests helped confirm patterns identified during EDA and provided deeper statistical insights into the data.

### Step 5: Database Management with SQL and PostgreSQL

For better data management, I used **PostgreSQL** to store the cleaned data. I utilized **SQLAlchemy** to interface with PostgreSQL and ran over 30 different SQL queries. These queries included:

- **Common Table Expressions (CTEs)**: Used to improve query readability and structure.
- **Subqueries**: Helped break down complex queries into smaller, manageable parts.
- **Window Functions**: Used for ranking restaurants within cities based on their ratings.
- **Joins**: Combined restaurant data with city-specific and cuisine-type data to gain a deeper understanding of customer preferences.

These SQL queries were instrumental in extracting insights and answering business questions.

### Step 6: Dashboard Development with Dash and AWS

To present the results in an interactive and user-friendly format, I developed a web-based dashboard using **Dash**. The dashboard allows users to:

- Filter restaurants by city, food type, and rating.
- View dynamic visualizations such as bar charts, pie charts, and heatmaps.
- Explore various aspects of the data interactively.

I deployed the Dash app on **Amazon Web Services (AWS)**, providing an online platform for users to access the dashboard.

### Step 7: Large Language Model (LLM) Analysis

As part of the project, I explored the use of **Large Language Models (LLMs)** to analyze the textual data in the dataset, including restaurant descriptions and customer reviews. Using NLP techniques, I performed sentiment analysis and extracted keywords from customer comments. This provided additional insights into customer preferences and sentiments, complementing the quantitative analysis.

### Step 8: Power BI Dashboard

Finally, I created a polished Power BI dashboard that combines various visualizations and metrics. The Power BI dashboard includes:

- Restaurant distribution by city and cuisine.
- Average ratings and price ranges for restaurants.
- Popularity trends based on the number of reviews and customer ratings.

The Power BI dashboard serves as a comprehensive, interactive report designed for stakeholders or decision-makers.

## Project Structure

