# argusindex

# Argus Commodities Indices Calculator

This application is designed to calculate commodities indices based on user-provided deal data. It allows users to import a dataset, calculate the index price for each day included in the raw data, and display the results as a table and chart within the application. Additionally, users can download the output table as a CSV file.

## Getting Started

To get started, follow these steps:

1. Clone or download the repository to your local machine.
2. Ensure you have R and RStudio installed on your machine.
3. Open the `app.R` file in RStudio.
4. Run the application by clicking the 'Run App' button in RStudio.

## Usage

### Uploading Data

1. Click the 'Upload Data.csv' button to select and upload your data file. The data file must be in CSV format and contain the following columns: ID, DEAL DATE, COMMODITY, COMMODITY SOURCE LOCATION, DELIVERY LOCATION, DELIVERY MONTH, DELIVERY YEAR, VOLUME, and PRICE.
2. After uploading the data, select the desired index (COAL2 or COAL4) from the dropdown menu.

### Viewing Results

1. Once the data is uploaded and the index is selected, the application will display a table and chart showing the calculated index prices over time.
2. The table will contain the index prices for each day included in the raw data.
3. The chart will visualize the index prices over time, with a trendline representing the linear regression of the data.

### Downloading Results

1. To download the results table as a CSV file, click the 'Download' button located below the table.

## Testing

The application includes automated tests to ensure the integrity of the data processing and visualization. The tests validate the following:

1. The uploaded data contains at least 9 columns.
2. The calculated index prices are accurate.

To run the tests, ensure that the `testthat` package is installed and run the following command:



 
