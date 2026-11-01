WITH product_sessions AS (
    SELECT
        user_session,
        product_id,

        MIN(event_time) FILTER (
            WHERE event_type = 'view'
        ) AS first_view,

        MIN(event_time) FILTER (
            WHERE event_type = 'cart'
        ) AS first_cart,

        MIN(event_time) FILTER (
            WHERE event_type = 'purchase'
        ) AS first_purchase,

        AVG(price) FILTER (
            WHERE event_type = 'view'
              AND category_code = 'electronics.smartphone'
        ) AS smartphone_price

    FROM events
    WHERE user_session IS NOT NULL
      AND product_id IS NOT NULL
      AND (
          category_code = 'electronics.smartphone'
          OR event_type IN ('cart', 'purchase')
      )
    GROUP BY user_session, product_id
),

segmented AS (
    SELECT
        *,
        CASE
            WHEN smartphone_price < 50 THEN '1. Below 50'
            WHEN smartphone_price < 200 THEN '2. 50-199.99'
            WHEN smartphone_price < 500 THEN '3. 200-499.99'
            ELSE '4. 500+'
        END AS price_segment
    FROM product_sessions
    WHERE first_view IS NOT NULL
      AND smartphone_price IS NOT NULL
)

SELECT
    price_segment,
    COUNT(*) AS viewed,

    COUNT(*) FILTER (
        WHERE first_cart > first_view
    ) AS carted,

    COUNT(*) FILTER (
        WHERE first_cart > first_view
          AND first_purchase > first_cart
    ) AS purchased,

    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE first_cart > first_view
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS view_to_cart_pct,

    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE first_cart > first_view
              AND first_purchase > first_cart
        ) / NULLIF(
            COUNT(*) FILTER (
                WHERE first_cart > first_view
            ), 0
        ),
        2
    ) AS cart_to_purchase_pct

FROM segmented
GROUP BY price_segment
ORDER BY price_segment;
