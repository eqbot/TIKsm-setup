#!/bin/bash
declare -i counter=0
NODENAMES=$(kubectl get nodes -o jsonpath='{ .items[*].metadata.name }')
for NODE in $NODENAMES
do
   if [ "$counter" != '0' ]; then 
      SYSNODE="$NODE-system"
      sed "s/WATCHEDNODE/$NODE/g" systemDashboardTemplate.txt > "$SYSNODE-metrics.json"
      NODEuuid=$(uuidgen)
      sed -i "s/\"uid\": \"UCRfGnBmk\"/\"uid\": \"$NODEuuid\" /g" "$SYSNODE-metrics.json"
   else 
      let "counter=counter+1"
   fi    
done

cp *.json ../charts/grafana/dashboards/