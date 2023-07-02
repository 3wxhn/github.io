#!/bin/bash
#========变量========
config="/etc/config"
DDNS="/etc/config/ddns"
ARGON="/etc/config/argon"
V2ray="/etc/config/v2ray_server"
Clash="/etc/config/openclash"
DHCP="/etc/config/dhcp"
Network="/etc/config/network"
Firewall="/etc/config/firewall"

#========函数========

function DDNS() {
cat >$DDNS<<EOF

config ddns 'global'
	option ddns_dateformat '%F %R'
	option ddns_loglines '250'
	option ddns_rundir '/var/run/ddns'
	option ddns_logdir '/var/log/ddns'

config service '3wxhn'
	option service_name 'aliyun.com'
	option use_ipv6 '0'
	option enabled '1'
	option lookup_host '3wxhn.cn'
	option domain '3wxhn.cn'
	option username 'LTAItvzxtlMo5k2Bx'
	option password 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
	option ip_source 'network'
	option ip_network 'wan'
	option interface 'wan'
	option use_syslog '2'
	option check_interval '5'
	option check_unit 'minutes'
	option force_interval '48'
	option force_unit 'minutes'
	option retry_unit 'seconds'
EOF
}

function ARGON() {
cat >$ARGON<<EOF

config global
	option primary '#5e72e4'
	option dark_primary '#483d8b'
	option transparency_dark '0.5'
	option bing_background '0'
	option blur_dark '1'
	option save '保存更改'
	option transparency '0.4'
	option mode 'light'
	option blur '0.5'
EOF
}

function V2ray() {
cat >$V2ray<<EOF

config global
	option enable '1'

config user 'c660a5990a044e6c84e91b09b853c303'
	option enable '1'
	option remarks '4333'
	option protocol 'vless'
	option port '4333'
	option decryption 'none'
	list uuid 'bbce25c0-cd01-43aa-a423-164c57e36704'
	option level '1'
	option tls '0'
	option transport 'tcp'
	option tcp_guise 'none'
	option accept_lan '1'

config user 'c44f6beb89b04751ace21170d667bffe'
	option enable '1'
	option remarks '4335'
	option protocol 'socks'
	option port '4335'
	option auth '1'
	option username 'admin'
	option password 'qad5201314xhn'
	option tls '0'
	option transport 'tcp'
	option tcp_guise 'none'
	option accept_lan '1'

EOF
}

function Clash() {
if ! grep -q "config openclash 'config'" $Clash; then
	sed -i "1a\config openclash 'config'" $Clash
	fi
#不走代理	
if ! grep -q "10.10.10.8" $Clash; then
	sed -i "/config openclash 'config'/a\	list lan_ac_black_ips '10.10.10.8'" $Clash
	fi
#更新订阅
if ! grep -q "^.*option auto_update '[0-9]'" $Clash; then
	sed -i "/config openclash 'config'/a\	option auto_update '1'" $Clash
	sed -i "/config openclash 'config'/a\	option config_auto_update_mode '0'" $Clash
	sed -i "/config openclash 'config'/a\	option config_update_week_time '*'" $Clash
	sed -i "/config openclash 'config'/a\	option auto_update_time '2'" $Clash	
else
	sed -i "s|^.*option auto_update '[0-9]'|	option auto_update '1'|g" $Clash
	sed -i "/config openclash 'config'/a\	option config_auto_update_mode '0'" $Clash
	sed -i "/config openclash 'config'/a\	option config_update_week_time '*'" $Clash
	sed -i "/config openclash 'config'/a\	option auto_update_time '2'" $Clash
	fi	
#使用meta内核
if ! grep -q "^.*option enable_meta_core '[0-9]'" $Clash; then
	sed -i "/config openclash 'config'/a\	option enable_meta_core '1'" $Clash
else
	sed -i "s|^.*option enable_meta_core '[0-9]'|	option enable_meta_core '1'|g" $Clash
	fi		
if ! grep -q "^.*option enable_rule_proxy '[0-9]'" $Clash; then
	sed -i "/config openclash 'config'/a\	option enable_rule_proxy '1'" $Clash
else
	sed -i "s|^.*option enable_rule_proxy '[0-9]'|	option enable_rule_proxy '1'|g" $Clash
	fi	
if ! grep -q "^.*option intranet_allowed '[0-9]'" $Clash; then
	sed -i "/config openclash 'config'/a\	option intranet_allowed '1'" $Clash
else
	sed -i "s|^.*option intranet_allowed '[0-9]'|	option intranet_allowed '1'|g" $Clash
	fi
if ! grep -q "option custom_china_domain_dns_server" $Clash; then
	sed -i "/config openclash 'config'/a\	option custom_china_domain_dns_server '114.114.114.114'" $Clash
fi	
if ! grep -q "^.*option china_ip_route '[0-9]'" $Clash; then
	sed -i "/config openclash 'config'/a\	option china_ip_route '1'" $Clash
else
	sed -i "s|^.*option china_ip_route '[0-9]'|	option china_ip_route '1'|g" $Clash
	fi

cat >>$Clash<<EOF

config config_subscribe
	option enabled '1'
	option name 'Clash'
	option address ''
	option sub_convert '0'

EOF
}

function Firewall() {
if ! grep -q "list network 'MODE'" $Firewall; then
sed -i "/list network 'wan'/a\	list network 'MODE'" $Firewall
fi
if ! grep -q "option name '软路由'" $Firewall; then
cat >>$Firewall<<EOF

config redirect
	option dest 'lan'
	option target 'DNAT'
	option name '软路由'
	option src 'wan'
	option src_dport '8'
	option dest_ip '10.10.10.10'
	option dest_port '80'
EOF
fi
if ! grep -q "option name '群晖'" $Firewall; then
cat >>$Firewall<<EOF

config redirect
	option dest 'lan'
	option target 'DNAT'
	option name '群晖'
	option src 'wan'
	option src_dport '5000'
	option dest_ip '10.10.10.8'
	option dest_port '5000'
EOF
fi
if ! grep -q "option name '群晖4455'" $Firewall; then
cat >>$Firewall<<EOF

config redirect
	option dest 'lan'
	option target 'DNAT'
	option name '群晖4455'
	option src 'wan'
	option src_dport '4455'
	option dest_ip '10.10.10.8'
	option dest_port '445'
EOF
fi
if ! grep -q "option name 'V2rray'" $Firewall; then
cat >>$Firewall<<EOF

config redirect
	option dest 'lan'
	option target 'DNAT'
	option name 'V2rray'
	option src 'wan'
	option src_dport '4333-4335'
	option dest_ip '10.10.10.10'
	option dest_port '4333-4335'
EOF
fi
}

function DHCP() {
# 禁用 ipv6_DHCP
sed -i "/option dhcpv6 'hybrid'/d" $DHCP
sed -i "/option ra 'hybrid'/d" $DHCP
sed -i "/option ra_slaac '1'/d" $DHCP
sed -i "/list ra_flags 'managed-config'/d" $DHCP
sed -i "/list ra_flags 'other-config'/d" $DHCP
sed -i "/option ndp 'hybrid'/d" $DHCP
# 添加静态DHCP
cat >>$DHCP<<EOF

config host
	option name 'nas'
	option dns '1'
	option mac '00-11-32-F3-82-FF'
	option ip '10.10.10.8'
	option leasetime 'infinite'	
EOF
}

function Network() {
cat >>$Network<<EOF

config interface 'MODE'
	option proto 'static'
	option device 'eth1'
	option ipaddr '192.168.1.1'
	option gateway '192.168.1.1'
	option defaultroute '0'
EOF
}

#========函数入口========
(cd $config && {
    [ -a ddns ] && DDNS && echo "DDNS配置......OK" &
    sleep 1
    [ -a argon ] && ARGON && echo "ARGON配置......OK" &
    sleep 1
    [ -a v2ray_server ] && V2ray && echo "V2ray配置......OK" &
    sleep 1
    [ -a openclash ] && Clash && echo "openclash配置......OK" &
    sleep 1
    [ -a dhcp ] && DHCP && echo "DHCP配置......OK" &
    sleep 1
    [ -a network ] && Network && echo "Network配置......OK" &
    sleep 1
    [ -a firewall ] && Firewall && echo "Firewall配置......OK" &
    sleep 1
    echo  
    echo '=================================' 
    echo '==========配置完成================' 
    echo '================================='
})
