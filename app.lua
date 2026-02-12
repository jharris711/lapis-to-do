local lapis = require("lapis")
local app = lapis.Application()

app:enable("etlua")

app.layout = require "views.layout"

require("routes")(app)

return app
