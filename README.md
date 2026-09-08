Supply Chain & E-Commerce Analytics Project | PostgreSQL
Project Overview
This project was designed to analyze the end-to-end operations of an e-commerce business, covering sales performance, customer behavior, inventory management, fulfillment operations, and supplier performance.
Using a dimensional data model and advanced SQL analysis techniques, the project transforms transactional data into actionable business insights that support data-driven decision-making across sales, supply chain, and logistics functions.
________________________________________
Business Problem
Modern e-commerce businesses generate large volumes of data across multiple operational areas. However, raw data alone cannot answer critical business questions such as:
•	Which products are frequently purchased together?
•	Which fulfillment hubs operate most efficiently?
•	Which suppliers consistently meet delivery commitments?
•	Which products are at risk of stock-outs or overstocking?
•	How do sales trends vary across platforms and time periods?
This project addresses these challenges through structured data modeling and analytical SQL queries.
________________________________________
Data Model
A star-schema design was implemented to support scalable and efficient reporting.
Fact Tables
•	Fact Orders
•	Fact Order Items
•	Fact Fulfillment
•	Fact Inventory Daily
Dimension Tables
•	Dim Customers
•	Dim Products
•	Dim Suppliers
•	Dim Hubs
This structure enables flexible analysis across customer, product, supplier, inventory, and fulfillment domains.
________________________________________
Key Analytics Performed
📈 Sales Performance Analysis
Analyzed monthly sales performance across sales platforms by measuring:
•	Total Orders
•	Gross Revenue
•	Gross Profit
•	Average Order Value (AOV)
•	Average Basket Size
This analysis highlights revenue trends and customer purchasing behavior.
________________________________________
🛒 Product Affinity & Market Basket Analysis
Identified products frequently purchased together using self-joins on order item data.
Business value:
•	Cross-selling opportunities
•	Product bundling strategies
•	Recommendation engine insights
•	Improved merchandising decisions
________________________________________
🚚 Fulfillment Hub Performance Analysis
Evaluated operational efficiency across distribution hubs through:
•	Orders Handled
•	Average Packing Lag Time
•	Average Shipping Transit Time
•	Handling Cost Analysis
•	Delivery Delay Rate
This helps identify operational bottlenecks and optimize logistics execution.
________________________________________
📦 Inventory Health Monitoring
Developed inventory health indicators using Days of Coverage calculations.
Products were classified into:
•	Critical Stock-Out Risk
•	Replenishment Required
•	Overstock Risk
•	Balanced Inventory
This analysis supports proactive inventory planning and working capital optimization.
________________________________________
🤝 Supplier Performance & SLA Compliance
Measured supplier reliability by evaluating:
•	Actual Transit Time
•	SLA Variance
•	Delivery Breach Rate
•	Order Volume by Supplier
The results help identify high-performing suppliers and supplier-related fulfillment risks.
________________________________________
Technologies Used
•	PostgreSQL
•	SQL
•	Data Modeling
•	Star Schema Design
•	Aggregation & Window Functions
•	CTEs (Common Table Expressions)
•	Business Intelligence Analytics
________________________________________
Key Business Insights
•	Customer purchasing patterns revealed strong product affinity opportunities.
•	Several products required replenishment based on inventory coverage analysis.
•	Supplier performance varied significantly, with measurable SLA breach rates.
•	Fulfillment hub efficiency differed across locations, impacting delivery performance.
•	Sales trends and basket size metrics provided visibility into customer buying behavior and revenue growth.
________________________________________
Project Outcome
This project demonstrates how SQL can be used beyond data retrieval to solve real business problems. By combining sales analytics, inventory management, supplier evaluation, and fulfillment performance monitoring, the solution delivers a comprehensive view of e-commerce operations and supports strategic decision-making through data.



