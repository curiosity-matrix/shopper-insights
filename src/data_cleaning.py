
"""
Module: data_cleaning.py
Purpose: Step-by-step Data Cleaning and Quality Audit Pipeline (INR Currency)
Tools: Pandas (Data Manipulation) & NumPy (Statistical Formulas)
Author: Ritika Singh
"""

import pandas as pd
import numpy as np


def clean_retail_data(df_raw):
    """
    Takes a raw DataFrame, runs thorough quality checks,
    handles missing values, detects outliers, and returns:
    1. cleaned_df (ready for SQL/ML/Charts)
    2. audit_report (dictionary summarizing what was fixed)
    """
    
    # CREATE A COPY SO WE DON'T MODIFY ORIGINAL RAW DATA
    df = df_raw.copy()
    
    total_raw_rows = len(df)
    

    # STEP 1: CHECK FOR DUPLICATE ROWS

    duplicate_count = df.duplicated().sum()
    if duplicate_count > 0:
        df = df.drop_duplicates()
        
   
    # STEP 2: AUDIT & HANDLE MISSING (NULL) VALUES
   
    missing_ratings_count = 0
    if 'Review Rating' in df.columns:
        missing_ratings_count = df['Review Rating'].isnull().sum()
        
        # WHAT IF: Review Rating has missing values?
        # Fill missing ratings with the MEDIAN rating of that specific category
        if missing_ratings_count > 0:
            if 'Category' in df.columns:
                category_medians = df.groupby('Category')['Review Rating'].transform('median')
                df['Review Rating'] = df['Review Rating'].fillna(category_medians)
            df['Review Rating'] = df['Review Rating'].fillna(df['Review Rating'].median())
            
   
    # STEP 3: OUTLIER DETECTION USING NUMPY (IQR METHOD IN RUPEES)
   
    outlier_count = 0
    upper_bound = 6000.0
    
    # Detect price column (Supports both INR and generic names)
    price_col = None
    for candidate in ['Purchase Amount (INR)', 'Purchase Amount (USD)', 'Price', 'Sales']:
        if candidate in df.columns:
            price_col = candidate
            break
            
    if price_col:
        purchase_col = df[price_col]
        q1 = np.percentile(purchase_col.dropna(), 25)
        q3 = np.percentile(purchase_col.dropna(), 75)
        iqr = q3 - q1
        
        lower_bound = max(0, q1 - (1.5 * iqr))
        upper_bound = q3 + (1.5 * iqr)
        
        outlier_mask = (purchase_col < lower_bound) | (purchase_col > upper_bound)
        outlier_count = int(outlier_mask.sum())
        
        # Capping outliers to preserve records
        df[price_col] = np.clip(df[price_col], lower_bound, upper_bound)
        
   
    # STEP 4: FEATURE ENGINEERING (Adding helpful business columns)
   
    if 'Age' in df.columns:
        age_bins = [17, 30, 50, 100]
        age_labels = ['Young Adult (18-30)', 'Middle-Aged (31-50)', 'Senior (51+)']
        df['Age Group'] = pd.cut(df['Age'], bins=age_bins, labels=age_labels)
        
    if price_col:
        df['Spending Tier'] = np.where(
            df[price_col] >= 3000, 'High Spender (VIP)',
            np.where(df[price_col] >= 1500, 'Medium Spender', 'Budget Spender')
        )
        
   
    # STEP 5: CALCULATE DATA ACCURACY / HEALTH SCORE (0 to 100%)
   
    penalty_missing = (missing_ratings_count / max(1, total_raw_rows)) * 50
    penalty_duplicates = (duplicate_count / max(1, total_raw_rows)) * 50
    health_score = round(max(80.0, 100.0 - penalty_missing - penalty_duplicates), 1)
    
    audit_report = {
        "total_raw_rows": total_raw_rows,
        "clean_rows": len(df),
        "duplicates_removed": int(duplicate_count),
        "missing_ratings_fixed": int(missing_ratings_count),
        "outliers_sanitized": outlier_count,
        "iqr_upper_limit": round(upper_bound, 2),
        "health_score": health_score
    }
    
    return df, audit_report
