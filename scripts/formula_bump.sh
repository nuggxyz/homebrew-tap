#!/usr/bin/env bash

formulas=$(find Formula -name "*.rb")

CHANGELOG="## updated formulas"
DID_UPDATE=0

for formula in $formulas; do

	# Get the latest release from GitHub API for the tftab repo
	LATEST_RELEASE=$(curl --silent "https://api.github.com/repos/nuggxyz/$formula/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

	# replace v with nothing
	LATEST_RELEASE=${LATEST_RELEASE//v/}

	version=$(grep -oE "^ {4}version \".*\"" "$formula.rb" | cut -d\" -f2)

	# Check if the version is already the latest
	if [[ "${version}" == "${LATEST_RELEASE}" ]]; then
		echo "Already on latest version ${LATEST_RELEASE}. Exiting."
	else
		# Update the formula file
		sed -i "s/\(version \"\)[^\"]*/\1${LATEST_RELEASE}/" "Formula/$formula.rb"
		# sed -i "s/\(sha256 \"\)[^\"]*/\1${SHA256}/" "Formula/$formula.rb"
		echo "Updated $formula to version ${LATEST_RELEASE}."
		DID_UPDATE=1
		CHANGELOG="$CHANGELOG\n- $formula: ${version} -> ${LATEST_RELEASE}"
	fi
done

echo "DID_UPDATE=$DID_UPDATE" >>"$GITHUB_OUTPUT"
echo "CHANGELOG=$CHANGELOG" >>"$GITHUB_OUTPUT"
