local Flow = require("lapis.flow").Flow
local Model = require("lapis.db.model").Model
local respond_to = require("lapis.application").respond_to

local ToDos = Model:extend("todos")

local ToDosFlow = Flow:extend({
    expose_assigns = true,
    handle_get_all_todos = respond_to({
      GET = function(self)
        return { redirect_to = self:url_for("home") }
      end
    }),
    handle_get_todo = respond_to({
      GET = function(self)
        local id = self.params.id

        print("ID************", id)

        if not id or id == "" then
          return "No ID was given"
        end

        self.todo = ToDos:find(id)

        return { render = "todo", { id = id } }
      end,
    }),
    handle_create_todo = respond_to({
      GET = function(self)
        return { redirect_to = self:url_for("home") }
      end,
      POST = function(self)
        if not self.session.user_id then
          return { redirect_to = self:url_for("login") .. "?error=login_required" }
        end

        local id = self.params.id
        
        if id then
          return { redirect_to = self:url_for("home") }
        end
        
        local todo = self.params
        local name = todo['name']
        local description = todo['toDo']

        local success, err = ToDos:create({
          name = name,
          description = description,
          user_id = self.session.user_id
        })

        return { redirect_to = self:url_for("home") }
      end
    }),
    handle_edit_requests = respond_to({
      GET = function(self)
        local id = self.params.id

        self.todo = ToDos:find(id)

        return { render = "edit" }
      end,
      POST = function(self)
        local id = self.params.id
        local incoming_todo = self.params
        local name = incoming_todo['name']
        local description = incoming_todo['toDo']

        self.todo = ToDos:find(id)

        self.todo:update({
          name = name,
          description = description
        })

        return { render = "todo", { id = id }}
      end
    }),
    handle_delete_todo = function(self)
      local todo = ToDos:find(self.params.id)

      todo:delete()

      return { redirect_to = "/" }
    end
})

return ToDosFlow
