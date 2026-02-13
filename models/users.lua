local Model = require("lapis.db.model").Model

local Users, Users_mt = Model:extend("users", {
  timestamp = true
})

function Users_mt:get_display_name()
  local display_name = self.first_name .. self.last_name
  return display_name
end

return Users
