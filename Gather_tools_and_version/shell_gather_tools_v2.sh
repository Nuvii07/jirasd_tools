#!/bin/bash
CREATEDIR=/opt/TOOLS
VRFILE=$(hostname -s)__$(hostname -I | cut -d ' ' -f1).csv
export wso2_version=$(docker exec -ti docker_sus_1 sh -c '/opt/wso2ei-6.5.0/bin/integrator.sh --version' | head -1 | awk -F"v" '{print $2}')
export wso2_v=${wso2_version::-1}
export drupal_version=$(docker exec -it docker_ikp_cms_1 sh -c '/var/www/html/vendor/bin/drush status' | head -n1 | awk -F" " '{ print $4 }')
#export drupal_v=${drupal_version::-1}

function get_version {
  if rpm -q $1 >/dev/null;
then
  echo "$2;$(rpm -qi $1 | grep Version | awk '{print $3}');" >> /opt/TOOLS/${VRFILE}
fi
}
rm -rf /opt/TOOLS/*

#tworzy katalog do przechowywania pliku z wersjami
if [ ! -d ${CREATEDIR} ];
 then
 mkdir -p ${CREATEDIR};
fi

cd /opt/TOOLS/
touch ${VRFILE}
echo "name;value;" > /opt/TOOLS/${VRFILE}
get_version ds_agent TrendMicro
get_version elasticsearch Elasticsearch
get_version kibana Kibana
get_version openldap OpenLDAP
get_version garbd Garb

get_version zabbix-agent Zabbix
get_version zabbix-agent2 Zabbix

get_version glusterfs GlusterFS
echo "GIT;"$(git --version|awk '{print $3}')";"| cat >> /opt/TOOLS/${VRFILE}

get_version percona-server-mongodb MongoDB

get_version Percona-XtraDB-Cluster-57 MySQL
get_version Percona-XtraDB-Cluster-80 MySQL
get_version percona-xtradb-cluster MySQL

get_version postgresql11 PostgreSQL
get_version postgresql12 PostgreSQL
get_version postgresql13 PostgreSQL
get_version postgresql14 PostgreSQL

get_version edb-as11-server EDB
get_version edb-as12-server EDB
get_version edb-as13-server EDB
get_version edb-as14-server EDB
echo "Dynatrace;"$(cat /opt/dynatrace/oneagent/agent/installer.version | cut -d'.' -f1,2,3)";"| cat >> /opt/TOOLS/${VRFILE}
echo "Docker;"$(docker --version|cut -d',' -f1|awk '{print $3}')";"| cat >> /opt/TOOLS/${VRFILE}
echo "Filebeat;"$(filebeat version|awk '{print $3}')";"| cat >> /opt/TOOLS/${VRFILE}
echo "WildFly;"$(ls /opt|grep wildfly-|cut -d'-' -f2| head -1)";"| cat >> /opt/TOOLS/${VRFILE}
echo "EJBCA;"$(ls /opt|grep ejbca_ce_6 |head -1 | awk -F"-" '{ print $1 }'| cut -f 3,4,5,6 -d '_' --output-delimiter='.')";"| cat >> /opt/TOOLS/${VRFILE}
echo "EJBCA;"$(ls /opt|grep ejbca_ce_7 |cut -f 3,4,5,6 -d '_' --output-delimiter='.'|head -1)";"| cat >> /opt/TOOLS/${VRFILE}
echo "Apache HTTP Server;"$(apachectl -v|cut -d'/' -f2|awk '{print $1}'|head -1)";"| cat >> /opt/TOOLS/${VRFILE}
echo "Nessus;"$(/opt/nessus/sbin/nessuscli --version|head -1|cut -d')' -f2|awk '{print $1}')";"| cat >> /opt/TOOLS/${VRFILE}
echo "Drupal;"$drupal_version";" | cat >> /opt/TOOLS/${VRFILE}
echo "WSO2;"$wso2_v";" | cat >> /opt/TOOLS/${VRFILE}
