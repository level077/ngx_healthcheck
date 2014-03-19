local hc = require "healthcheck"
local us = {"video_pool","stat_pool"}
for k,v in pairs(us) do
	local ok, err = hc.spawn_checker{
		shm = "healthcheck",  -- defined by "lua_shared_dict"
      		upstream = v, -- defined by "upstream"
      		type = "http",
    		http_req = 'GET /1.htm HTTP/1.0\r\nHost: foo.com\r\n\r\n',
        		-- raw HTTP request for checking

     		interval = 2000,  -- run the check cycle every 2 sec
    		timeout = 1000,   -- 1 sec is the timeout for network operations
    		fall = 3,  -- # of successive failures before turning a peer down
   		rise = 2,  -- # of successive successes before turning a peer up
    		valid_statuses = {200, 302},  -- a list valid HTTP status code
    		valid_response = "ok", -- response body
     		concurrency = 10,  -- concurrency level for test requests
	}
	if not ok then
    		ngx.log(ngx.ERR, "failed to spawn health checker: ", err)
     		return
	end
end
