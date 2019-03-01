git config credential.helper 'cache --timeout=120'
git config user.email "email"
git config user.name "CI Tagging"

if git diff-tree --no-commit-id --name-only -r $CIRCLE_SHA1 | grep -q "version.txt"; then
    git tag -a "release-version-$(cat version.txt)" -m "$(cat version.txt)"
    git push -q https://${GITHUB_TOKEN}@github.com/AP-Hunt/overwatcharenaclashcommunity.com.git "release-version-$(cat version.txt)"
else 
    git tag -a "release-$CIRCLE_SHA1" -m  "$CIRCLE_SHA1"
    git push -q https://${GITHUB_TOKEN}@github.com/AP-Hunt/overwatcharenaclashcommunity.com.git "release-$CIRCLE_SHA1"
fi