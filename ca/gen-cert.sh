#!/bin/bash
set -eux;

is_domain() {
    local domain_regex='^([a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,}$'
    [[ "$1" =~ $domain_regex ]]
}

if [ $# -ne 2 ]; then
    echo "gen-cert.sh <domain> <days>"
    exit 1
else
    if is_domain $1; then
        echo "domin: $1"
    else
        echo "$1 is not a domain"
        exit 1
    fi

    if [[ $2 =~ ^[0-9]+$ ]]; then
        echo "days: $2"
    else
        echo "$2 is not a number"
        exit 1
    fi
fi

if [ $# -eq 0 ]; then
    echo "No arguments provided"
elif [ $# -eq 1 ]; then
    echo "One argument provided: $1"
else
    echo "Multiple arguments provided: $@"
fi

# 1.初始化

export CA_L2_DIR=/Users/hello/studio/ca/rsa-ca/web-ca

# 申请工作目录
export SERVER_CERT_DIR=/Users/hello/studio/ca/rsa-ca/studio-cert
mkdir -p $SERVER_CERT_DIR

# 切换
cd $SERVER_CERT_DIR

# 2.生成密钥
export SERVER_DOMAIN=$1;
export CERT_DAYS=$2;

mkdir -p $SERVER_CERT_DIR/$SERVER_DOMAIN

SERVER_KEY_PATH=$SERVER_CERT_DIR/$SERVER_DOMAIN/$SERVER_DOMAIN.key.pem
openssl genrsa -out $SERVER_KEY_PATH 4096


# 3.签名请求配置
export SERVER_CERT_REQ_CONFIG_PATH=$SERVER_CERT_DIR/$SERVER_DOMAIN/server-$SERVER_DOMAIN.csr.cnf

cat > $SERVER_CERT_REQ_CONFIG_PATH << EOL
[ req ]
distinguished_name  = req_distinguished_name
string_mask         = utf8only
req_extensions      = req_ext
x509_extensions     = v3_req

# SHA-1 is deprecated, so use SHA-2 instead.
default_md          = sha256
prompt              = no

[ req_distinguished_name ]
# See <https://en.wikipedia.org/wiki/Certificate_signing_request>.
commonName                      = $SERVER_DOMAIN

[req_ext]
subjectAltName = @alt_names

[v3_req]
subjectAltName = @alt_names

[alt_names]
# IP.1 = 127.0.0.1
DNS.1 = $SERVER_DOMAIN
EOL

# 4.生成签名请求
export SERVER_CERT_CSR_PATH=$SERVER_CERT_DIR/$SERVER_DOMAIN/server-$SERVER_DOMAIN.csr.pem

openssl req \
    -config $SERVER_CERT_REQ_CONFIG_PATH \
    -new -sha256 \
    -key $SERVER_KEY_PATH \
    -out $SERVER_CERT_CSR_PATH

# 5.生成证书
SERVER_CERT_PATH=$SERVER_CERT_DIR/$SERVER_DOMAIN/server-$SERVER_DOMAIN.cert.pem

openssl ca \
    -config $CA_L2_DIR/ca.cnf \
    -extensions server_cert \
    -days $CERT_DAYS \
    -notext \
    -md sha256 \
    -batch \
    -in $SERVER_CERT_CSR_PATH \
    -out $SERVER_CERT_PATH

# 6.生成证书链

SERVER_FULLCHAIN_PATH=$SERVER_CERT_DIR/$SERVER_DOMAIN/server-$SERVER_DOMAIN.fullchain.pem

cat > $SERVER_FULLCHAIN_PATH << EOL
$(cat $SERVER_CERT_PATH)

$(cat $CA_L2_DIR/ca.fullchain.pem)
EOL

# 验证
openssl verify -CAfile $CA_L2_DIR/ca.fullchain.pem $SERVER_FULLCHAIN_PATH