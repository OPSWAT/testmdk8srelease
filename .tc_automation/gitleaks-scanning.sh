rm -rf gitleaksReports
mkdir gitleaksReports
chmod +777 gitleaksReports

echo "Scanning started"
docker run -v .:/path zricethezav/gitleaks:latest detect --source="/path" --no-git -c /path/.tc_automation/gitleaks.toml --redact -r /path/gitleaksReports/gitleaks.json