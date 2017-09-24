local CONFIG_REDIS_HOST = "127.0.0.1"
local CONFIG_REDIS_PORT = 6379

local function failRedisFetch()
    ngx.status = 404
    ngx.print("Not nound")
    ngx.exit();
end

local function tryConvertToResponseFromRedis(responseRows)
    if responseRows == nil then
        failRedisFetch();
    end

    --local cjson = require('cjson')
    --local return_data, err = cjson.decode(responseRows)
    --ngx.status = 200
    ngx.say('from redis:')
    ngx.say(responseRows)
    --if (responseRows) then
    --
    --end
end

if (ngx.var.request_method == 'OPTION') then
    ngx.status = 200
    ngx.print("TODO headers")
    ngx.exit();
end

if (ngx.var.request_method ~= 'GET') then
    ngx.status = 403
    ngx.print("Not implemented")
    ngx.exit();
end

ngx.header["Content-Type"] = "text/plain";
ngx.status = 200

-- Connect to Redis
local redis = require "resty.redis"
local red = redis:new()
red:set_timeout(1000)

-- todo config (лучше хост редиса определить yclients.cache.redis.com. и по нему ходить. порт хз
local ok, err = red:connect(CONFIG_REDIS_HOST, CONFIG_REDIS_PORT)
if not ok then
    ngx.log(ngx.STDERR, "Failed to connect to Redis: " .. err)
    failRedisFetch()
end

local result, err = red:get("cat")
if not result then
    ngx.log(ngx.STDERR, "Failed get from Redis: " .. err)
    failRedisFetch()
end

tryConvertToResponseFromRedis(result)

-- put it into the connection pool of size 100,
-- with 10 seconds max idle time
local ok, err = red:set_keepalive(10000, 100)
if not ok then
    ngx.log(ngx.STDERR, "failed to set keepalive: ", err)
    failRedisFetch()
end