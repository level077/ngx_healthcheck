local concat = table.concat
local upstream = require "ngx.upstream"
local get_servers = upstream.get_servers
local get_upstreams = upstream.get_upstreams

local us = get_upstreams()
for _, u in ipairs(us) do
	ngx.say("upstream ", u, ":")
   	local srvs, err = get_servers(u)
   	if not srvs then
       		ngx.say("failed to get servers in upstream ", u)
     	else
        	for _, srv in ipairs(srvs) do
                	local first = true
                      	for k, v in pairs(srv) do
                        	if first then
                                    first = false
                                    ngx.print("    ")
                                else
                                    ngx.print(", ")
                                end
                                if type(v) == "table" then
                                    ngx.print(k, " = {", concat(v, ", "), "}")
                                else
                                    ngx.print(k, " = ", v)
                                end
                   	end
                      	ngx.print("\r\n")
           	end
    	end
end
