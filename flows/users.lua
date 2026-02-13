local Flow = require("lapis.flow").Flow
local respond_to = require("lapis.application").respond_to
local Users = require("models.users")
local bcrypt = require("bcrypt")

local UsersFlow = Flow:extend({
    expose_assigns = true,
    handle_signup = respond_to({
        GET = function(self)
            return { render = "users/signup" }
        end,
        POST = function(self)
            local params = self.params
            local first_name = params.first_name
            local last_name = params.last_name
            local email = params.email
            local password = params.password
            local confirmation = params.confirmation

            -- Validate all fields
            if not first_name or not last_name or not email or not password or not confirmation then
                return { status = 400, json = { error = "All fields required" } }
            end

            -- Check passwords match
            if password ~= confirmation then
                return { status = 400, json = { error = "Passwords do not match" } }
            end

            -- Validate password length
            if #password < 8 then
                return { status = 400, json = { error = "Password must be at least 8 characters" } }
            end

            -- Check if user exists
            local existing = Users:find_all({ email = email })
            if #existing > 0 then
                return { status = 400, json = { error = "User already exists" } }
            end

            -- Hash password before creating user
            local hashed_password = bcrypt.digest(password, 12)

            -- Create user (password gets hashed in before_create)
            local user = Users:create({
                first_name = first_name,
                last_name = last_name,
                email = email,
                password = hashed_password
            })

            self.session.user_id = user.id

            return { redirect_to = self:url_for("home") }
        end
    }),
    handle_login = respond_to({
        GET = function(self)
            return { render = "users/login" }
        end,
        POST = function(self)
            local params = self.params
            local email = params.email
            local password = params.password

            -- Validate fields
            if not email or not password then
                return { status = 400, json = { error = "Email and password required" } }
            end

            -- Find user by email
            local user = Users:find({ email = email })

            -- Check if user exists and password is correct
            if not user then
                return { status = 401, json = { error = "Invalid email or password" } }
            end

            if not bcrypt.verify(password, user.password) then
                return { status = 401, json = { error = "Invalid email or password" } }
            end

            -- Set session
            self.session.user_id = user.id

            return { redirect_to = self:url_for("home") }
        end
    }),
    handle_signout = function(self)
        -- Clear session data
        self.session = {}

        -- Get the session cookie name (default is "lapis_session")
        local cookie_name = self.session_name or "lapis_session"

        -- Delete the cookie by setting it to expire in the past
        self.cookies[cookie_name] = ""
        self.res.headers["Set-Cookie"] = cookie_name .. "=; Path=/; Expires=Thu, 01 Jan 1970 00:00:00 GMT"

        return { redirect_to = self:url_for("home") }
    end,
    handle_account = function(self)
        local requested_user_id = tonumber(self.params.id)

        -- Check if logged in
        if not self.session.user_id then
            return { redirect_to = self:url_for("login") }
        end

        -- Check if trying to access someone else's account
        if self.session.user_id ~= requested_user_id then
            return { redirect_to = self:url_for("account", { id = self.session.user_id }) }
        end

        self.user = Users:find(requested_user_id)

        return { render = "users/account" }
    end,
    handle_edit_account = respond_to({
        GET = function(self)
            self.user = Users:find(self.session.user_id)

            return { render = "users/edit" }
        end,
        POST = function(self)
            local user = Users:find(self.session.user_id)

            if not user then
                return { status = 404, json = { error = "User not found" } }
            end

            local params = self.params
            local first_name = params.first_name
            local last_name = params.last_name
            local email = params.email
            local password = params.password
            local confirmation = params.confirmation

            -- Validate required fields
            if not first_name or not last_name or not email then
                return { status = 400, json = { error = "First name, last name, and email are required" } }
            end

            -- If email is being changed, check if it's already taken
            if email ~= user.email then
                local existing = Users:find({ email = email })
                if existing then
                    return { status = 400, json = { error = "Email already in use" } }
                end
            end

            -- Prepare update data
            local update_data = {
                first_name = first_name,
                last_name = last_name,
                email = email
            }

            -- Handle password update (optional)
            if password and password ~= "" then
                -- Validate password confirmation
                if not confirmation or password ~= confirmation then
                    return { status = 400, json = { error = "Passwords do not match" } }
                end

                -- Validate password length
                if #password < 8 then
                    return { status = 400, json = { error = "Password must be at least 8 characters" } }
                end

                -- Hash the new password
                update_data.password = bcrypt.digest(password, 12)
            end

            -- Update the user
            user:update(update_data)

            return { redirect_to = self:url_for("account", { id = user.id }) }
        end
    })
})

return UsersFlow