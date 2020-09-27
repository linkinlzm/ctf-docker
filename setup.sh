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

sudo timedatectl set-timezone Asia/Shanghai
timedatectl
printf "[*] time zone updated\n\n"

sudo apt install -y git sudo bash make nano vim zsh tmux cmake binutils nasm gcc gdb g++ gcc-multilib \
    build-essential libc6-dev-i386 libc6-dbg libc6-dbg:i386 \
    python python-pip python3 python3-pip ipython3 curl netcat htop iotop iftop man strace ltrace wget \
    manpages-posix manpages-posix-dev libgmp3-dev libmpfr-dev libmpc-dev \
    nmap zmap libssl-dev libffi-dev inetutils-ping dnsutils whois mtr net-tools iproute2 tzdata ruby \
    ssh qemu binwalk
sudo apt-get source libc6-dev
sudo apt clean
printf "[*] tools installed\n\n"

# pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple --user --no-cache-dir -U pip
# pip3 install --upgrade pip
python3 -m pip install --upgrade pip
# pip2 install -i https://pypi.tuna.tsinghua.edu.cn/simple --user --no-cache-dir -U pip
# pip2 install --upgrade pip
python2 -m pip install --upgrade pip
pip3 --version
pip2 --version
printf "[*] pip updated\n\n"

pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple --user --no-cache-dir -U jupyterlab ipython pycrypto pycryptodomex gmpy2 gmpy sympy numpy virtualenv requests flask formatstring mtp capstone --use-feature=2020-resolver
pip3 install --user --no-cache-dir -U git+https://github.com/arthaud/python3-pwntools.git
pip2 install -i https://pypi.tuna.tsinghua.edu.cn/simple --user --no-cache-dir -U jupyterlab ipython pycrypto pycryptodomex gmpy2 gmpy sympy numpy virtualenv requests flask pwntools ropgadget capstone z3-solver unicorn angr --use-feature=2020-resolver
printf "[*] python tools installed\n\n"

cd ~
git clone https://github.com/pwndbg/pwndbg && cd pwndbg && ./setup.sh && cd ..
git clone https://github.com/scwuaptx/peda.git ~/peda && cp ~/peda/.inputrc ~/
git clone https://github.com/scwuaptx/Pwngdb.git ~/Pwngdb && cat ~/Pwngdb/.gdbinit >> ~/.gdbinit
sed -i 's?source ~/peda/peda.py?#source ~/peda/peda.py?g' .gdbinit
sudo gem install one_gadget seccomp-tools
printf "[*] gdb tools installed\n\n"

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
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

printf "[*] Setup Done\n\n"
chsh -s $(which zsh)
zsh
