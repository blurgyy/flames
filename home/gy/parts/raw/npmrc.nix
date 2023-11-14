{ proxy, hostName }:

''
proxy=${(proxy.envVarsFor hostName).http.http_proxy}
https-proxy=${(proxy.envVarsFor hostName).http.http_proxy}
''
