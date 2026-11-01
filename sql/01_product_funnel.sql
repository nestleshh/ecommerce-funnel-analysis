WITH product_session_events AS (
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
        ) AS first_purchase
    FROM events
    WHERE user_session IS NOT NULL
      AND product_id IS NOT NULL
    GROUP BY user_session, product_id
),

funnel AS (
    SELECT
        COUNT(*) FILTER (
            WHERE first_view IS NOT NULL
        ) AS viewed,

        COUNT(*) FILTER (
            WHERE first_view IS NOT NULL
              AND first_cart > first_view
        ) AS viewed_then_carted,

        COUNT(*) FILTER (
            WHERE first_view IS NOT NULL
              AND first_cart > first_view
              AND first_purchase > first_cart
        ) AS completed_funnel
    FROM product_session_events
)

SELECT
    viewed,
    viewed_then_carted,
    completed_funnel,

    ROUND(
        100.0 * viewed_then_carted
        / NULLIF(viewed, 0),
        2
    ) AS view_to_cart_pct,

    ROUND(
        100.0 * completed_funnel
        / NULLIF(viewed_then_carted, 0),
        2
    ) AS cart_to_purchase_pct,

    ROUND(
        100.0 * completed_funnel
        / NULLIF(viewed, 0),
        2
    ) AS overall_conversion_pct
FROM funnel;