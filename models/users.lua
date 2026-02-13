local Model = require("lapis.db.model").Model

local Users = Model:extend("users", {
  timestamp = true
})

return Users
