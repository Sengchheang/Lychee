#!/bin/bash -ex

exit 0

WEBSITE_URL="http://photo.web-essentials.asia/"

echo "INFO execute yslow check..."
phantomjs /opt/yslow.js -i grade -threshold "A" --dict --console 2 -f tap ${WEBSITE_URL} > yslow.tap

echo "INFO execute UAT"
rm -rf build/logs/
mkdir -p build/logs/
bundle install
HOST_URL=${WEBSITE_URL} rspec --format documentation --format html --out build/logs/uat-report.html --format documentation --out build/logs/uat-report.txt
