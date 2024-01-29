#!/bin/bash -vx

export LANG=ja_JP.UTF-8

sed -i 's/User apache/User '$RUN_USER'/g' /etc/httpd/conf/httpd.conf
sed -i 's/Group apache/Group '$RUN_USER'/g' /etc/httpd/conf/httpd.conf

cat << FIN >> /etc/httpd/conf/httpd.conf
<Directory "/home/$RUN_USER/web">
        Options +Indexes +FollowSymLinks +ExecCGI
	AddHandler cgi-script .cgi .ajax .py .CGI .AJAX .PY
        AllowOverride All
        Require all granted
</Directory>

NameVirtualHost *:80
<VirtualHost *:80>
    DocumentRoot /home/$RUN_USER/web
</VirtualHost>
FIN

cat << FIN > /home/$RUN_USER/web/.htaccess
SetEnv HOSTNAME $HOSTNAME
FIN

cat << FIN >> /etc/httpd/conf.modules.d/00-mpm.conf
ScriptSock /var/run/httpd/cgid.sock
FIN

chown ${RUN_USER}:${RUN_USER} /var/run/httpd

mv /etc/httpd/conf.d/welcome.conf /etc/httpd/conf.d/welcome.conf.bak

#####################################

/usr/sbin/httpd -DFOREGROUND

exit 0
