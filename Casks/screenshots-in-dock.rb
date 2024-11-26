cask "screenshots-in-dock" do
	version "1.0.0"

	name "Screenshots in Dock"
	desc "Adds Screenshots folder to macOS Dock and sets it as screenshot location"
	homepage "https://github.com/walteh/homebrew-tap"

	# https://apple.stackexchange.com/a/351612
	url "file:///dev/null"
	sha256 "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"

	stage_only true
	depends_on formula: "dockutil"
	depends_on macos: ">= :big_sur"

	postflight do
		# Dynamically determine the path to dockutil
		dockutil_path = nil

		if File.exist?("/opt/homebrew/bin/dockutil") # Apple Silicon
		  dockutil_path = "/opt/homebrew/bin/dockutil"
		elsif File.exist?("/usr/local/bin/dockutil") # Intel
		  dockutil_path = "/usr/local/bin/dockutil"
		else
		  odie "dockutil is required but not found. Install it with: brew install dockutil"
		end

		screenshot_dir = File.expand_path("~/Screenshots/")

		unless File.exist?(screenshot_dir)
		  puts "Screenshots folder does not exist. Creating it now... Password may be required."
		  system_command "mkdir", args: ["-p", screenshot_dir], sudo: true
		end

		# Set macOS to save screenshots to the new location
		system_command "defaults", args: ["write", "com.apple.screencapture", "location", screenshot_dir], sudo: false
		system_command "defaults", args: ["write", "com.apple.screencapture", "target", "file"], sudo: false
		system_command "killall", args: ["SystemUIServer"], sudo: false
		puts "Screenshot location updated to #{screenshot_dir}"

		# List current Dock items
		dock_items_result = system_command dockutil_path, args: ["--list"], sudo: false
		dock_items = dock_items_result.stdout # Extract the standard output as a string

		if dock_items.include?(screenshot_dir)
		  puts "Screenshots folder is already in the Dock."
		else
		  # Add Screenshots folder to the Dock
		  system_command dockutil_path, args: ["--add", screenshot_dir, "--view", "fan", "--display", "stack", "--sort", "dateadded", "--position", "end"], sudo: false
		  puts "Added Screenshots folder to the Dock."
		end
	end

  end
