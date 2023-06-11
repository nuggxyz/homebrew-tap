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
