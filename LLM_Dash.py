#!/usr/bin/env python
# coding: utf-8

# In[4]:


import os
import pandas as pd
from dash import Dash, dcc, html, Input, Output
from openai import OpenAI

# Load the datasets
chicago_df = pd.read_csv('Chicago.csv')
los_angeles_df = pd.read_csv('Los Angeles.csv')
new_york_df = pd.read_csv('New York.csv')
san_francisco_df = pd.read_csv('San Francisco.csv')
san_diego_df = pd.read_csv('San Diego.csv')

# Combine datasets into one DataFrame with an additional 'city' column
chicago_df['city'] = 'Chicago'
los_angeles_df['city'] = 'Los Angeles'
new_york_df['city'] = 'New York'
san_francisco_df['city'] = 'San Francisco'
san_diego_df['city'] = 'San Diego'
df = pd.concat([chicago_df, los_angeles_df, new_york_df, san_francisco_df, san_diego_df])

# Set up OpenAI client
client = OpenAI(api_key="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")

# Initialize the Dash app
app = Dash(__name__)

# Define the layout of the app
app.layout = html.Div([
    html.H1("Restaurant Data Analysis", style={'text-align': 'center', 'color': '#FFFFFF'}),

    # Dropdown for selecting city with placeholder text
    dcc.Dropdown(
        id='city-dropdown',
        options=[{'label': city, 'value': city} for city in df['city'].unique()],
        placeholder='Select the city',  # Placeholder text
        clearable=False,
        style={'margin-bottom': '20px', 'font-size': '18px'}
    ),

    # Filter fields for rating and number_of_reviews, initially hidden
    html.Div(id='filters-container', style={'display': 'none'}, children=[
        html.Label("Rating Range", style={'color': '#FFFFFF'}),
        dcc.RangeSlider(
            id='rating-slider',
            min=0, max=5, step=0.5, value=[0, 5],
            marks={i: str(i) for i in range(6)},
            tooltip={"placement": "bottom", "always_visible": True}
        ),

        html.Br(),

        html.Label("Number of Reviews Range", style={'color': '#FFFFFF'}),
        dcc.RangeSlider(
            id='review-slider',
            min=0, max=12000, step=500, value=[0, 12000],
            marks={i: f"{i}" for i in range(0, 12001, 1000)},
            tooltip={"placement": "bottom", "always_visible": True}
        ),

        html.Br(),
        html.Label("Select a Restaurant", style={'color': '#FFFFFF'}),
        dcc.Dropdown(id='restaurant-dropdown', clearable=False, style={'margin-bottom': '20px', 'font-size': '18px'})
    ]),

    # Placeholder for restaurant details and summary
    html.Div(id='graphs-container', style={'margin-top': '20px'})
], style={
    'background': 'linear-gradient(to right,  #f2b8b8, #E23D3D)',  # Gradient background
    'padding': '40px',
    'font-family': 'Arial, sans-serif'
})


# Callback to show filters when a city is selected
@app.callback(
    Output('filters-container', 'style'),
    Input('city-dropdown', 'value')
)
def toggle_filters(selected_city):
    if selected_city:
        return {'display': 'block'}
    else:
        return {'display': 'none'}


# Callback to update the restaurant dropdown based on city and filters
@app.callback(
    Output('restaurant-dropdown', 'options'),
    Input('city-dropdown', 'value'),
    Input('rating-slider', 'value'),
    Input('review-slider', 'value')
)
def update_restaurant_options(selected_city, rating_range, review_range):
    min_rating, max_rating = rating_range
    min_reviews, max_reviews = review_range

    # Filter data based on city and filters
    filtered_df = df[(df['city'] == selected_city) &
                     (df['rating'] >= min_rating) & (df['rating'] <= max_rating) &
                     (df['number_of_reviews'] >= min_reviews) & (df['number_of_reviews'] <= max_reviews)]

    # Return options for the restaurant dropdown
    return [{'label': name, 'value': name} for name in filtered_df['rest_name']]


# Callback to update the restaurant details and generate a summary of comments
@app.callback(
    Output('graphs-container', 'children'),
    Input('restaurant-dropdown', 'value'),
    Input('city-dropdown', 'value')
)
def update_restaurant_details(selected_restaurant, selected_city):
    if not selected_restaurant:
        return []  # No display if no restaurant is selected

    # Filter data to get the specific restaurant's details
    restaurant_data = df[(df['city'] == selected_city) & (df['rest_name'] == selected_restaurant)].iloc[0]

    # Extract specific fields
    image_url = restaurant_data['image_url']
    restaurant_url = restaurant_data['url']  # Assuming 'url' is the column name for restaurant link
    about_rest = restaurant_data['about_rest']
    ambience = restaurant_data['ambience']
    food = restaurant_data['food']
    service = restaurant_data['service']
    value = restaurant_data['value']
    comments = restaurant_data['comments'] if pd.notna(restaurant_data['comments']) else "No comments available"

    # Generate summary of comments using OpenAI
    try:
        chat_completion = client.chat.completions.create(
            messages=[
                {
                    "role": "system",
                    "content": "You are a helpful assistant. Summarize the following restaurant reviews."
                },
                {
                    "role": "user",
                    "content": comments
                }
            ],
            model="gpt-3.5-turbo",
        )
        summary = chat_completion.choices[0].message.content
    except Exception as e:
        summary = f"An error occurred while summarizing comments: {str(e)}"

    # Display the restaurant's image as clickable link, about section, and ratings, along with the summary
    return [
        html.A(
            html.Img(src=image_url, style={'width': '500px', 'height': 'auto', 'object-fit': 'cover'}),
            href=restaurant_url, target="_blank"
        ),
        html.H3("About the Restaurant"),
        html.P(about_rest),
        html.H3("Ratings"),
        html.P(f"Ambience: {ambience}/5"),
        html.P(f"Food: {food}/5"),
        html.P(f"Service: {service}/5"),
        html.P(f"Value: {value}/5"),
        html.H3("Summary of Comments"),
        html.P(summary)
    ]


if __name__ == '__main__':
    app.run_server(debug=True, port=8055)



# In[ ]:




