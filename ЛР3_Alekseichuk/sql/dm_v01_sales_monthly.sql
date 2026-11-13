DROP VIEW IF EXISTS dm_v01_sales_monthly;
CREATE VIEW dm_v01_sales_monthly AS
SELECT purchase_month                        AS month,        -- 'YYYY-MM-01' → тип «Дата» в DataLens
       purchase_year                         AS year,
       region,                                                -- макрорегион (рус.)
       customer_state                        AS state,        -- код штата (ключ)
       state_name,                                            -- название штата для подписей
       COUNT(*)                              AS orders,       -- доставленных заказов
       ROUND(SUM(order_value), 2)            AS gmv,          -- выручка: товары + доставка, BRL
       ROUND(SUM(goods_value), 2)            AS goods_value,  -- в т. ч. стоимость товаров
       ROUND(SUM(freight_value), 2)          AS freight_value,-- в т. ч. доставка
       SUM(items_cnt)                        AS items,        -- позиций (товаров) в заказах
       COUNT(DISTINCT customer_unique_id)    AS customers,    -- уникальных клиентов в месяце и штате
       state_lat, state_lng                                   -- центр штата (для карты, по желанию)
FROM core_order
WHERE order_status = 'delivered'
  AND purchase_month BETWEEN '2017-01-01' AND '2018-08-01'   -- только полные месяцы
GROUP BY purchase_month, purchase_year, region, customer_state, state_name, state_lat, state_lng;
