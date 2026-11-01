CREATE TABLE IF NOT EXISTS events (
    event_time    TIMESTAMPTZ,
    event_type    TEXT,
    product_id    BIGINT,
    category_id   BIGINT,
    category_code TEXT,
    brand         TEXT,
    price         NUMERIC(12, 2),
    user_id       BIGINT,
    user_session  TEXT
);
