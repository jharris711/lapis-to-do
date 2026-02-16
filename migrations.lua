local schema = require("lapis.db.schema")
local types  = schema.types
local db     = require("lapis.db")

return {
    -- Migration 1: Create users table
    [1] = function()
        schema.create_table("users", {
            { "id", types.serial },
            { "first_name", types.varchar({ length = 100 }) },
            { "last_name", types.varchar({ length = 100 }) },
            { "email", types.varchar({ length = 255 }) },
            { "password", types.varchar({ length = 255 }) },
            { "created_at", types.time },
            { "updated_at", types.time },

            "PRIMARY KEY (id)",
            "UNIQUE (email)"
        })
    end,

    -- Migration 2: Create todos table
    [2] = function()
        schema.create_table("todos", {
            { "id", types.serial },
            { "name", types.varchar({ length = 255 }) },
            { "description", types.text({ null = true }) },
            { "user_id", types.integer },

            "PRIMARY KEY (id)"
        })

        -- Add foreign key constraint
        db.query("ALTER TABLE todos ADD CONSTRAINT todos_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE")
    end
}
