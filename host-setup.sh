#!/bin/bash -e

# terminal colors
FG_GREEN_BOLD="$(tput setaf 2)$(tput bold)"
FG_BOLD="$(tput bold)"
DEFAULT="$(tput sgr0)"

# install and run docker
if which yum > /dev/null 2>&1; then
{
    yum -y update
    yum -y install yum-utils device-mapper-persistent-data lvm2 ngrep tcpdump net-tools sudo bind-utils
    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    yum -y install docker-ce
    systemctl start docker
    systemctl enable docker
}
elif which apt-get > /dev/null 2>&1; then
{
	apt-get remove docker docker-engine docker.io
	apt-get -y update
	apt-get install apt-transport-https ca-certificates curl gnupg2 software-properties-common ngrep tcpdump net-tools sudo dnsutils
	curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
	add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
	apt-get -y update
	apt-get -y install docker-ce

	systemctl start docker
}
fi

# install docker-compose
curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# create user vibe, if it does not exist
id -u vibe >/dev/null 2>&1 || useradd -m -g docker vibe

# get installation scripts
cd /home/vibe
#mkdir -p reach-install
#curl https://raw.githubusercontent.com/ezuce/reach-install/master/reach > reach-install/reach
#curl https://raw.githubusercontent.com/ezuce/reach-install/master/docker-compose.yml > reach-install/docker-compose.yml
#chmod +x reach-install/reach
chown vibe -R /home/vibe

# user ezuce can quietly alter iptables to open port range for RTP media
echo "vibe ALL=(root) NOPASSWD: /sbin/iptables, /sbin/iptables-save" > /etc/sudoers.d/vibe

cat <<-EOF
	${FG_BOLD}To continue, login as user ${FG_GREEN_BOLD}vibesrv${DEFAULT}${FG_BOLD} [ su - vibe ] ...${DEFAULT}
EOF
