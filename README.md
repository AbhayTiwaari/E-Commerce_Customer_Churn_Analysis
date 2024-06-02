# E-Commerce_Customer_Churn_Analysis

Customer churn, where customers stop doing business with a company, poses a major challenge for e-commerce businesses. Retaining customers is crucial for success, and identifying those at risk is essential. This analysis of an online retail dataset provides key insights into customer churn, guiding proactive measures to reduce attrition and promote loyalty. By understanding the factors driving churn, companies can implement targeted retention strategies, such as appealing promotions and enhanced customer engagement, to mitigate attrition and ensure long-term success.

## Approached 

The dataset, sourced from Kaggle, includes customer details, satisfaction scores, payment preferences, days since the last order, and cashback amounts. Using MySQL, I cleaned and analyzed the data, and utilized Microsoft Excel for visualizations. The analysis comprises several stages: data cleaning, data exploration, generating insights, and providing recommendations.

## All Queries (Questions) are in MySQL

## Insight 

- The dataset includes 5,630 customers, offering a substantial sample for analysis.
- The overall churn rate is 16.84%, indicating significant attrition.
- Computer users have slightly higher churn rates than phone users.
- Tier 1 cities exhibit lower churn rates compared to Tier 2 and Tier 3 cities.
- Customers closer to the warehouse show lower churn rates.
- "Cash on Delivery" and "E-wallet" payment modes have higher churn rates; "Credit Card" and "Debit Card" have lower rates.
- Longer tenure correlates with lower churn rates, emphasizing early loyalty building.
- Male customers have slightly higher churn rates than female customers, though the difference is minimal.
- App usage time does not significantly affect churn rates.
- More registered devices correlate with higher churn rates.
- "Mobile Phone" order category has the highest churn rate; "Grocery" has the lowest.
- Highly satisfied customers (rating 5) still show relatively higher churn rates.
- Single customers have the highest churn rate; married customers have the lowest.
- Churned customers average four associated addresses, suggesting higher mobility.
- Customer complaints are more prevalent among churned customers.
- Coupon usage is higher among non-churned customers.
- Churned customers had a short time since their last order.
- Moderate cashback amounts correspond to higher churn rates; higher cashback amounts reduce churn.

## Recommendations to reduce customer churn rate

1. Enhance user experience for computer logins by identifying and resolving issues for a smoother experience.
2. Tailor retention strategies based on city tiers with targeted offerings and incentives.
3. Optimize logistics and delivery to improve satisfaction, focusing on reducing delivery times and costs.
4. Simplify and secure payment processes for "Cash on Delivery" and "E-wallet"; promote reliable methods like "Credit Card" and "Debit Card."
5. Improve customer support and complaint resolution by addressing complaints promptly and effectively.
6. Develop targeted retention initiatives for specific order categories, such as "Mobile Phone," with exclusive discounts and rewards.
7. Ensure a consistent experience across devices with features like cross-device syncing and personalized recommendations.
8. Proactively engage and reward satisfied customers with personalized messages, exclusive offers, and loyalty programs.
9. Increase cashback incentives for at-risk customers, using A/B testing to determine effective cashback levels.
