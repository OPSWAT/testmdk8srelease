echo "### Reading Params"
SSH_KEY=$1
RELEASE_VERSION=$2
echo "RELEASE_VERSION=$RELEASE_VERSION"

echo "### Setting GitHub Key"
echo "$SSH_KEY" > ~/.ssh/gh_rsa

echo "### Scanning Bitbucket Code"
cd bitbucket
docker run -v .:/path zricethezav/gitleaks:latest detect --source="/path" -v --no-git

echo "### Docker run"
cd ..
docker run --rm \
  -v ~/.ssh/gh_rsa:/root/.ssh/gh_rsa \
  -v ./bitbucket:/bitbucket \
  alpine:latest sh -c "
    apk add --no-cache git openssh &&
    chmod 600 /root/.ssh/gh_rsa &&
    GIT_SSH_COMMAND='ssh -i /root/.ssh/gh_rsa -o StrictHostKeyChecking=no -o IdentitiesOnly=yes' git clone git@github.com:OPSWAT/metadefender-k8s.git &&
    cd metadefender-k8s &&
    GIT_SSH_COMMAND='ssh -i /root/.ssh/gh_rsa -o IdentitiesOnly=yes' git checkout -b $RELEASE_VERSION &&
    git config --global user.email 'buildautomation@opswat.com' &&
    git config --global user.name 'Build Automation' &&
    rm -r * &&
    cp -r /bitbucket/* ./ &&
    GIT_SSH_COMMAND='ssh -i /root/.ssh/gh_rsa -o IdentitiesOnly=yes' git add . &&
    GIT_SSH_COMMAND='ssh -i /root/.ssh/gh_rsa -o IdentitiesOnly=yes' git commit -m 'Release version $RELEASE_VERSION' &&
    GIT_SSH_COMMAND='ssh -i /root/.ssh/gh_rsa -o StrictHostKeyChecking=no -o IdentitiesOnly=yes' git push origin $RELEASE_VERSION
  "

echo "### Removing ssh key"
rm -f ~/.ssh/gh_rsa