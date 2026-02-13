local Flow = require("lapis.flow").Flow
local Model = require("lapis.db.model").Model
local json = require("cjson")

local ToDos = Model:extend("todos")

local HomePageFlow = Flow:extend({
    expose_assigns = true,
    render_home_page = function(self)
        self.todos = ToDos:find_all({self.session.user_id}, {
            key = "user_id"
        })

        return { render = "home" }
    end
})

return HomePageFlow
