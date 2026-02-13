local Flow = require("lapis.flow").Flow
local ToDos = require("models.todos")
local Users = require("models.users")

local HomePageFlow = Flow:extend({
    expose_assigns = true,
    render_home_page = function(self)
        self.todos = ToDos:find_all({self.session.user_id}, {
            key = "user_id"
        })
        if self.session.user_id then
            self.user = Users:find(self.session.user_id)
        end

        return { render = "home" }
    end
})

return HomePageFlow
