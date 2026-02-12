local Flow = require("lapis.flow").Flow
local Model = require("lapis.db.model").Model

local ToDos = Model:extend("todos")

local HomePageFlow = Flow:extend({
    expose_assigns = true,
    render_home_page = function(self)
        local todos = ToDos:select("*")

        self.todos = todos

        return { render = "home" }
    end
})

return HomePageFlow
