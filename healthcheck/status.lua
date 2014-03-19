local hc = require "healthcheck"
ngx.say("Nginx Worker PID: ", ngx.worker.pid())
ngx.print(hc.status_page())
