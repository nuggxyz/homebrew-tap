class Timebox < Formula
	include Language::Python::Virtualenv

	desc "Timeboxing utility for Things 3 in the macOS menu bar"
	homepage "https://github.com/walteh/timebox"
	url "https://github.com/walteh/timebox/archive/refs/tags/v0.6.0.tar.gz"
	sha256 "0a74e280781c13495210f88fa87407246724b6ef4fafb2f5febaf4ab7d97c8df"
	license "MIT"

	depends_on "python"

	def install
		# Create virtualenv with pip
		virtualenv_create(libexec, "python3", system_site_packages: false, with_pip: true)

		# Install the package
		system libexec/"bin/pip", "install", "."

		# Create the executable script
		(bin/"timebox").write_env_script libexec/"bin/timebox", PATH: "#{libexec}/bin:${PATH}"
	end

	service do
	  run [opt_bin/"timebox"]
	  keep_alive true
	  log_path var/"log/timebox.log"
	  error_log_path var/"log/timebox.log"
	  working_dir HOMEBREW_PREFIX
	  environment_variables HOMEBREW_LOGS: var/"log"
	end
end
