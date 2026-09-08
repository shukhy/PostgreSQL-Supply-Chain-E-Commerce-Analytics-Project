select * from public.dim_customers;

select * from public.dim_products;

select * from public.dim_suppliers;

select * from public.fact_orders;

select * from public.fact_order_items;

select * from public.fact_inventory_daily;

select * from public.fact_fulfillment;

select * from public.dim_hubs;


-- Sales trend, AOV, Basket Size

SELECT 
    to_char(o.order_date::date, 'YYYY-MM') AS sales_month,o.platform,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(o.total_order_amount) AS total_gross_revenue,
    SUM(o.total_order_amount - o.total_cogs) AS gross_profit,
    AVG(o.total_order_amount) AS average_order_value,
    AVG(o.items_count) AS average_basket_size
FROM fact_orders o
GROUP BY 1, 2
ORDER BY sales_month DESC, total_gross_revenue DESC;


-- Product Affinity and Market Basket Analysis.

SELECT 
    p1.product_name AS anchor_product,
    p2.product_name AS co_purchased_product,
    COUNT(*) AS joint_order_frequency,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(DISTINCT order_id) FROM fact_order_items), 2) AS co_occurrence_pct
FROM fact_order_items i1
JOIN fact_order_items i2 
  ON i1.order_id = i2.order_id 
 AND i1.product_id < i2.product_id
JOIN dim_products p1 ON i1.product_id = p1.product_id
JOIN dim_products p2 ON i2.product_id = p2.product_id
GROUP BY 1, 2
HAVING COUNT(*) >= 5
ORDER BY joint_order_frequency DESC;

--Fulfillment Hub Performance Analysis

SELECT 
    h.hub_name,
    h.city,
    COUNT(f.fulfillment_id) AS orders_handled,
    AVG(f.ship_date::date - f.order_date::date) AS avg_internal_pack_lag_days,
    AVG(f.delivery_date::date - f.ship_date::date) AS avg_carrier_transit_days,
    AVG(f.handling_cost) AS avg_unit_handling_cost,
    COUNT(CASE WHEN f.fulfillment_status = 'Delayed' THEN 1 END) * 100.0 / COUNT(*) AS delay_rate_pct
FROM  public.fact_fulfillment f
JOIN public.dim_hubs h ON f.hub_id = h.hub_id
GROUP BY 1, 2
ORDER BY avg_internal_pack_lag_days DESC;

--Inventory Health Analysis

WITH inventory_coverage AS (
    SELECT 
        h.hub_name,
        p.product_name,
        p.category,
        inv.stock_on_hand,
        inv.daily_demand_units,
        inv.safety_stock,
        inv.reorder_point,
        ROUND(inv.stock_on_hand::numeric / NULLIF(inv.daily_demand_units, 0), 1) AS days_of_coverage
    FROM public.fact_inventory_daily  inv
    JOIN public.dim_products p ON inv.product_id = p.product_id
    JOIN public.dim_hubs  h ON inv.hub_id = h.hub_id
),
final_master AS (
    SELECT 
        hub_name,
        product_name,
        category,
        stock_on_hand,
        daily_demand_units,
        days_of_coverage,
        CASE 
            WHEN days_of_coverage < 7 THEN 'CRITICAL: Stock-Out Hazard'
            WHEN stock_on_hand <= reorder_point THEN 'TRIGGER: Replenishment Required'
            WHEN days_of_coverage > 45 THEN 'WARNING: Overstock Capital Lockup'
            ELSE 'BALANCED: Optimum Run-Rate'
        END AS inventory_health_status
    FROM inventory_coverage
    ORDER BY days_of_coverage ASC
)
SELECT 
    inventory_health_status,
    COUNT(*) AS total_count
FROM final_master
GROUP BY 1
ORDER BY 2 DESC;


--Supplier Performance & SLA Compliance Analysis

SELECT 
    s.supplier_name,
    s.country,
    s.promised_lead_time_days AS contractual_sla_days,
    COUNT(f.fulfillment_id) AS total_orders_routed,
    ROUND(AVG(f.delivery_date::date - f.ship_date::date), 1) AS actual_average_transit_days,
    ROUND(
        AVG(
            (f.delivery_date::date - f.ship_date::date)
            - s.promised_lead_time_days
        ),
        1
    ) AS sla_days_variance,
    ROUND(
        COUNT(
            CASE
                WHEN (f.delivery_date::date - f.ship_date::date)
                     > s.promised_lead_time_days
                THEN 1
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS supplier_breach_rate_pct
FROM public.fact_fulfillment f
JOIN public.dim_suppliers s
    ON f.supplier_id = s.supplier_id
GROUP BY
    s.supplier_name,
    s.country,
    s.promised_lead_time_days
ORDER BY supplier_breach_rate_pct DESC;


--To combine order transactions with customer and hub details, creating a complete dataset for sales reporting and business analysis.

SELECT
*
FROM 
fact_orders as fo
INNER JOIN dim_customers as dc ON dc.customer_id = fo.customer_id
INNER JOIN dim_hubs as dh ON dh.hub_id = fo.hub_id;









