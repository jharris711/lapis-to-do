local config = require("lapis.config")

config("development", {
  server = "nginx",
  code_cache = "off",
  num_workers = "1",
  postgres = {
    host = "127.0.0.1",
    user = "postgres",
    password = "password",
    database = "postgres"
  }
});

config("docker", {
  server = "nginx",
  code_cache = "on",
  num_workers = "2",
  port = "8080",
  postgres = {
    host = "db",  -- Docker service name
    user = "postgres",
    password = "password",
    database = "lapis_todo"
  }
});

config("production", {
  server = "nginx",
  code_cache = "on",
  num_workers = "4",
  port = "8080",
  postgres = {
    host = os.getenv("DB_HOST") or "localhost",
    user = os.getenv("DB_USER") or "postgres",
    password = os.getenv("DB_PASSWORD") or "password",
    database = os.getenv("DB_NAME") or "lapis_todo"
  }
});
