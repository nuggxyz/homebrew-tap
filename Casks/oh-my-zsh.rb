cask "oh-my-zsh" do
	version "1.0.0"

	name "Oh My Zsh"
	desc "Framework for managing your Zsh configuration"
	homepage "https://ohmyz.sh/"

		# https://apple.stackexchange.com/a/351612
		url "file:///dev/null"
		sha256 "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"

	postflight do
	  oh_my_zsh_dir = File.expand_path("~/.oh-my-zsh")

	  # Clone Oh My Zsh repository if not already installed
	  unless File.exist?(oh_my_zsh_dir)
		system_command "git",
					   args: ["clone", "https://github.com/ohmyzsh/ohmyzsh.git", oh_my_zsh_dir],
					   sudo: false
		puts "Cloned Oh My Zsh into #{oh_my_zsh_dir}."
	  else
		puts "Oh My Zsh is already installed at #{oh_my_zsh_dir}."
	  end

	  zshrc_path = File.expand_path("~/.zshrc")

	  # Backup existing .zshrc if present
	  if File.exist?(zshrc_path)
		puts "The .zshrc file already exists."
	  else
			  # Install new .zshrc from Oh My Zsh template
			  template_path = File.join(oh_my_zsh_dir, "templates", "zshrc.zsh-template")
			  FileUtils.cp(template_path, zshrc_path)
			  puts "Installed new .zshrc from Oh My Zsh template."
	  end

	  # Check if existing .zshrc contains the Oh My Zsh source line
	  if File.exist?(zshrc_path)
		zshrc_content = File.read(zshrc_path)
		unless zshrc_content.include?('source $ZSH/oh-my-zsh.sh')
		  FileUtils.cp(zshrc_path, "#{zshrc_path}.backup")
		  puts "Backed up existing .zshrc to .zshrc.backup."
		  File.open(zshrc_path, "a") do |file|
			file.puts 'source $ZSH/oh-my-zsh.sh'
		  end
		  puts "Added Oh My Zsh source line to existing .zshrc"
		else
		  puts "Oh My Zsh source line already exists in .zshrc"
		end
	  end

	  puts "Oh My Zsh installation complete! Restart your terminal or source ~/.zshrc to apply changes."
	end

	caveats <<~EOS
	  Oh My Zsh has been installed in your home directory (~/.oh-my-zsh).
	  A new .zshrc has been set up from the Oh My Zsh template.
	  Your old .zshrc has been backed up to .zshrc.backup.

	  To apply the changes, restart your terminal or run:
		  source ~/.zshrc

	  To uninstall Oh My Zsh, run:
		  brew uninstall --cask oh-my-zsh
	EOS
  end
