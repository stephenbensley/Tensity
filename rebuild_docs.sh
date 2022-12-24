#!/bin/zsh

set -eu

# This script lives at the root of the Tensity project.
TENSITY_ROOT=${0:a:h}
cd "$TENSITY_ROOT"

# This setting greatly improves the determinism of docc generation.
export DOCC_JSON_PRETTYPRINT="YES"

# Regenerate the doccarchive
rm -Rf doccarchive
xcodebuild docbuild \
	-scheme Tensity \
	-derivedDataPath ./doccarchive \
	-destination 'platform=iOS Simulator,name=iPhone 14'
ARCHIVE=$(find doccarchive -type d -name '*.doccarchive')

# Convert the archive to a static website
rm -Rf docs.new
$(xcrun --find docc) process-archive transform-for-static-hosting \
	"$ARCHIVE" --hosting-base-path Tensity --output-path docs.new
rm -Rf doccarchive

# Replace the old site with the new site
rm -Rf docs
mv docs.new docs

# Update the index.html at root with our custom page
cp -f index.html.src docs/index.html
