class Timebox < Formula
	include Language::Python::Virtualenv

	desc "Timeboxing utility for Things 3 in the macOS menu bar"
	homepage "https://github.com/walteh/timebox"
	url "https://github.com/walteh/timebox/archive/refs/tags/v0.6.1.tar.gz"
	sha256 "6430daf924dfb7c9aa6e67da93b2dfa7b4478d500e9de52a0a98fa279cdf3b1f"
	license "MIT"

	depends_on "python3"

	# resourcescreated by running in root walteh/timebox:
	# 	pip install strip-tags homebrew-pypi-poet
	#   poet -f timebox

	resource "pyobjc-core" do
	  url "https://files.pythonhosted.org/packages/5d/07/2b3d63c0349fe4cf34d787a52a22faa156225808db2d1531fe58fabd779d/pyobjc_core-10.3.2.tar.gz"
	  sha256 "dbf1475d864ce594288ce03e94e3a98dc7f0e4639971eb1e312bdf6661c21e0e"
	end

	resource "pyobjc-framework-Cocoa" do
	  url "https://files.pythonhosted.org/packages/39/41/4f09a5e9a6769b4dafb293ea597ed693cc0def0e07867ad0a42664f530b6/pyobjc_framework_cocoa-10.3.2.tar.gz"
	  sha256 "673968e5435845bef969bfe374f31a1a6dc660c98608d2b84d5cae6eafa5c39d"
	end

	resource "rumps" do
	  url "https://files.pythonhosted.org/packages/b2/e2/2e6a47951290bd1a2831dcc50aec4b25d104c0cf00e8b7868cbd29cf3bfe/rumps-0.4.0.tar.gz"
	  sha256 "17fb33c21b54b1e25db0d71d1d793dc19dc3c0b7d8c79dc6d833d0cffc8b1596"
	end

	resource "things.py" do
	  url "https://files.pythonhosted.org/packages/09/bf/dbba75d9a4e38de0d91dff8b1d0aacd754df4080d7c17eae3a1640a4d17f/things.py-0.0.15.tar.gz"
	  sha256 "95ee8602083cf8b9fde59f64486fa6f3d13b1f84bd565c60dd77599c07e7ea16"
	end

	resource "watchdog" do
	  url "https://files.pythonhosted.org/packages/db/7d/7f3d619e951c88ed75c6037b246ddcf2d322812ee8ea189be89511721d54/watchdog-6.0.0.tar.gz"
	  sha256 "9ddf7c82fda3ae8e24decda1338ede66e1c99883db93711d8fb941eaa2d8c282"
	end

	def install
	  virtualenv_install_with_resources
	end

	test do
	  false
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
