cask "zshrc-manager" do
	version "1.0.0"
	sha256 :no_check

	depends_on cask: "zsh-completions"
	depends_on formula: "zsh-autosuggestions"
	depends_on formula: "zsh-syntax-highlighting"

	url "file:///dev/null" # No actual file; this is for configuration
	name "ZshRC Manager"
	desc "Manages Zsh configuration, including completions and Homebrew integration"
	homepage "https://example.com"

	postflight do
	  zshrc_path = File.expand_path("~/.zshrc")
	  brew_prefix = `brew --prefix`.strip

	  completions_config = <<~EOS
		# --- MANAGED BY ZSHRC-MANAGER CASK --- start
		source #{brew_prefix}/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
		source #{brew_prefix}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
		if type brew &>/dev/null; then
		  FPATH=#{brew_prefix}/share/zsh-completions:$FPATH
		  FPATH=#{brew_prefix}/share/zsh/site-functions:$FPATH
		  autoload -Uz compinit
		  compinit
		fi
		# --- MANAGED BY ZSHRC-MANAGER CASK --- end
	  EOS

	  # Create or update ~/.zshrc
	  if File.exist?(zshrc_path)
		unless File.read(zshrc_path).include?("--- MANAGED BY ZSHRC-MANAGER CASK --- start")
		  File.open(zshrc_path, "a") { |file| file.puts completions_config }
		end
	  else
		File.write(zshrc_path, completions_config)
	  end

	  puts "Zsh completions have been configured in #{zshrc_path}. Restart your terminal to apply changes."
	end

	uninstall_postflight do
	  zshrc_path = File.expand_path("~/.zshrc")

	  if File.exist?(zshrc_path)
		# Remove the Homebrew Zsh completions setup block
		new_content = File.readlines(zshrc_path).reject do |line|
		  line.include?("--- MANAGED BY ZSHRC-MANAGER CASK ---") ||
		  line.include?("FPATH") ||
		  line.include?("compinit")
		end

		File.write(zshrc_path, new_content.join)
		puts "Removed Zsh completions configuration from #{zshrc_path}."
	  end
	end

	caveats <<~EOS
	  This cask manages your ~/.zshrc file to enable Homebrew and Zsh completions.
	  - Restart your terminal to apply the changes.
	  - To remove this setup, uninstall the cask:
		  brew uninstall --cask zshrc-manager
	EOS
  end
