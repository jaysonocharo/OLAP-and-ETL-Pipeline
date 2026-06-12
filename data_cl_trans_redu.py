import pandas as pd
import numpy as np
from sklearn.preprocessing import MinMaxScaler
from sklearn.decomposition import PCA

# ---------------------------------------------------------
# EXTRACT: Load your selected dataset (just like schema1.py)
# ---------------------------------------------------------
try:
    df = pd.read_csv('sales_data.csv')
    df.columns = df.columns.str.strip()
    print("Successfully loaded sales_data.csv for pre-processing.\n")
except Exception as e:
    print(f"Error loading file: {e}")
    exit()

print("--- ORIGINAL DATA HEAD ---")
print(df[['Product_ID', 'Region', 'Sales_Amount', 'Quantity_Sold']].head(3), "\n")


# =========================================================
# i) DATA CLEANING
# =========================================================

# 1. Handling Missing Data (Imputation)
# If any rows are missing Sales_Amount, fill them with the column's mean
df['Sales_Amount'] = df['Sales_Amount'].fillna(df['Sales_Amount'].mean())
# Fill missing Quantities with the median
df['Quantity_Sold'] = df['Quantity_Sold'].fillna(df['Quantity_Sold'].median())

# 2. Handling Noisy Data (Binning)
# Grouping continuous Sales_Amount into 3 discrete bins (Low, Medium, High) to smooth noise
df['Sales_Bin'] = pd.qcut(df['Sales_Amount'], q=3, labels=['Low', 'Medium', 'High'], duplicates='drop')


# =========================================================
# ii) DATA TRANSFORMATION
# =========================================================

# 1. Encoding (Categorical to Numeric)
# One-Hot Encoding the 'Region' column (e.g., creates 'Region_North', 'Region_South' columns)
df_transformed = pd.get_dummies(df, columns=['Region'], drop_first=False)

# 2. Normalization (Min-Max Scaling)
# Scaling Sales_Amount and Unit_Cost to be between 0.0 and 1.0 for ML algorithms
scaler = MinMaxScaler()
df_transformed[['Sales_Scaled', 'Cost_Scaled']] = scaler.fit_transform(df_transformed[['Sales_Amount', 'Unit_Cost']])

# 3. Aggregation
# Extracting the 'Month' from Sale_Date to aggregate daily data into monthly data
df_transformed['Sale_Date'] = pd.to_datetime(df_transformed['Sale_Date'])
df_transformed['Sale_Month'] = df_transformed['Sale_Date'].dt.month


# =========================================================
# iii) DATA REDUCTION
# =========================================================

# 1. Attribute / Feature Subset Selection
# Dropping columns that aren't needed for analysis (like the raw unscaled columns or IDs)
df_reduced = df_transformed.drop(columns=['Sale_Date', 'Sales_Amount', 'Unit_Cost', 'Product_ID'])

# 2. Numerosity Reduction (Sampling)
# Taking a random 80% sample of the dataset to reduce volume while maintaining distribution
df_sampled = df_reduced.sample(frac=0.8, random_state=42)

# 3. Dimensionality Reduction (PCA)
# Compressing the 3 main numeric features into 2 Principal Components
numeric_features = df_sampled[['Sales_Scaled', 'Cost_Scaled', 'Quantity_Sold']].dropna()
pca = PCA(n_components=2)
pca_result = pca.fit_transform(numeric_features)



print("--- PRE-PROCESSING COMPLETE (SHAPES) ---")
print(f"Original Dataset Shape: {df.shape}")
print(f"Reduced Sample Shape: {df_sampled.shape}")
print(f"PCA Result Shape: {pca_result.shape}\n")

print("--- GLIMPSE OF THE TRANSFORMED DATA (First 5 Rows) ---")
# Printing the actual dataframe after cleaning, scaling, and encoding
print(df_sampled.head(5).to_string(), "\n")

print("--- GLIMPSE OF THE PCA RESULT (First 5 Rows) ---")
# PCA outputs a raw NumPy array, so we wrap it in a DataFrame to make it pretty
pca_df = pd.DataFrame(pca_result, columns=['Principal_Component_1', 'Principal_Component_2'])
print(pca_df.head(5).to_string())