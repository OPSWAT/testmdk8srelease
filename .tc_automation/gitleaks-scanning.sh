#!/bin/bash
#
# Script for scanning the mdss repo with GitLeaks
# Parameters:
# $1 - teamcity build checkout dir

cd $1
mkdir gitleaksReports

if [[ -d $1 ]] 
then 
    echo "Scanning started"
    gitleaks detect -c gitleaks.toml -s . -v --no-git --redact -r ./gitleaksReports/gitleaks.json
fi