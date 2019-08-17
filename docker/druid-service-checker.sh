OK=$(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:${DRUID_SERVICE_PORT}/status)
if [ "$OK" == "200" ]; then
   exit 0
else
   exit 1
fi
