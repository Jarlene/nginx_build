
path=$1

if [ ! -n "$path" ] ;then
     echo "please input nginx install path"
     exit
fi
git submodule update --init --recursive

cp -r ./nginx/lua ${path}/nginx/lua

wget http://luajit.org/download/LuaJIT-2.0.5.tar.gz -O LuaJIT.tar.gz
tar zxf LuaJIT.tar.gz

cd LuaJIT-2.0.5
make PREFIX=${path}/nginx/luajit
make install PREFIX=${path}/nginx/luajit
cd ..

export LUAJIT_LIB=${path}/nginx/luajit/lib
export LUAJIT_INC=${path}/nginx/luajit/include//luajit-2.0/

wget https://ftp.pcre.org/pub/pcre/pcre-8.00.tar.bz2 -O pcre.tar.bz2
tar -xvf pcre.tar.bz2

wget https://bitbucket.org/nginx-goodies/nginx-sticky-module-ng/get/master.tar.gz -O nginx-sticky-module.tar.gz
tar -zxvf nginx-sticky-module.tar.gz

wget https://www.openssl.org/source/openssl-1.1.1-pre1.tar.gz -O openssl.tar.gz
tar -xvf openssl.tar.gz
mv nginx-goodies-nginx-sticky-module-ng-08a395c66e42  nginx-sticky-module

wget http://nginx.org/download/nginx-1.13.9.tar.gz -O nginx.tar.gz
tar -xvf nginx.tar.gz


cd nginx-1.13.9

./configure --prefix=${path}/nginx \
            --with-http_ssl_module \
            --with-http_gzip_static_module \
            --with-http_stub_status_module \
            --with-http_realip_module \
            --with-http_sub_module \
            --with-http_v2_module \
            --with-ipv6 \
            --with-http_flv_module \
            --with-stream \
            --with-pcre=../pcre-8.00 \
            --with-openssl=../openssl-1.1.1-pre1 \
            --add-module=../lua-nginx-module \
            --add-module=../stream-lua-nginx-module \
            --add-module=../nginx-rtmp-module \
            --add-module=../ngx_devel_kit \
            --add-module=../nginx-sticky-module

make
make install

