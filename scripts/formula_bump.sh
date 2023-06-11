#!/usr/bin/env bash

formulas=$(find Formula -name "*.rb")

SCRIPT_CHANGELOG="## updated formulas"
DID_UPDATE=0

(
	cd ./.git/objects || exit 1
	sudo chmod -R ug+w .
	sudo find . -type d -exec chmod g+s '{}' +
)

for formula in $formulas; do

	file=./$formula

	if [[ ! -f "$file" ]]; then
		echo "Formula $file not found. Exiting."
		exit 1
	fi

	formula=$(basename "$formula" .rb)

	# Get the latest release from GitHub API for the tftab repo
	LATEST_RELEASE=$(curl --silent "https://api.github.com/repos/nuggxyz/$formula/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

	# replace v with nothing
	LATEST_RELEASE=${LATEST_RELEASE//v/}

	version=$(grep -oE "version \".*\"" "$file" | cut -d\" -f2)

	# Check if the version is already the latest
	if [[ "${version}" == "${LATEST_RELEASE}" ]]; then
		echo "Already on latest version ${LATEST_RELEASE}. Exiting."
	else
		# Update the formula file
		sed -i "s/\(version \"\)[^\"]*/\1${LATEST_RELEASE}/" "$file"
		echo "Updated $formula to version ${LATEST_RELEASE}."
		DID_UPDATE=1
		SCRIPT_CHANGELOG="$SCRIPT_CHANGELOG\\n- $formula: \`${version}\` -> \`${LATEST_RELEASE}\`"
	fi
done

echo "DID_UPDATE=$DID_UPDATE" >>"$GITHUB_OUTPUT"
echo "SCRIPT_CHANGELOG=$SCRIPT_CHANGELOG" >>"$GITHUB_OUTPUT"
