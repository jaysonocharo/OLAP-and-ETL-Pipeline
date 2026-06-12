import pandas as pd

# 1. EXTRACT: Load the dataset
try:
    df = pd.read_csv('sales_data.csv')
    df.columns = df.columns.str.strip()
    print("Mapping columns ...")
except Exception as e:
    print(f"Error loading file: {e}")
    exit()

# 2. TRANSFORM: Create Dimension Tables (Blue Boxes)
# Mapping 'Product_ID' and 'Product_Category' from your CSV
dim_product = df[['Product_ID', 'Product_Category']].drop_duplicates(subset=['Product_ID']).reset_index(drop=True)
dim_product.columns = ['product_id', 'product_type']
dim_product['product_name'] = dim_product['product_id']

# Create dim_time using 'Sale_Date'
df['Sale_Date'] = pd.to_datetime(df['Sale_Date'])
unique_dates = pd.Series(df['Sale_Date'].unique()).sort_values()
dim_time = pd.DataFrame({'action_date': unique_dates})
dim_time['time_id'] = range(1, len(dim_time) + 1)
dim_time['action_year'] = dim_time['action_date'].dt.year
dim_time['action_month'] = dim_time['action_date'].dt.month
dim_time['action_week'] = dim_time['action_date'].dt.isocalendar().week
dim_time['action_weekday'] = dim_time['action_date'].dt.day_name()

# Create dim_store using 'Region'
dim_store = df[['Region']].drop_duplicates().reset_index(drop=True)
dim_store['store_id'] = dim_store.index + 1
dim_store.columns = ['region', 'store_id']


# 3. TRANSFORM: Create Fact Tables (Red Boxes)
df_merged = df.merge(dim_time[['action_date', 'time_id']], left_on='Sale_Date', right_on='action_date')

# Merge the Store Dimension into our main dataframe using Region
df_merged = df_merged.merge(dim_store[['region', 'store_id']], left_on='Region', right_on='region')

#  Add store_id to the selected columns
fact_sales = df_merged[['Product_ID', 'time_id', 'store_id', 'Sales_Amount', 'Quantity_Sold']].copy()
fact_sales.columns = ['product_id', 'time_id', 'store_id', 'price', 'quantity']


fact_supply_order = df_merged[['Product_ID', 'time_id', 'Unit_Cost', 'Quantity_Sold']].copy()
fact_supply_order.columns = ['product_id', 'time_id', 'price', 'quantity']

# 4. LOAD: Save the 5 tables
dim_product.to_csv('dim_product.csv', index=False)
dim_time.to_csv('dim_time.csv', index=False)
dim_store.to_csv('dim_store.csv', index=False)
fact_sales.to_csv('fact_sales.csv', index=False)
fact_supply_order.to_csv('fact_supply_order.csv', index=False)

print("\nETL Successful! Files generated: dim_product, dim_time, dim_store, fact_sales, fact_supply_order")
