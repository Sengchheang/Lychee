#!/bin/bash -ex
exit 0

FILE_NAME=$(basename "$0")
STAGE="${FILE_NAME%.*}"
WEBSITE_URL="http://www.${STAGE}.photo.web-essentials.asia/"

echo "INFO execute yslow check..."
phantomjs /opt/yslow.js -i grade -threshold "A" --dict --console 2 -f tap ${WEBSITE_URL} > yslow.tap

echo "INFO execute UAT"
rm -rf build/logs/
mkdir -p build/logs/
bundle install
HOST_URL=${WEBSITE_URL} rspec --format documentation --format html --out build/logs/uat-report.html --format documentation --out build/logs/uat-report.txt
