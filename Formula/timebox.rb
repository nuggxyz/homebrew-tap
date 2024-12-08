class Timebox < Formula
	include Language::Python::Virtualenv

	desc "Timeboxing utility for Things 3 in the macOS menu bar"
	homepage "https://github.com/walteh/timebox"
	url "https://github.com/walteh/timebox/archive/refs/tags/v0.6.0.tar.gz"
	sha256 "0a74e280781c13495210f88fa87407246724b6ef4fafb2f5febaf4ab7d97c8df"
	license "MIT"

	depends_on "python@3.12"

	resource "rumps" do
	  url "https://files.pythonhosted.org/packages/b2/2c/f0628da8997f6f24fb1a166d38c47f1a8da53e52d27c7cd78b13fc8a8d67/rumps-0.4.0.tar.gz"
	  sha256 "933ce1ab2c6feb18f037cb9b23c5795936f6ba913bea9a416238b8c9c1d89c3e"
	end

	resource "things.py" do
	  url "https://files.pythonhosted.org/packages/72/ce/2e19c6c04e08a21f7f5e3d6ce7feb3f84c26f413e201c0096bdf5e15d81d/things.py-0.1.1.tar.gz"
	  sha256 "b58c8c6a3b90ee85a5f7141c7d3f6f7f38e7c5510d5c3998f3c0e3c1b2dd3a5"
	end

	resource "watchdog" do
	  url "https://files.pythonhosted.org/packages/95/a6/d6ef450393dac5734c63c40a131f66808d2e6f59f6165ab38c98fbe4e6ec/watchdog-3.0.0.tar.gz"
	  sha256 "4d98a320595da7a7c5a18fc48cb633c2e73cda78f93cac2ef42d42bf609a33f9"
	end

	def install
	  virtualenv_install_with_resources

	  # Ensure log directory exists
	  (var/"log").mkpath
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
