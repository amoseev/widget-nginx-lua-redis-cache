# Based on https://github.com/Ermlab/nginx-lua-proxy

FROM ubuntu:14.04

ENV VER_NGINX_DEVEL_KIT=0.2.19
ENV VER_LUA_NGINX_MODULE=0.9.16
ENV VER_NGINX=1.9.3
ENV VER_LUAJIT=2.0.4
ENV VER_LUA_CJSON_MODULE=2.1.0.3

ENV NGINX_DEVEL_KIT ngx_devel_kit-${VER_NGINX_DEVEL_KIT}
ENV LUA_NGINX_MODULE lua-nginx-module-${VER_LUA_NGINX_MODULE}
ENV NGINX_ROOT=/nginx
ENV WEB_DIR ${NGINX_ROOT}/html


#openresty modules
ENV VER_LUA_RESTY_REDIS=0.21
ENV LUA_RESTY_REDIS lua-resty-redis-${VER_LUA_RESTY_REDIS}



ENV LUAJIT_LIB /usr/local/lib
ENV LUAJIT_INC /usr/local/include/luajit-2.0

RUN apt-get -qq update
RUN apt-get -qq -y install wget supervisor
RUN apt-get -qq -y install redis-server

# Instal lighweight DNS for proper nginx name resolution based on /etc/hosts
RUN apt-get -qq -y install dnsmasq
#fix for dnsmasq in docker, it must run as user root:
RUN sed -i 's/#user=/user=root/g' /etc/dnsmasq.conf

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# ***** BUILD DEPENDENCIES *****

# Common dependencies (Nginx and LUAJit)
RUN apt-get -qq -y install make
# Nginx dependencies
RUN apt-get -qq -y install libpcre3
RUN apt-get -qq -y install libpcre3-dev
RUN apt-get -qq -y install zlib1g-dev
RUN apt-get -qq -y install libssl-dev
# LUAJit dependencies
RUN apt-get -qq -y install gcc
# Lua rocks for compile
RUN apt-get -qq -y install luarocks
#RUN apt-get -qq -y install lua-cjson

# ***** DOWNLOAD AND UNTAR *****

# Download modules
RUN wget http://nginx.org/download/nginx-${VER_NGINX}.tar.gz
RUN wget http://luajit.org/download/LuaJIT-${VER_LUAJIT}.tar.gz
RUN wget https://github.com/simpl/ngx_devel_kit/archive/v${VER_NGINX_DEVEL_KIT}.tar.gz -O ${NGINX_DEVEL_KIT}.tar.gz
RUN wget https://github.com/openresty/lua-nginx-module/archive/v${VER_LUA_NGINX_MODULE}.tar.gz -O ${LUA_NGINX_MODULE}.tar.gz

#Download openresty libs
RUN wget https://github.com/openresty/lua-resty-redis/archive/v${VER_LUA_RESTY_REDIS}.tar.gz -O ${LUA_RESTY_REDIS}.tar.gz
RUN wget https://codeload.github.com/openresty/lua-cjson/tar.gz/${VER_LUA_CJSON_MODULE} -O lua-cjson-${VER_LUA_CJSON_MODULE}.tar.gz

# Untar
RUN tar -xzvf nginx-${VER_NGINX}.tar.gz && rm nginx-${VER_NGINX}.tar.gz
RUN tar -xzvf LuaJIT-${VER_LUAJIT}.tar.gz && rm LuaJIT-${VER_LUAJIT}.tar.gz
RUN tar -xzvf ${NGINX_DEVEL_KIT}.tar.gz && rm ${NGINX_DEVEL_KIT}.tar.gz
RUN tar -xzvf ${LUA_NGINX_MODULE}.tar.gz && rm ${LUA_NGINX_MODULE}.tar.gz

#Lua LIBS
RUN tar -xzvf ${LUA_RESTY_REDIS}.tar.gz && rm ${LUA_RESTY_REDIS}.tar.gz
RUN tar -xzvf lua-cjson-${VER_LUA_CJSON_MODULE}.tar.gz && rm lua-cjson-${VER_LUA_CJSON_MODULE}.tar.gz
RUN cd ./lua-cjson-${VER_LUA_CJSON_MODULE} && luarocks make && cd ..

# copy openresty libraries to LUAJIT_LIB
RUN cp -r ${LUA_RESTY_REDIS}/lib ${LUAJIT_LIB}/lua-libs
RUN cp -r lua-cjson-${VER_LUA_CJSON_MODULE}/lua ${LUAJIT_LIB}/lua-libs


# ***** BUILD FROM SOURCE *****

# LuaJIT
WORKDIR /LuaJIT-${VER_LUAJIT}
RUN make
RUN make install

# Nginx with LuaJIT
WORKDIR /nginx-${VER_NGINX}
RUN ./configure --prefix=${NGINX_ROOT} --with-ld-opt="-Wl,-rpath,${LUAJIT_LIB}" --add-module=/${NGINX_DEVEL_KIT} --add-module=/${LUA_NGINX_MODULE}
RUN make -j2
RUN make install
RUN ln -s ${NGINX_ROOT}/sbin/nginx /usr/local/sbin/nginx

# ***** MISC *****
WORKDIR ${WEB_DIR}
EXPOSE 80
EXPOSE 443
EXPOSE 6379

# ***** CLEANUP *****
RUN rm -rf /nginx-${VER_NGINX}
RUN rm -rf /LuaJIT-${VER_LUAJIT}
RUN rm -rf /${NGINX_DEVEL_KIT}
RUN rm -rf /${LUA_NGINX_MODULE}
# TODO: Uninstall build only dependencies?
# TODO: Remove env vars used only for build?

COPY conf/nginx /nginx/conf/
COPY conf/redis.conf /etc/redis/redis.conf
RUN mkdir -p /var/log/nginx
RUN mkdir -p /var/www/lua
COPY lua /var/www/lua

# Run nginx and dnsmasq under supervisor
CMD ["/usr/bin/supervisord"]
