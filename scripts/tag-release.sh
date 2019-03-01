git config credential.helper 'cache --timeout=120'
git config user.email "email"
git config user.name "CI Tagging"

mkdir -p ~/.ssh/
touch ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa

echo $DEPLOY_SSH_PRIVATE_KEY > ~/.ssh/id_rsa

ls -la ~/.ssh/

touch ~/.ssh/known_hosts
ssh-keyscan -H github.com >> ~/.ssh/known_hosts

if git diff-tree --no-commit-id --name-only -r $DRONE_COMMIT_SHA | grep -q "version.txt"; then
    git tag -a "release-version-$(cat version.txt)" -m "$(cat version.txt)"
    git push "git@github.com:AP-Hunt/overwatcharenaclashcommunity.git" "release-version-$(cat version.txt)"
else 
    git tag -a "release-$DRONE_COMMIT_SHA" -m  "$DRONE_COMMIT_SHA"
    git push "git@github.com:AP-Hunt/overwatcharenaclashcommunity.git" "release-$DRONE_COMMIT_SHA"
fi