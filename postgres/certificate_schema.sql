CREATE TABLE IF NOT EXISTS organizations_keys (
    id SERIAL PRIMARY KEY,
    common_name TEXT NOT NULL,
    key_value BYTEA NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
    removed_at TIMESTAMP WITH TIME ZONE DEFAULT NULL
    UNIQUE (common_name, removed_at IS NULL)
);

CREATE INDEX idx_common_name ON organizations_keys(common_name);

CREATE TABLE IF NOT EXISTS issued_certificates (
    id SERIAL PRIMARY KEY,
    serial_number BIGINT NOT NULL UNIQUE,
    common_name TEXT NOT NULL,
    issued_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL
    revoked_at TIMESTAMP WITH TIME ZONE DEFAULT NULL
);

CREATE STORED PROCEDURE remove_organization_key(p_common_name TEXT)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE organizations_keys
    SET removed_at = CURRENT_TIMESTAMP
    WHERE common_name = p_common_name AND removed_at IS NULL;
END;
$$;

CREATE STORED PROCEDURE revoke_certificate(p_serial_number BIGINT)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE issued_certificates
    SET revoked_at = CURRENT_TIMESTAMP
    WHERE serial_number = p_serial_number AND revoked_at IS NULL
    AND expires_at > CURRENT_TIMESTAMP;
END;
$$;

CREATE STORED PROCEDURE check_certificate_validity(p_serial_number BIGINT)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
DECLARE
    v_is_valid BOOLEAN;
BEGIN
    SELECT (revoked_at IS NULL AND expires_at > CURRENT_TIMESTAMP) INTO v_is_valid
    FROM issued_certificates
    WHERE serial_number = p_serial_number;

    RETURN COALESCE(v_is_valid, FALSE);
END;
$$;

CREATE STORED PROCEDURE issue_certificate(p_serial_number BIGINT, p_common_name TEXT, p_expires_at TIMESTAMP WITH TIME ZONE)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO issued_certificates (serial_number, common_name, expires_at)
    VALUES (p_serial_number, p_common_name, p_expires_at);
END;
$$;

CREATE STORED PROCEDURE revoke_common_name_certificates(p_common_name TEXT)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE issued_certificates
    SET revoked_at = CURRENT_TIMESTAMP
    WHERE common_name = p_common_name AND revoked_at IS NULL
    AND expires_at > CURRENT_TIMESTAMP;
END;
$$;

CREATE STORED PROCEDURE upsert_organization_key(p_common_name TEXT, p_key_value BYTEA)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Revoke all certificates for the common name
    PERFORM revoke_common_name_certificates(p_common_name);

    -- Remove existing active key for the common name
    PERFORM remove_organization_key(p_common_name);

    INSERT INTO organizations_keys (common_name, key_value)
    VALUES (p_common_name, p_key_value);
END;
$$;
