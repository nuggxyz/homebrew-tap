cask "oh-my-zsh" do
	version "1.0.0"
	sha256 :no_check

	url "file:///dev/null" # No file to download
	name "Oh My Zsh"
	desc "Framework for managing your Zsh configuration"
	homepage "https://ohmyz.sh/"

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
	  backup_path = "#{zshrc_path}.backup"

	  # Backup existing .zshrc if present
	  if File.exist?(zshrc_path)
		File.rename(zshrc_path, backup_path)
		puts "Backed up existing .zshrc to #{backup_path}."
	  end

	  # Install new .zshrc from Oh My Zsh template
	  template_path = File.join(oh_my_zsh_dir, "templates", "zshrc.zsh-template")
	  FileUtils.cp(template_path, zshrc_path)
	  puts "Installed new .zshrc from Oh My Zsh template."

	  puts "Oh My Zsh installation complete! Restart your terminal or source ~/.zshrc to apply changes."
	end

	uninstall_postflight do
	  oh_my_zsh_dir = File.expand_path("~/.oh-my-zsh")
	  zshrc_path = File.expand_path("~/.zshrc")
	  backup_path = "#{zshrc_path}.backup"

	  # Remove Oh My Zsh directory
	  if File.exist?(oh_my_zsh_dir)
		FileUtils.rm_rf(oh_my_zsh_dir)
		puts "Removed Oh My Zsh directory: #{oh_my_zsh_dir}."
	  end

	  # Restore original .zshrc if backup exists
	  if File.exist?(backup_path)
		File.rename(backup_path, zshrc_path)
		puts "Restored original .zshrc from backup."
	  else
		puts "No backup .zshrc found. Your .zshrc has not been restored."
	  end
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
