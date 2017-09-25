local CONFIG_REDIS_HOST = "127.0.0.1"
local CONFIG_REDIS_PORT = 6379

local function failRedisFetch()
    ngx.status = 404
    ngx.print("Not nound")
    ngx.exit();
end

local function getLanguage()
    local headers = ngx.req.get_headers()
    for header, value in pairs(headers) do
        if (header == 'accept-language') then
            if (value:len() == 5) then
                return value
            end
            if (value:find("ru%-RU") ~= nil) then
                return "ru-RU"
            end
        end
    end

    return 'en-US'
end



local function tryConvertToResponseFromRedis(responseObjJsonString)
    if responseObjJsonString == nil then
        failRedisFetch();
    end

    local cjson = require('cjson')
    local responseParams = cjson.decode(responseObjJsonString)
    -- local responseParams, err = cjson.decode('{"body": "{\"success\":true,\"data\":[{\"id\":1,\"title\":\"\\u0420\\u043e\\u0441\\u0441\\u0438\\u044f\",\"full_title\":\"\\u0420\\u043e\\u0441\\u0441\\u0438\\u0439\\u0441\\u043a\\u0430\\u044f \\u0424\\u0435\\u0434\\u0435\\u0440\\u0430\\u0446\\u0438\\u044f\",\"phone_code\":\"7\",\"phone_template\":\"+7 xxx xxx-xx-xx\",\"phone_example\":\"+7 981 123 45-67\",\"currency\":\"\\u20bd\",\"exchange\":1},{\"id\":2,\"title\":\"\\u041b\\u0430\\u0442\\u0432\\u0438\\u044f\",\"full_title\":\"\\u041b\\u0430\\u0442\\u0432\\u0438\\u0439\\u0441\\u043a\\u0430\\u044f \\u0420\\u0435\\u0441\\u043f\\u0443\\u0431\\u043b\\u0438\\u043a\\u0430\",\"phone_code\":\"371\",\"phone_template\":\"+371 xx xxx xxx\",\"phone_example\":\"+371 21 654 987\",\"currency\":\"\\u20ac\",\"exchange\":50},{\"id\":3,\"title\":\"\\u0411\\u0435\\u043b\\u0430\\u0440\\u0443\\u0441\\u044c\",\"full_title\":\"\\u0420\\u0435\\u0441\\u043f\\u0443\\u0431\\u043b\\u0438\\u043a\\u0430 \\u0411\\u0435\\u043b\\u0430\\u0440\\u0443\\u0441\\u044c\",\"phone_code\":\"375\",\"phone_template\":\"+375 xx xxx-xx-xx\",\"phone_example\":\"+375 21 654-98-71\",\"currency\":\"Br\",\"exchange\":35},{\"id\":4,\"title\":\"\\u0423\\u043a\\u0440\\u0430\\u0438\\u043d\\u0430\",\"full_title\":\"\\u0423\\u043a\\u0440\\u0430\\u0438\\u043d\\u0430\",\"phone_code\":\"380\",\"phone_template\":\"+380 xx xxx-xx-xx\",\"phone_example\":\"+380 44 065-49-87\",\"currency\":\"\\u20b4\",\"exchange\":4},{\"id\":5,\"title\":\"\\u042d\\u0441\\u0442\\u043e\\u043d\\u0438\\u044f\",\"full_title\":\"\\u042d\\u0441\\u0442\\u043e\\u043d\\u0441\\u043a\\u0430\\u044f \\u0420\\u0435\\u0441\\u043f\\u0443\\u0431\\u043b\\u0438\\u043a\\u0430\",\"phone_code\":\"372\",\"phone_template\":\"+372 xxxxxxxx\",\"phone_example\":\"+372 12345678\",\"currency\":\"\\u20ac\",\"exchange\":80},{\"id\":6,\"title\":\"\\u041b\\u0438\\u0442\\u0432\\u0430\",\"full_title\":\"\\u041b\\u0438\\u0442\\u043e\\u0432\\u0441\\u043a\\u0430\\u044f \\u0420\\u0435\\u0441\\u043f\\u0443\\u0431\\u043b\\u0438\\u043a\\u0430\",\"phone_code\":\"370\",\"phone_template\":\"+370 xxxxxxxx\",\"phone_example\":\"+370 12345678\",\"currency\":\"\\u20ac\",\"exchange\":74},{\"id\":7,\"title\":\"USA\",\"full_title\":\"United States\",\"phone_code\":\"1\",\"phone_template\":\"+1 xxx xxx-xx-xx\",\"phone_example\":\"+1 201 123-45-67\",\"currency\":\"$\",\"exchange\":32.985},{\"id\":8,\"title\":\"\\u041a\\u0430\\u0437\\u0430\\u0445\\u0441\\u0442\\u0430\\u043d\",\"full_title\":\"\\u0420\\u0435\\u0441\\u043f\\u0443\\u0431\\u043b\\u0438\\u043a\\u0430 \\u041a\\u0430\\u0437\\u0430\\u0445\\u0441\\u0442\\u0430\\u043d\",\"phone_code\":\"7\",\"phone_template\":\"+7 xxx xxx-xx-xx\",\"phone_example\":\"+7 701 777-84-64\",\"currency\":\"\\u20b8\",\"exchange\":0.2},{\"id\":9,\"title\":\"UAE\",\"full_title\":\"United Arab Emirates \",\"phone_code\":\"971\",\"phone_template\":\"+971 xx xxx xxxx\",\"phone_example\":\"+971 55 538 7943\",\"currency\":\"AED\",\"exchange\":15.6},{\"id\":10,\"title\":\"\\u0413\\u0440\\u0443\\u0437\\u0438\\u044f\",\"full_title\":\"\\u0413\\u0440\\u0443\\u0437\\u0438\\u044f\",\"phone_code\":\"995\",\"phone_template\":\"+995 xx xxx-xx-xx\",\"phone_example\":\"+995 12 345-67-89\",\"currency\":\"\\u20be\",\"exchange\":19},{\"id\":11,\"title\":\"\\u041a\\u0438\\u0440\\u0433\\u0438\\u0437\\u0438\\u044f\",\"full_title\":\"\\u0420\\u0435\\u0441\\u043f\\u0443\\u0431\\u043b\\u0438\\u043a\\u0430 \\u041a\\u044b\\u0440\\u0433\\u044b\\u0437\\u0441\\u0442\\u0430\\u043d\",\"phone_code\":\"996\",\"phone_template\":\"+996 xxx xx-xx-xx\",\"phone_example\":\"+996 123 45-67-89\",\"currency\":\"\\u0441\\u043e\\u043c\",\"exchange\":0.78},{\"id\":12,\"title\":\"\\u041f\\u043e\\u043b\\u044c\\u0448\\u0430\",\"full_title\":\"\\u041f\\u043e\\u043b\\u044c\\u0448\\u0430\",\"phone_code\":\"48\",\"phone_template\":\"+48 xxx-xxx-xxx\",\"phone_example\":\"48 981-234-123\",\"currency\":\"\\u20ac\",\"exchange\":45},{\"id\":13,\"title\":\"\\u0427\\u0435\\u0445\\u0438\\u044f\",\"full_title\":\"\\u0427\\u0435\\u0445\\u0438\\u044f\",\"phone_code\":\"420\",\"phone_template\":\"+420 xxx-xxx-xxx\",\"phone_example\":\"+420 777-777-777\",\"currency\":\"K\\u010d\",\"exchange\":2.6},{\"id\":14,\"title\":\"\\u0422\\u0430\\u0434\\u0436\\u0438\\u043a\\u0438\\u0441\\u0442\\u0430\\u043d\",\"full_title\":\"\\u0420\\u0435\\u0441\\u043f\\u0443\\u0431\\u043b\\u0438\\u043a\\u0430 \\u0422a\\u0434\\u0436\\u0438\\u043a\\u0438\\u0441\\u0442\\u0430\\u043d\",\"phone_code\":\"992\",\"phone_template\":\"+992 xxx xx-xx-xx\",\"phone_example\":\"+992 372 12-34-56\",\"currency\":\"\\u0441.\",\"exchange\":12.8},{\"id\":15,\"title\":\"\\u041c\\u043e\\u043d\\u0430\\u043a\\u043e\",\"full_title\":\"\\u041c\\u043e\\u043d\\u0430\\u043a\\u043e\",\"phone_code\":\"33\",\"phone_template\":\"+33 xxx xxx xxx\",\"phone_example\":\"+33 123 456 789\",\"currency\":\"\\u20ac\",\"exchange\":65},{\"id\":16,\"title\":\"\\u0410\\u0437\\u0435\\u0440\\u0431\\u0430\\u0439\\u0434\\u0436\\u0430\\u043d\",\"full_title\":\"\\u0410\\u0437\\u0435\\u0440\\u0431\\u0430\\u0439\\u0434\\u0436\\u0430\\u043d\",\"phone_code\":\"994\",\"phone_template\":\"+994 xx xxxxxxx\",\"phone_example\":\"+994 12 3456789\",\"currency\":\"\\u20bc\",\"exchange\":62.268},{\"id\":17,\"title\":\"\\u0411\\u043e\\u043b\\u0433\\u0430\\u0440\\u0438\\u044f\",\"full_title\":\"\\u0411\\u043e\\u043b\\u0433\\u0430\\u0440\\u0438\\u044f\",\"phone_code\":\"359\",\"phone_template\":\"+359 xx xxx xxxx\",\"phone_example\":\"+359 12 345 6789\",\"currency\":\"\\u043b\\u0432\",\"exchange\":32},{\"id\":18,\"title\":\"\\u041d\\u043e\\u0440\\u0432\\u0435\\u0433\\u0438\\u044f\",\"full_title\":\"\\u041d\\u043e\\u0440\\u0432\\u0435\\u0433\\u0438\\u044f\",\"phone_code\":\"47\",\"phone_template\":\"+47 xx-xx-xx-xx\",\"phone_example\":\"+47 77-77-77-77\",\"currency\":\"kr\",\"exchange\":6.6},{\"id\":19,\"title\":\"\\u041c\\u043e\\u043b\\u0434\\u043e\\u0432\\u0430\",\"full_title\":\"\\u041c\\u043e\\u043b\\u0434\\u043e\\u0432\\u0430\",\"phone_code\":\"373\",\"phone_template\":\"+373 xxx xxx-xx\",\"phone_example\":\"+373 791 116-76\",\"currency\":\"L\",\"exchange\":0.31},{\"id\":20,\"title\":\"\\u0424\\u0438\\u043d\\u043b\\u044f\\u043d\\u0434\\u0438\\u044f\",\"full_title\":\"\\u0424\\u0438\\u043d\\u043b\\u044f\\u043d\\u0434\\u0438\\u044f\",\"phone_code\":\"358\",\"phone_template\":\"+358 xxxxxxxx\",\"phone_example\":\"+358 12345678\",\"currency\":\"\\u20ac\",\"exchange\":80},{\"id\":21,\"title\":\"\\u0410\\u0440\\u043c\\u0435\\u043d\\u0438\\u044f\",\"full_title\":\"\\u0410\\u0440\\u043c\\u0435\\u043d\\u0438\\u044f\",\"phone_code\":\"374\",\"phone_template\":\"+374 xx xx-xx-xx\",\"phone_example\":\"+374 12 34-56-78\",\"currency\":\"\\u0564\\u0580\",\"exchange\":0.12},{\"id\":22,\"title\":\"\\u0418\\u0441\\u043f\\u0430\\u043d\\u0438\\u044f\",\"full_title\":\"\\u0418\\u0441\\u043f\\u0430\\u043d\\u0438\\u044f\",\"phone_code\":\"34\",\"phone_template\":\"+34 xx xxx xx xx\",\"phone_example\":\"+34 (93) 319 30 33\",\"currency\":\"\\u20ac\",\"exchange\":75},{\"id\":23,\"title\":\"\\u0413\\u0435\\u0440\\u043c\\u0430\\u043d\\u0438\\u044f\",\"full_title\":\"\\u0413\\u0435\\u0440\\u043c\\u0430\\u043d\\u0438\\u044f\",\"phone_code\":\"49\",\"phone_template\":\"+49 xxxx xx-xx-xxx\",\"phone_example\":\"+49 0721 16-10-100\",\"currency\":\"\\u20ac\",\"exchange\":69},{\"id\":24,\"title\":\"\\u0423\\u0437\\u0431\\u0435\\u043a\\u0438\\u0441\\u0442\\u0430\\u043d\",\"full_title\":\"\\u0423\\u0437\\u0431\\u0435\\u043a\\u0438\\u0441\\u0442\\u0430\\u043d\",\"phone_code\":\"998\",\"phone_template\":\"+998 xxx xx-xx-xx\",\"phone_example\":\"+998 123 45-67-89\",\"currency\":\"so\\u2019m\",\"exchange\":40},{\"id\":25,\"title\":\"\\u0422\\u0443\\u0440\\u0446\\u0438\\u044f\",\"full_title\":\"\\u0422\\u0443\\u0440\\u0435\\u0446\\u043a\\u0430\\u044f \\u0420\\u0435\\u0441\\u043f\\u0443\\u0431\\u043b\\u0438\\u043a\\u0430\",\"phone_code\":\"90\",\"phone_template\":\" +90 xxx xxx-xx-xx\",\"phone_example\":\"+90 111 222-33-44\",\"currency\":\"\\u20ba\",\"exchange\":25},{\"id\":26,\"title\":\"\\u0412\\u0435\\u043b\\u0438\\u043a\\u043e\\u0431\\u0440\\u0438\\u0442\\u0430\\u043d\\u0438\\u044f\",\"full_title\":\"\\u0412\\u0435\\u043b\\u0438\\u043a\\u043e\\u0431\\u0440\\u0438\\u0442\\u0430\\u043d\\u0438\\u044f\",\"phone_code\":\"44\",\"phone_template\":\"+44 xxx xxx-xx-xx\",\"phone_example\":\"+44 777 777-77-77\",\"currency\":\"\\u00a3\",\"exchange\":95},{\"id\":27,\"title\":\"\\u0414\\u0430\\u043d\\u0438\\u044f\",\"full_title\":\"\\u0414\\u0430\\u043d\\u0438\\u044f\",\"phone_code\":\"45\",\"phone_template\":\"+45 xx-xx-xx-xx\",\"phone_example\":\"+45 93 88 35 55\",\"currency\":\"DKK\",\"exchange\":9.1},{\"id\":28,\"title\":\"\\u0415\\u0433\\u0438\\u043f\\u0435\\u0442\",\"full_title\":\"\\u0415\\u0433\\u0438\\u043f\\u0435\\u0442\",\"phone_code\":\"20\",\"phone_template\":\"+20 xxxxxxx\",\"phone_example\":\"+20 8007460\",\"currency\":\"EGP\",\"exchange\":7},{\"id\":29,\"title\":\"\\u0425\\u043e\\u0440\\u0432\\u0430\\u0442\\u0438\\u044f\",\"full_title\":\"\\u0425\\u043e\\u0440\\u0432\\u0430\\u0442\\u0438\\u044f\",\"phone_code\":\"385\",\"phone_template\":\"+385 x xxxx xxx\",\"phone_example\":\"+385 1 3755 000\",\"currency\":\"HRK\",\"exchange\":8.37},{\"id\":30,\"title\":\"\\u0418\\u0440\\u043b\\u0430\\u043d\\u0434\\u0438\\u044f\",\"full_title\":\"\\u0418\\u0440\\u043b\\u0430\\u043d\\u0434\\u0438\\u044f\",\"phone_code\":\"353\",\"phone_template\":\"+353 xx xxx xxx\",\"phone_example\":\"+353 12 345 678\",\"currency\":\"\\u20ac\",\"exchange\":63},{\"id\":31,\"title\":\"\\u0412\\u0435\\u043d\\u0433\\u0440\\u0438\\u044f\",\"full_title\":\"\\u0412\\u0435\\u043d\\u0433\\u0440\\u0438\\u044f\",\"phone_code\":\"36\",\"phone_template\":\"+36 xx xxx xx\",\"phone_example\":\"+36 3244734\",\"currency\":\"HUF\",\"exchange\":0.2},{\"id\":32,\"title\":\"\\u0418\\u0442\\u0430\\u043b\\u0438\\u044f\",\"full_title\":\"\\u0418\\u0442\\u0430\\u043b\\u0438\\u044f\",\"phone_code\":\"39\",\"phone_template\":\"+39 xxxxxxxxxx\",\"phone_example\":\"+39 0283545254\",\"currency\":\"\\u20ac\",\"exchange\":69},{\"id\":33,\"title\":\"\\u0418\\u0437\\u0440\\u0430\\u0438\\u043b\\u044c\",\"full_title\":\"\\u0418\\u0437\\u0440\\u0430\\u0438\\u043b\\u044c\",\"phone_code\":\"972\",\"phone_template\":\"+972 xx xxx xxxx\",\"phone_example\":\"+972 54 284 7787\",\"currency\":\"\\u20aa\",\"exchange\":15.7},{\"id\":34,\"title\":\"\\u0410\\u0432\\u0441\\u0442\\u0440\\u0438\\u044f\",\"full_title\":\"\\u0410\\u0432\\u0441\\u0442\\u0440\\u0438\\u0439\\u0441\\u043a\\u0430\\u044f \\u0420\\u0435\\u0441\\u043f\\u0443\\u0431\\u043b\\u0438\\u043a\\u0430\",\"phone_code\":\"43\",\"phone_template\":\"+43 xxx xxxxxxx\",\"phone_example\":\"+43 676 6738104\",\"currency\":\"\\u20ac\",\"exchange\":60},{\"id\":35,\"title\":\"\\u0420\\u0435\\u0441\\u043f\\u0443\\u0431\\u043b\\u0438\\u043a\\u0430 \\u041a\\u0438\\u043f\\u0440\",\"full_title\":\"\\u0420\\u0435\\u0441\\u043f\\u0443\\u0431\\u043b\\u0438\\u043a\\u0430 \\u041a\\u0438\\u043f\\u0440\",\"phone_code\":\"357\",\"phone_template\":\"+357 xx xxx xxx\",\"phone_example\":\"+357 12 345 678\",\"currency\":\"\\u20ac\",\"exchange\":60},{\"id\":36,\"title\":\"\\u0410\\u0431\\u0445\\u0430\\u0437\\u0438\\u044f\",\"full_title\":\"\\u0420\\u0435\\u0441\\u043f\\u0443\\u0431\\u043b\\u0438\\u043a\\u0430 \\u0410\\u0431\\u0445\\u0430\\u0437\\u0438\\u044f\",\"phone_code\":\"7\",\"phone_template\":\"+7 xxx xxx-xx-xx\",\"phone_example\":\"+7 940 123 45-67\",\"currency\":\"\\u20bd\",\"exchange\":1},{\"id\":37,\"title\":\"\\u0427\\u0435\\u0440\\u043d\\u043e\\u0433\\u043e\\u0440\\u0438\\u044f\",\"full_title\":\"\\u0420\\u0435\\u0441\\u043f\\u0443\\u0431\\u043b\\u0438\\u043a\\u0430 \\u0427\\u0435\\u0440\\u043d\\u043e\\u0433\\u043e\\u0440\\u0438\\u044f\",\"phone_code\":\"382\",\"phone_template\":\"+382 xxx xxx xxx\",\"phone_example\":\"+382 123 456 789\",\"currency\":\"\\u20ac\",\"exchange\":60},{\"id\":38,\"title\":\"\\u0420\\u0443\\u043c\\u044b\\u043d\\u0438\\u044f\",\"full_title\":\"\\u0420\\u0443\\u043c\\u044b\\u043d\\u0438\\u044f\",\"phone_code\":\"4\",\"phone_template\":\"+4 xxx xxx-xx-xx\",\"phone_example\":\"+4 076 630-31-17\",\"currency\":\"RON\",\"exchange\":14},{\"id\":39,\"title\":\"\\u041a\\u0430\\u0442\\u0430\\u0440\",\"full_title\":\"\\u0413\\u043e\\u0441\\u0443\\u0434\\u0430\\u0440\\u0441\\u0442\\u0432\\u043e \\u041a\\u0430\\u0442\\u0430\\u0440\",\"phone_code\":\"974\",\"phone_template\":\"+974 xxxx xxxx\",\"phone_example\":\"+974 3154 1378\",\"currency\":\"QAR\",\"exchange\":16.39},{\"id\":40,\"title\":\"\\u041a\\u0438\\u0442\\u0430\\u0439\",\"full_title\":\"\\u041a\\u0438\\u0442\\u0430\\u0439\",\"phone_code\":\"86\",\"phone_template\":\"+86 xxx xxx-xx-xx\",\"phone_example\":\"+86 123 456-78-01\",\"currency\":\"CNY\",\"exchange\":0.13},{\"id\":41,\"title\":\"\\u0413\\u043e\\u043d\\u043a\\u043e\\u043d\\u0433\",\"full_title\":\"\\u0413\\u043e\\u043d\\u043a\\u043e\\u043d\\u0433\",\"phone_code\":\"852\",\"phone_template\":\"+852 xx xxx xx xx\",\"phone_example\":\"+852 23 456 78 90\",\"currency\":\"CNY\",\"exchange\":0.13},{\"id\":42,\"title\":\"\\u0428\\u0432\\u0435\\u0439\\u0446\\u0430\\u0440\\u0438\\u044f\",\"full_title\":\"\\u0428\\u0432\\u0435\\u0439\\u0446\\u0430\\u0440\\u0441\\u043a\\u0430\\u044f \\u041a\\u043e\\u043d\\u0444\\u0435\\u0434\\u0435\\u0440\\u0430\\u0446\\u0438\\u044f\",\"phone_code\":\"41\",\"phone_template\":\"+41 xxx-xx-xx-xx\",\"phone_example\":\"+41 799-64-27-84\",\"currency\":\"\\u20a3\",\"exchange\":6.25}],\"meta\":{\"count\":42}}", "status": 200,  "headers": {    "Access-Control-Allow-Origin": [      "*"    ],    "Access-Control-Allow-Methods": [      "GET, POST, PUT, DELETE, OPTIONS"    ],    "Access-Control-Allow-Headers": [      "X-Requested-With, Authorization, Content-Type"    ],    "Access-Control-Expose-Headers": [      "X-User_token, User_token"    ],    "P3P": [      "CP=\"ALL ADM DEV PSAi COM OUR OTRo STP IND ONL\""    ],    "content-type": [      "application/json"    ]  }}')
    -- local responseParams, err = cjson.decode('{"body": "435","status": 200, "headers": {"Access-Control-Allow-Origin": [ "*" ], "content-type": [ "application/json" , "application/text"]}}'   )

    if (responseParams['status'] and responseParams['headers'] and responseParams['body'] ) then
        ngx.status = responseParams['status']

        local headerValue
        for name, values in pairs(responseParams['headers']) do
            headerValue = ''
            for i, value in pairs(values) do
                if i > 1 then
                    headerValue = headerValue .. '; '
                end
                headerValue = headerValue .. value
            end
            ngx.header[name] = headerValue
        end

        ngx.print(responseParams['body'])

    else
        failRedisFetch()
    end
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


-- Connect to Redis
local redis = require "resty.redis"
local red = redis:new()
red:set_timeout(1000)

-- todo config (лучше хост редиса определить site.cache.redis.com. и по нему ходить. порт хз
local ok, err = red:connect(CONFIG_REDIS_HOST, CONFIG_REDIS_PORT)
if not ok then
    ngx.log(ngx.STDERR, "Failed to connect to Redis: " .. err)
    failRedisFetch()
end


local redisKey = 'path_' .. ngx.var.request_uri .. '_lang_'.. getLanguage()


local result, err = red:get(redisKey)
ngx.header['search_key'] = redisKey
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
