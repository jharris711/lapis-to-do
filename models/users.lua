local Model = require("lapis.db.model").Model
local bcrypt = require("bcrypt")

local Users = Model:extend("users", {
  timestamp = true
})

return Users
