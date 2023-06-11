class Tftab < Formula
    desc "Runs terraform fmt but using tabs instead of spaces."
    homepage "https://github.com/nuggxyz/homebrew-tap"

	version "0.0.12"

    depends_on "tfenv"

    url "https://github.com/nuggxyz/tftab", :using => :git, :branch => "main", :release => "#{version}"

	def install
		lib.install "tftab.sh"
		bin.install_symlink lib/"tftab.sh" => "tftab"
	  end

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



	# livecheck do
	# 	url :stable
	# 	regex(/^tftab[._-]v?(\d+(?:\.\d+)+)$/i)
	# 	strategy :github_releases do |json, regex|
	# 	  json.map do |release|
	# 		next if release["draft"] || release["prerelease"]

	# 		match = release["tag_name"]&.match(regex)
	# 		next if match.blank?

	# 		{
	# 		  version: match[1],
	# 		  url: release["html_url"]
	# 		}
	# 	  end.compact
	# 	end
	#   end

	#   version livecheck



	# # version "0.0.12"
	# # sha256 "102157dcebc168744972a3433aea934aaaabd1a22c015c35dbdb68c7dbcbfce4"
