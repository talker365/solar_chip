#!/bin/bash

echo 'Starting screen session (you have 10 seconds to join)'
echo 'use: "screen -x chip"'
screen -A -m -d -S chip /dev/tty.usbmodem* 115200
sleep 10

# 1) login as root
echo '1) login as root'
screen -S chip -p 0 -X stuff "root$(printf \\r)"
sleep 2
screen -S chip -p 0 -X stuff "chip$(printf \\r)"
sleep 2

# 2) Make sure that CHIP is up-to-date with all newest packages
echo '2) Make sure that CHIP is up-to-date with all newest packages'
screen -S chip -p 0 -X stuff "apt-get -y update$(printf \\r)"
sleep 60
screen -S chip -p 0 -X stuff "apt-get -y upgrade$(printf \\r)"
sleep 180

# 3) Then Install dnsmasq:
echo '3) Then Install dnsmasq:'
screen -S chip -p 0 -X stuff "apt-get -y install dnsmasq$(printf \\r)"
sleep 15

# 4) Download the kernel mods for enabling NAT
echo '4) Download the kernel mods for enabling NAT'
screen -S chip -p 0 -X stuff "cd /lib/modules/4.4.13-ntc-mlc/kernel/net/ipv4/netfilter$(printf \\r)"
sleep
#screen -S chip -p 0 -X stuff "wget https://dl.dropboxusercontent.com/u/48891705/chip/4.4.13-ntc-mlc/ipt_MASQUERADE.ko$(printf \\r)"
screen -S chip -p 0 -X stuff "wget http://aredn-vdn.com/chip.kernel/ipt_MASQUERADE.ko$(printf \\r)"
sleep 10
#screen -S chip -p 0 -X stuff "wget https://dl.dropboxusercontent.com/u/48891705/chip/4.4.13-ntc-mlc/nf_nat_masquerade_ipv4.ko$(printf \\r)"
screen -S chip -p 0 -X stuff "wget http://aredn-vdn.com/chip.kernel/nf_nat_masquerade_ipv4.ko$(printf \\r)"
sleep 10
screen -S chip -p 0 -X stuff "depmod$(printf \\r)"
sleep 5

# 5) Create a configure file . With this eth0 becomes a way to connect to a network, and wlan1 becomes CHIPs access point.
echo '5) Create a configure file . With this eth0 becomes a way to connect to a network, and wlan1 becomes CHIPs access point.'
screen -S chip -p 0 -X stuff "echo '#If you want dnsmasq to listen for DHCP and DNS requests only on' > /etc/dnsmasq.d/access_point.conf$(printf \\r)"
sleep 1
screen -S chip -p 0 -X stuff "echo '#specified interfaces (and the loopback) give the name of the' >> /etc/dnsmasq.d/access_point.conf$(printf \\r)"
sleep 1
screen -S chip -p 0 -X stuff "echo '#interface (eg eth0) here.' >> /etc/dnsmasq.d/access_point.conf$(printf \\r)"
sleep 1
screen -S chip -p 0 -X stuff "echo '#Repeat the line for more than one interface.' >> /etc/dnsmasq.d/access_point.conf$(printf \\r)"
sleep 1
screen -S chip -p 0 -X stuff "echo 'interface=wlan1' >> /etc/dnsmasq.d/access_point.conf$(printf \\r)"
sleep 1
screen -S chip -p 0 -X stuff "echo '#Or you can specify which interface not to listen on' >> /etc/dnsmasq.d/access_point.conf$(printf \\r)"
sleep 1
screen -S chip -p 0 -X stuff "echo 'except-interface=eth0 ' >> /etc/dnsmasq.d/access_point.conf$(printf \\r)"
sleep 1
screen -S chip -p 0 -X stuff "echo '' >> /etc/dnsmasq.d/access_point.conf$(printf \\r)"
sleep 1
screen -S chip -p 0 -X stuff "echo '#Uncomment this to enable the integrated DHCP server, you need' >> /etc/dnsmasq.d/access_point.conf$(printf \\r)"
sleep 1
screen -S chip -p 0 -X stuff "echo '#to supply the range of addresses available for lease and optionally' >> /etc/dnsmasq.d/access_point.conf$(printf \\r)"
sleep 1
screen -S chip -p 0 -X stuff "echo '#a lease time. If you have more than one network, you will need to' >> /etc/dnsmasq.d/access_point.conf$(printf \\r)"
sleep 1
screen -S chip -p 0 -X stuff "echo '#repeat this for each network on which you want to supply DHCP' >> /etc/dnsmasq.d/access_point.conf$(printf \\r)"
sleep 1
screen -S chip -p 0 -X stuff "echo '#service.' >> /etc/dnsmasq.d/access_point.conf$(printf \\r)"
sleep 1
screen -S chip -p 0 -X stuff "echo 'dhcp-range=172.20.0.100,172.20.0.250,1h ' >> /etc/dnsmasq.d/access_point.conf$(printf \\r)"
sleep 1

