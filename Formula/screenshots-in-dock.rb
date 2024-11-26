class ScreenshotsInDock < Formula
	desc "Configures a custom Screenshots folder and sets macOS to save screenshots there"
	homepage "https://github.com/walteh/homebrew-tap"
	version "1.0.0"
	url "https://github.com/walteh/homebrew-tap"
	depends_on "dockutil"

	# No need for `url` or `sha256` since we’re embedding the script.

	def install
	  # Write the script directly into the bin directory during installation
	(bin/"screenshots-in-dock").write <<~EOS
			#!/bin/bash
			# Define the desired location for the Screenshots folder
			SCREENSHOT_DIR="$HOME/Screenshots"

			# Create the folder if it doesn't exist
			if [ ! -d "$SCREENSHOT_DIR" ]; then
				mkdir -p "$SCREENSHOT_DIR"
				echo "Created $SCREENSHOT_DIR"
			else
				echo "$SCREENSHOT_DIR already exists"
			fi

			# Update macOS screenshot location
			defaults write com.apple.screencapture location "$SCREENSHOT_DIR"
			killall SystemUIServer
			echo "Screenshot location updated to $SCREENSHOT_DIR"

			# Optional: Add the Screenshots folder to the Dock
			# Uncomment the following lines if you want to add it automatically
			dockutil --add $SCREENSHOT_DIR --view fan --display stack --sort dateadded --position end
			killall Dock
			echo "Added $SCREENSHOT_DIR to the Dock"
	  EOS

	  # Make the script executable
	  chmod "+x", bin/"screenshots-in-dock"
	end

	def post_install
	  # Automatically run the script after installation
	  system "#{bin}/screenshots-in-dock"
	end

	test do
		# Test that the Screenshots folder is created
		system "mkdir", "-p", testpath/"Screenshots"
		assert_predicate testpath/"Screenshots", :directory?, "Screenshots folder should be created"

		# Test that the script can be executed successfully
		system "#{bin}/screenshots-in-dock"
		assert_match "Screenshot location updated", shell_output("#{bin}/screenshots-in-dock")

		# Check if the screenshot location was updated
		screenshot_location = shell_output("defaults read com.apple.screencapture location")
		assert_match "#{ENV["HOME"]}/Screenshots", screenshot_location.strip, "Screenshot location should be set"

		# Check if the Screenshots folder is in the Dock
		dock_items = shell_output("defaults read com.apple.dock persistent-others")
		assert_match /Screenshots/, dock_items, "Screenshots folder should be added to the Dock"
	end

  end
