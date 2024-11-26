cask "zshrc-manager" do
	version "1.0.0"
	sha256 :no_check

	depends_on cask: "walteh/tap/oh-my-zsh"
	depends_on formula: "zsh-completions"
	depends_on formula: "zsh-autosuggestions"
	depends_on formula: "zsh-autocomplete"
	depends_on formula: "zsh-fast-syntax-highlighting"

	url "file:///dev/null" # No actual file; this is for configuration
	name "ZshRC Manager"
	desc "Manages Zsh configuration, including completions and Homebrew integration"
	homepage "https://example.com"

	postflight do
	  zshrc_path = File.expand_path("~/.zshrc")

	  if File.exist?("/opt/homebrew/bin") # Apple Silicon
		brew_prefix = "/opt/homebrew"
	  elsif File.exist?("/usr/local/bin") # Intel
		brew_prefix = "/usr/local"
	  else
		odie "Homebrew is required but not found. Install it from https://brew.sh"
	  end

	  zshrc_manager_path = File.expand_path("#{brew_prefix}/share/zshrc-manager")

	  completions_config = <<~EOS
		# --- MANAGED BY ZSHRC-MANAGER CASK --- start
		source #{brew_prefix}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
		source #{brew_prefix}/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
		source #{brew_prefix}/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
		if type brew &>/dev/null; then
		  FPATH=#{brew_prefix}/share/zsh-completions:$FPATH
		  FPATH=#{brew_prefix}/share/zsh/site-functions:$FPATH
		  autoload -Uz compinit
		  compinit
		fi

		export ZSH="$HOME/.oh-my-zsh"
		export ZSH_DISABLE_COMPFIX=true

		ZSH_THEME="robbyrussell"
		HIST_STAMPS="yyyy-mm-dd"

		plugins=(
			git
			kubectl
			helm
			dotnet
			node
			history
			emoji
			encode64
			jsontools
			brew
			macos
			web-search
			history-substring-search
			terraform
			docker
			docker-compose
			xcode
			vscode
			thefuck
			swiftpm
			ssh
			ssh-agent
			rust
			python
			pyenv
			pylint
			pip
			kubectx
			jenv
			golang
			github
			gcloud
			emoji-clock
			dotenv
			cp
			common-aliases
			bun
			aws
			autoenv
			1password
			command-not-found
			colored-man-pages
			colorize
			direnv
		# dirhistory - will break opt + side arrow
			gh
			git-lfs
			per-directory-history
			redis-cli
			stripe
			zsh-interactive-cd
			zsh-navigation-tools
			urltools
			nvm
			mvn
			shrink-path
			screen
			scd
			safe-paste
			gpg-agent
			keychain
			globalias
			bun
			buf
			argocd
			azure
			alias-finder
			bgnotify
			bbedit
			asdf
			bazel
			dircycle
			doctl
			extract
		)
		# --- MANAGED BY ZSHRC-MANAGER CASK --- end
	  EOS

	  # save this file somewhere permanent (#{brew_prefix}/share/zshrc-manager/zsh-autocomplete.plugin.zsh
	  if !File.directory?(zshrc_manager_path)
		puts "Creating ~/.zshrc-manager directory... Password may be required."
		system_command "mkdir", args: ["-p", zshrc_manager_path], sudo: false
	  end


	  system_command "bash", args: [
		"-c",
		"echo '#{completions_config}' > '#{zshrc_manager_path}/zshrc-manager.plugin.zsh'"
	  ], sudo: false

	  puts "Zsh completions have been configured in #{zshrc_manager_path}/zshrc-manager.plugin.zsh."

	  # replace source $ZSH/oh-my-zsh.sh with source $ZSH/oh-my-zsh.sh && source $HOMEBREW_PREFIX/share/zshrc-manager/zshrc-manager.plugin.zsh

	if File.exist?(zshrc_path)
		zshrc_content = File.read(zshrc_path)
		if zshrc_content.include?('source $ZSH/oh-my-zsh.sh')

		  # Backup existing .zshrc if present
		  FileUtils.cp(zshrc_path, "#{zshrc_path}.backup.zshrc-manager")
		  puts "Backed up existing .zshrc to .zshrc.backup.zshrc-manager."

		  fixed = "source #{zshrc_manager_path}"+'/zshrc-manager.plugin.zsh && source $ZSH/oh-my-zsh.sh'

		  if zshrc_content.include?(fixed)
			puts "Zsh completions are already configured in #{zshrc_path}."
		  else
		  # Replace source $ZSH/oh-my-zsh.sh with source $ZSH/oh-my-zsh.sh && source $HOME/.zshrc-manager/zshrc-manager.plugin.zsh
		  zshrc_content.gsub!('source $ZSH/oh-my-zsh.sh', fixed)

		  File.open(zshrc_path, "w") do |file|
			file.puts zshrc_content
		  end
		end

		else
			odie "source $ZSH/oh-my-zsh.sh not found in #{zshrc_path}. Please install oh-my-zsh cask first."
		end

		# error if source $ZSH/oh-my-zsh.sh is not found

	else
		odie "The .zshrc file does not exist. Please install oh-my-zsh cask first."
	end



	  puts "Zsh completions have been configured in #{zshrc_path}. Restart your terminal to apply changes."
	end



	caveats <<~EOS
	  This cask manages your ~/.zshrc file to enable Homebrew and Zsh completions.
	  - Restart your terminal to apply the changes.
	  - To remove this setup, uninstall the cask:
		  brew uninstall --cask zshrc-manager
	EOS
  end
