class ScreenshotsInDock < Formula
	desc "Configures a custom Screenshots folder and sets macOS to save screenshots there"
	homepage "https://github.com/walteh/homebrew-tap"
	version "1.0.0"

	# https://apple.stackexchange.com/a/351612
	url "file:///dev/null"
	sha256 "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"

	depends_on "dockutil"

	def install
		(share/"screenshots-in-dock").write <<~EOS
			#!/usr/bin/env false
			# This is a dummy file to satisfy Homebrew’s requirement for a non-empty install.
			# This formula configures the macOS Dock to include the Screenshots folder and sets it as the default location for screenshots.
		EOS
	end

	def post_install
	  	# Automatically run the script after installation
		screenshot_dir = File.expand_path("~/Screenshots")
		system "mkdir", "-p", screenshot_dir

		system "defaults", "write", "com.apple.screencapture", "location", screenshot_dir
		system "killall", "SystemUIServer"
		puts "Screenshot location updated to #{screenshot_dir}"

		# Check if Screenshots folder is already in the Dock
		dock_items = `dockutil --list`
		if dock_items.include?(screenshot_dir)
		  puts "Screenshots folder is already in the Dock."
		else
		  # Add Screenshots folder to the Dock if not present
		  system "dockutil", "--add", screenshot_dir, "--view", "fan", "--display", "stack", "--sort", "dateadded", "--position", "end"
		  system "killall", "Dock"
		  puts "Added Screenshots folder to the Dock."
		end
	end

  end
