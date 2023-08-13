# Defines the formula for the tftab brew package
class Tftab < Formula

	desc "Runs terraform fmt but using tabs instead of spaces."

	# The homepage for the package, where to find documentation, etc.
	homepage "https://github.com/walteh/tftab"

	# The version of the package that this formula will install
	version ""

	# List of dependencies needed for this package
	depends_on "tfenv"

	# The URL to the source code of the package. The :using => :git parameter tells Homebrew to use Git to get the source code.
	# :branch => "main" specifies the branch to clone.
	# :release => "#{version}" specifies the release to clone
	url "https://github.com/walteh/tftab", :using => :git, :branch => "main", :release => "#{version}"

	# The livecheck block is used to check for newer versions of the package than what is defined in the formula.
	# The url :stable symbol will cause livecheck to check the stable url for the formula.
	# The regex is used to parse version numbers from strings. Here it looks for a string that starts with an optional 'v' followed by one or more digits separated by periods.
	livecheck do
	  url :stable
	  regex(/^v?(\d+(?:\.\d+)+)$/i)
	end

	# The install block is called when the user runs 'brew install'.
	# Here it installs the 'tftab.sh' script and creates a symlink to it in the bin directory.
	def install
	  lib.install "tftab.sh"
	  bin.install_symlink lib/"tftab.sh" => "tftab"
	end

	# The test block is called when the user runs 'brew test'.
	# This block should contain a test that checks the functionality of the installed software.
	# Here it writes a small terraform script to a file, runs 'tftab' on it, and then checks that the file contains a tab character.
	test do
	  (testpath/"test.tf").write <<~EOS
		resource "aws_s3_bucket" "bucket" {
		  bucket = "bucket"
		  acl    = "private"
		}
	  EOS

	  system "#{bin}/tftab", "#{testpath}/test.tf"
	  assert_match /\t/, (testpath/"test.tf").read
	end
  end