# 6) Set up a static IP for the AP(accesspoint)
echo '6) Set up a static IP for the AP(accesspoint)'
screen -S chip -p 0 -X stuff "echo '' >> /etc/network/interfaces$(printf \\r)"
sleep 1
screen -S chip -p 0 -X stuff "echo 'auto wlan1' >> /etc/network/interfaces$(printf \\r)"
sleep 1
screen -S chip -p 0 -X stuff "echo 'iface wlan1 inet static' >> /etc/network/interfaces$(printf \\r)"
sleep 1
screen -S chip -p 0 -X stuff "echo '    address 172.20.0.1' >> /etc/network/interfaces$(printf \\r)"
sleep 1
screen -S chip -p 0 -X stuff "echo '    netmask 255.255.255.0' >> /etc/network/interfaces$(printf \\r)"
sleep 1

# 7) Restart the wlan1 interface:
echo '7) Restart the wlan1 interface:'
screen -S chip -p 0 -X stuff "ifdown wlan1$(printf \\r)"
sleep 3
screen -S chip -p 0 -X stuff "ifup wlan1$(printf \\r)"
sleep 5

# 8) Restart the DHCP server
echo '8) Restart the DHCP server'
screen -S chip -p 0 -X stuff "/etc/init.d/dnsmasq restart$(printf \\r)"
sleep 5

# 9) Turn on DNS forwarding
echo '9) Turn on DNS forwarding'
screen -S chip -p 0 -X stuff "sysctl -w net.ipv4.ip_forward=1$(printf \\r)"
sleep 2

# 10) Setup NAT to route through eth0
echo '10) Setup NAT to route through eth0'
screen -S chip -p 0 -X stuff "iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE$(printf \\r)"
sleep 3

# 11) Configure the WiFi access point on wlan1
echo '11) Configure the WiFi access point on wlan1'
screen -S chip -p 0 -X stuff "echo 'interface=wlan1' > /etc/hostapd.conf$(printf \\r)"
sleep 1
screen -S chip -p 0 -X stuff "echo 'driver=nl80211' >> /etc/hostapd.conf$(printf \\r)"
sleep 1
screen -S chip -p 0 -X stuff "echo 'ssid=aredn-vdn-AP' >> /etc/hostapd.conf$(printf \\r)"
sleep 1
screen -S chip -p 0 -X stuff "echo 'channel=1' >> /etc/hostapd.conf$(printf \\r)"
sleep 1
screen -S chip -p 0 -X stuff "echo 'auth_algs=3' >> /etc/hostapd.conf$(printf \\r)"
sleep 1
screen -S chip -p 0 -X stuff "echo 'max_num_sta=10' >> /etc/hostapd.conf$(printf \\r)"
sleep 1
screen -S chip -p 0 -X stuff "echo 'wpa=2' >> /etc/hostapd.conf$(printf \\r)"
sleep 1
screen -S chip -p 0 -X stuff "echo 'wpa_passphrase=123456789' >> /etc/hostapd.conf$(printf \\r)"
sleep 1
screen -S chip -p 0 -X stuff "echo 'wpa_pairwise=TKIP CCMP' >> /etc/hostapd.conf$(printf \\r)"
sleep 1
screen -S chip -p 0 -X stuff "echo 'rsn_pairwise=CCMP' >> /etc/hostapd.conf$(printf \\r)"
sleep 1
screen -S chip -p 0 -X stuff "echo 'ctrl_interface=/var/run/hostapd' >> /etc/hostapd.conf$(printf \\r)"
sleep 1

