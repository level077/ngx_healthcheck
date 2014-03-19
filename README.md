nginx健康检查模块：https://github.com/agentzh/lua-resty-upstream-healthcheck
在此添加了检查返回内容的功能，nginx.conf配置片段如下：
<pre><code>
lua_code_cache on;
lua_package_path '/usr/local/app/nginx/html/lib/?.lua;;';
lua_shared_dict healthcheck 1m;
init_worker_by_lua_file '/usr/local/app/nginx/html/healthcheck/healthcheck.lua';
upstream video_pool {
	server 192.168.0.144:8110;
     	server 192.168.0.144:8111;
      	server 192.168.0.144:8112;
    	keepalive 16;
}
upstream stat_pool {
     	server 192.168.0.144:8113;
     	server 192.168.0.145:8113;
   	keepalive 8;
}
server {
      	listen 80;
    	server_name upstream.kascend.com;
    	default_type text/plain;
     	location /upstreams {
     		content_by_lua_file '/usr/local/app/nginx/html/healthcheck/upstreams.lua';
      	}
    	location /status {
          	content_by_lua_file '/usr/local/app/nginx/html/healthcheck/status.lua';
    	}
}
