-- name: UpsertUser :one
INSERT INTO users (id, name) 
VALUES (@id, @name)
ON CONFLICT (id) DO UPDATE SET 
    id = EXCLUDED.id, 
    name = EXCLUDED.name 
WHERE users.id = EXCLUDED.id RETURNING *;

-- name: SearchUsers :many
SELECT * FROM users
WHERE (@skip_id::BOOLEAN OR id = ANY(@id::VARCHAR[]))
  AND (@skip_name::BOOLEAN OR name = ANY(@name::VARCHAR[]));

-- name: SelectUser :one
SELECT * FROM users WHERE id = @id;

-- name: DeleteUser :exec
DELETE FROM users WHERE id = @id;