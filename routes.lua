
local capture_errors = require("lapis.application").capture_errors
local respond_to = require("lapis.application").respond_to
local Model = require("lapis.db.model").Model

local ToDos = Model:extend("todos")

return function(app)
  app:match("home", "/", capture_errors(function(self)
    return self:flow("home"):render_home_page()
  end))
  app:post("/to-dos", capture_errors(function(self)
    return self:flow("toDos"):handle_create_todo()
  end))
  app:get("/to-dos/:id", capture_errors(function(self)
    return self:flow("toDos"):handle_get_todo()
  end))
  app:match("edit", "/to-dos/:id/edit", capture_errors(function(self)
    return self:flow("toDos"):handle_edit_requests()
  end))
end