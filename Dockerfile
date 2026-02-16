FROM openresty/openresty:alpine

# Install build dependencies and luarocks
RUN apk add --update --no-cache \
    postgresql-dev \
    gcc \
    make \
    musl-dev \
    git \
    wget \
    luarocks5.1

# Configure luarocks to use OpenResty's LuaJIT headers
# OpenResty includes LuaJIT, and the headers are in a different location than standard Lua
RUN luarocks-5.1 config variables.LUA_INCDIR /usr/local/openresty/luajit/include/luajit-2.1
RUN luarocks-5.1 config variables.LUA_LIBDIR /usr/local/openresty/luajit/lib

# Install lapis and dependencies
RUN luarocks-5.1 install lapis
RUN luarocks-5.1 install pgmoon
RUN luarocks-5.1 install bcrypt
RUN luarocks-5.1 install luabitop

# Create app directory
WORKDIR /app

# Copy your Lua scripts into the container
COPY . .

# Create necessary directories
RUN mkdir -p logs static

# Expose port
EXPOSE 8080

# Set environment to docker
ENV LAPIS_ENVIRONMENT=docker

# Start lapis
CMD ["lapis", "server", "docker"]