# 12) Create script for handling service spin up
echo '12) Create script for handling service spin up'
screen -S chip -p 0 -X stuff "echo '#!/bin/bash' > /usr/sbin/vdn-router$(printf \\r)"
sleep 1
screen -S chip -p 0 -X stuff "echo '' >> /usr/sbin/vdn-router$(printf \\r)"
sleep 1
screen -S chip -p 0 -X stuff "echo '# Make sure interface is up' >> /usr/sbin/vdn-router$(printf \\r)"
sleep 1
screen -S chip -p 0 -X stuff "echo 'ifdown wlan1' >> /usr/sbin/vdn-router$(printf \\r)"
sleep 1
screen -S chip -p 0 -X stuff "echo 'ifup wlan1' >> /usr/sbin/vdn-router$(printf \\r)"
sleep 1
screen -S chip -p 0 -X stuff "echo '' >> /usr/sbin/vdn-router$(printf \\r)"
sleep 1
screen -S chip -p 0 -X stuff "echo '# Enable DNS forwarding' >> /usr/sbin/vdn-router$(printf \\r)"
sleep 1
screen -S chip -p 0 -X stuff "echo 'sysctl -w net.ipv4.ip_forward=1' >> /usr/sbin/vdn-router$(printf \\r)"
sleep 1
screen -S chip -p 0 -X stuff "echo '' >> /usr/sbin/vdn-router$(printf \\r)"
sleep 1
screen -S chip -p 0 -X stuff "echo '# Enable NAT' >> /usr/sbin/vdn-router$(printf \\r)"
sleep 1
screen -S chip -p 0 -X stuff "echo 'iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE' >> /usr/sbin/vdn-router$(printf \\r)"
sleep 1
screen -S chip -p 0 -X stuff "echo '' >> /usr/sbin/vdn-router$(printf \\r)"
sleep 1
screen -S chip -p 0 -X stuff "echo '# Start the Access Point' >> /usr/sbin/vdn-router$(printf \\r)"
sleep 1
screen -S chip -p 0 -X stuff "echo '/usr/sbin/hostapd /etc/hostapd.conf' >> /usr/sbin/vdn-router$(printf \\r)"
sleep 1

# 13) Make the spin up script executable
echo '13) Make the spin up script executable'
screen -S chip -p 0 -X stuff "chmod +x /usr/sbin/vdn-router$(printf \\r)"
sleep 1

# 14) Configure it to create AP on boot.
echo '14) Configure it to create AP on boot.'
screen -S chip -p 0 -X stuff "echo '[Unit]' > /lib/systemd/system/hostapd-systemd.service$(printf \\r)"
sleep 1
screen -S chip -p 0 -X stuff "echo 'Description=hostapd service' >> /lib/systemd/system/hostapd-systemd.service$(printf \\r)"
sleep 1
screen -S chip -p 0 -X stuff "echo 'Wants=network-manager.service' >> /lib/systemd/system/hostapd-systemd.service$(printf \\r)"
sleep 1
screen -S chip -p 0 -X stuff "echo 'After=network-manager.service' >> /lib/systemd/system/hostapd-systemd.service$(printf \\r)"
sleep 1
screen -S chip -p 0 -X stuff "echo 'Wants=module-init-tools.service' >> /lib/systemd/system/hostapd-systemd.service$(printf \\r)"
sleep 1
screen -S chip -p 0 -X stuff "echo 'After=module-init-tools.service' >> /lib/systemd/system/hostapd-systemd.service$(printf \\r)"
sleep 1
screen -S chip -p 0 -X stuff "echo 'ConditionPathExists=/etc/hostapd.conf' >> /lib/systemd/system/hostapd-systemd.service$(printf \\r)"
sleep 1
screen -S chip -p 0 -X stuff "echo '' >> /lib/systemd/system/hostapd-systemd.service$(printf \\r)"
sleep 1
screen -S chip -p 0 -X stuff "echo '[Service]' >> /lib/systemd/system/hostapd-systemd.service$(printf \\r)"
sleep 1
screen -S chip -p 0 -X stuff "echo 'ExecStart=/usr/sbin/vdn-router' >> /lib/systemd/system/hostapd-systemd.service$(printf \\r)"
sleep 1
screen -S chip -p 0 -X stuff "echo '' >> /lib/systemd/system/hostapd-systemd.service$(printf \\r)"
sleep 1
screen -S chip -p 0 -X stuff "echo '[Install]' >> /lib/systemd/system/hostapd-systemd.service$(printf \\r)"
sleep 1
screen -S chip -p 0 -X stuff "echo 'WantedBy=multi-user.target' >> /lib/systemd/system/hostapd-systemd.service$(printf \\r)"
sleep 1

# 15) Disable the existing systemV script for booting hostapd:
echo '15) Disable the existing systemV script for booting hostapd:'
screen -S chip -p 0 -X stuff "update-rc.d hostapd disable$(printf \\r)"  
sleep 3

# 16) Setup the systemd service
echo '16) Setup the systemd service'
screen -S chip -p 0 -X stuff "systemctl daemon-reload$(printf \\r)"
sleep 5
screen -S chip -p 0 -X stuff "systemctl enable hostapd-systemd$(printf \\r)"
sleep 5

# 17) Starting Access Point...:
echo '17) Starting Access Point...:'
screen -S chip -p 0 -X stuff "systemctl start hostapd-systemd$(printf \\r)"
sleep 5

echo 'DONE!'

