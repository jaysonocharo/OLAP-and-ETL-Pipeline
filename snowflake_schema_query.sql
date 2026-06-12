-- Normalized Product Dimension
CREATE TABLE Dim_Category (
    Category_ID INT PRIMARY KEY,
    Category_Name VARCHAR(50)
);

CREATE TABLE Dim_Product_Snowflake (
    Product_ID INT PRIMARY KEY,
    Category_ID INT,
    Product_Name VARCHAR(50),
    FOREIGN KEY (Category_ID) REFERENCES Dim_Category(Category_ID)
);

-- Normalized Location Dimension
CREATE TABLE Dim_Region (
    Region_ID INT PRIMARY KEY,
    Region_Name VARCHAR(50)
);

CREATE TABLE Dim_Store_Snowflake (
    Store_ID INT PRIMARY KEY,
    Region_ID INT,
    City VARCHAR(50),
    FOREIGN KEY (Region_ID) REFERENCES Dim_Region(Region_ID)
);

-- Fact Table stays similar but links to the sub-dimensions
CREATE TABLE Fact_Sales_Snowflake (
    Sales_ID INT PRIMARY KEY,
    Product_ID INT,
    Store_ID INT,
    Total_Sales DECIMAL(10,2),
    FOREIGN KEY (Product_ID) REFERENCES Dim_Product_Snowflake(Product_ID),
    FOREIGN KEY (Store_ID) REFERENCES Dim_Store_Snowflake(Store_ID)
);