#!/bin/bash

cd ~
sudo apt install -y curl 
curl -LROJ https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh
sudo bash install-release.sh
read -p "Enter domain: " domain
read -p "Enter UUID: " uuid
read -p "Enter path: " path
sudo cat<<EOF>/usr/local/etc/v2ray/config.json
{
  "log" : {
    "loglevel": "warning"
  },
  "inbounds": [
    {
      "listen" : "127.0.0.1",
      "protocol" : "http",
      "tag" : "httpinbound",
      "port" : 7890
    }
  ],
  "outbounds": [
    {
      "protocol": "vmess",
      "settings": {
        "vnext": [
          {
            "address": "$domain",
            "port": 443,
            "users": [
                {"id": "$uuid", "alterId" : 64, "level" : 1}
            ]
          }
        ]
      },
    "tag" : "HI",
    "streamSettings" : {
      "tlsSettings" : {
          "allowInsecure" : false,
          "alpn" : [
            "http/1.1"
          ],
          "serverName" : "$domain",
          "allowInsecureCiphers" : true
        },
      "wsSettings" : {
        "path" : "$path"
      },
      "security" : "tls",
      "network" : "ws"
    }
    },
    {
      "protocol": "blackhole",
      "settings": {},
      "tag": "block"
    },
    {
      "protocol": "freedom",
      "tag": "direct",
      "settings": {}
    }
  ],
  "routing": {
   "domainStrategy": "IPOnDemand",
    "strategy": "rules",
    "rules": [
      {
        "type": "field",
        "ip": [
          "geoip:private"
        ],
        "outboundTag": "direct"
      },
      {
        "type": "field",
        "domain": [
          "geosite:cn"
        ],
        "outboundTag": "direct"
      },
      {
        "type": "field",
        "ip": [
          "geoip:cn"
        ],
        "outboundTag": "direct"
      }
    ]
  }
}
EOF

sudo systemctl enable v2ray
sudo systemctl start v2ray
printf "[*] v2ray installed\n\n"

export https_proxy=http://127.0.0.1:7890 && export http_proxy=http://127.0.0.1:7890
git config --global http.proxy http://127.0.0.1:7890
printf "[*] proxy changed to 127.0.0.1:7890\n\n"