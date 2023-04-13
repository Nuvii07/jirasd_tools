#!/bin/bash
CREATEDIR=/opt/TOOLS
VRFILE=$(hostname -s)__$(hostname -I | cut -d ' ' -f1).csv

rm -rf /opt/TOOLS/*

#tworzy katalog do przechowywania pliku z wersjami
if [ ! -d ${CREATEDIR} ];
 then
 mkdir -p ${CREATEDIR};
fi

cd /opt/TOOLS/
touch ${VRFILE}

#Zbiera wersje oprogramowania i zapisuje do pliku
echo "name;value"| cat >> /opt/TOOLS/${VRFILE}
echo "TrendMicro;"$(rpm -qa | grep -i ds_agent|cut -d '-' -f2)";"| cat >> /opt/TOOLS/${VRFILE}
echo "Elasticsearch;"$(rpm -qa | grep -i elasticsearch|cut -d '-' -f2)";"| cat >> /opt/TOOLS/${VRFILE}
echo "Kibana;"$(rpm -qa | grep -i kibana|cut -d '-' -f2)";"| cat >> /opt/TOOLS/${VRFILE}
echo "OpenLDAP;"$(rpm -qa | grep -i openldap|cut -d '-' -f2 | head -1)";"| cat >> /opt/TOOLS/${VRFILE}
echo "Garb;"$(rpm -qa | grep -i garbd|cut -d '-' -f6)";"| cat >> /opt/TOOLS/${VRFILE}
echo "Zabbix;"$(rpm -qa | grep -i zabbix-agent|head -n1|cut -d '-' -f3)";"| cat >> /opt/TOOLS/${VRFILE}
echo "Docker;"$(docker --version|cut -d',' -f1|awk '{print $3}')";"| cat >> /opt/TOOLS/${VRFILE}
echo "MySQL;"$(mysqld -V|cut -d',' -f1|awk '{print $3}')";" | cat >> /opt/TOOLS/${VRFILE}
echo "Mongo;"$(mongo --version|grep "version"|head -1|awk '{print $4}')";"| cat >> /opt/TOOLS/${VRFILE}
echo "GlusterFS;"$(gluster --version |head -1|awk '{print $2}')";"| cat >> /opt/TOOLS/${VRFILE}
echo "GIT;"$(git --version|awk '{print $3}')";"| cat >> /opt/TOOLS/${VRFILE}
echo "PostgresSQL;"$(psql -V|awk '{print $3}')";"| cat >> /opt/TOOLS/${VRFILE}
echo "Filebeat;"$(filebeat version|awk '{print $3}')";"| cat >> /opt/TOOLS/${VRFILE}
echo "WildFly;"$(ls /opt|grep wildfly-|cut -d'-' -f2| head -1)";"| cat >> /opt/TOOLS/${VRFILE}
#ejbca sprawdza dwie wersje EJBCA
echo "EJBCA;"$(ls /opt|grep ejbca_ce_6 |cut -f 3,4,5,6 -d '_' --output-delimiter='.'|head -1)";"| cat >> /opt/TOOLS/${VRFILE}
echo "EJBCA;"$(ls /opt|grep ejbca_ce_7 |cut -f 3,4,5,6 -d '_' --output-delimiter='.'|head -1)";"| cat >> /opt/TOOLS/${VRFILE}
#ls /opt|grep ejbca_c|cut -d'/' -f2|head -2
echo "Apache HTTP Server;"$(apachectl -v|cut -d'/' -f2|awk '{print $1}'|head -1)";"| cat >> /opt/TOOLS/${VRFILE}
sleep 1
echo "EDB;"$(/usr/edb/as14/bin/psql -V|awk '{print $3}')";"| cat >> /opt/TOOLS/${VRFILE}
sleep 1
echo "Drupal;"$(docker exec -it docker_ikp_cms_1 /var/www/html/vendor/bin/drush status|head -n1|cut -d ' ' -f6)";"| cat >> /opt/TOOLS/${VRFILE}
sleep 1
echo "WSO2;"$(docker exec -ti docker_sus_1 /opt/wso2ei-6.5.0/bin/integrator.sh --version|head -1|cut -d'v' -f2)";"| cat >> /opt/TOOLS/${VRFILE}
sleep 1
echo "Nessus;"$(/opt/nessus/sbin/nessuscli --version|head -1|cut -d')' -f2|awk '{print $1}')";"| cat >> /opt/TOOLS/${VRFILE}