#!/bin/bash

printf "[*] Setup Start\n\n"

sudo sed -i 's/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list
sudo sed -i 's/# deb-src/deb-src/g' /etc/apt/sources.list
printf "[*] apt source changed\n\n"

sudo apt install -y locales && sudo apt clean
sudo sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sudo dpkg-reconfigure --frontend=noninteractive locales
sudo update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8
printf "[*] locales updated\n\n"

sudo apt install -y git sudo bash make nano vim zsh tmux cmake binutils nasm gcc gdb g++ gcc-multilib \
    build-essential libc6-dev-i386 libc6-dbg libc6-dbg:i386 \
    python python-pip python3 python3-pip curl netcat htop iotop iftop man strace ltrace wget \
    manpages-posix manpages-posix-dev libgmp3-dev libmpfr-dev libmpc-dev \
    nmap zmap libssl-dev inetutils-ping dnsutils whois mtr net-tools iproute2 tzdata ruby \
    ssh
sudo apt-get source libc6-dev
sudo apt clean
printf "[*] tools installed\n\n"

pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple --user --no-cache-dir -U pip
pip3 install --upgrade pip
pip2 install -i https://pypi.tuna.tsinghua.edu.cn/simple --user --no-cache-dir -U pip
pip2 install --upgrade pip
printf "[*] pip updated\n\n"

pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple --user --no-cache-dir -U jupyterlab ipython pycrypto pycryptodomex gmpy2 gmpy sympy numpy virtualenv requests flask formatstring mtp capstone --use-feature=2020-resolver
pip3 install --user --no-cache-dir -U git+https://github.com/arthaud/python3-pwntools.git
pip2 install -i https://pypi.tuna.tsinghua.edu.cn/simple --user --no-cache-dir -U jupyterlab ipython pycrypto pycryptodomex gmpy2 gmpy sympy numpy virtualenv requests flask pwntools ropgadget capstone --use-feature=2020-resolver
printf "[*] python tools installed\n\n"

cd ~
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

sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" || true && \
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions && \
git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions && \
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone git://github.com/wting/autojump.git ~/.oh-my-zsh/custom/plugins/autojump
cd ~/.oh-my-zsh/custom/plugins/autojump
python install.py
cd ~ && \
curl https://raw.githubusercontent.com/linkinlzm/ctf-docker/master/zshrc > ~/.zshrc
printf "[*] oh-my-zsh installed\n\n"

sudo snap install --classic code
printf "[*] vscode installed\n\n"


