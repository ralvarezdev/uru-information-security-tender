CREATE TABLE IF NOT EXISTS decrypter_keys (
    id SERIAL PRIMARY KEY,
    common_name TEXT NOT NULL,
    key_value BYTEA NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_common_name ON decrypter_keys(common_name);

CREATE STORED PROCEDURE upsert_decrypter_key(p_common_name TEXT, p_key_value BYTEA)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO decrypter_keys (common_name, key_value)
    VALUES (p_common_name, p_key_value)
    ON CONFLICT (common_name) DO UPDATE
    SET key_value = EXCLUDED.key_value,
        created_at = CURRENT_TIMESTAMP;
END;
$$;
