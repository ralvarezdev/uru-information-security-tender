CREATE TABLE IF NOT EXISTS encrypted_files (
    id SERIAL PRIMARY KEY,
    filename TEXT NOT NULL,
    common_name TEXT NOT NULL,
    uploaded_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    removed_at TIMESTAMP WITH TIME ZONE DEFAULT NULL
);

CREATE PROCEDURE remove_encrypted_file(p_filename TEXT, p_common_name TEXT)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE encrypted_files
    SET removed_at = CURRENT_TIMESTAMP
    WHERE filename = p_filename AND common_name = p_common_name AND removed_at IS
    NULL;
END;
$$;

CREATE PROCEDURE remove_encrypted_files()
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE encrypted_files
    SET removed_at = CURRENT_TIMESTAMP
    WHERE removed_at IS NULL;
END;
$$;

CREATE PROCEDURE add_encrypted_file(p_filename TEXT, p_common_name TEXT)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO encrypted_files (filename, common_name)
    VALUES (p_filename, p_common_name);
END;
$$;

CREATE FUNCTION list_active_files()
RETURNS TABLE(filename TEXT, uploaded_at TIMESTAMP WITH TIME ZONE)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT filename, uploaded_at
    FROM encrypted_files
    WHERE removed_at IS NULL;
END;
$$