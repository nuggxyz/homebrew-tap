class Tftab < Formula
    desc "runs terraform fmt but using tabs instead of spaces"
    homepage "https://github.com/nuggxyz/homebrew-tap"
    version "v0.0.5"
  
    bottle :unneeded
  
    depends_on "tfenv"
  
    on_macos do
      if Hardware::CPU.intel?
        url "https://github.com/nuggxyz/tftab/releases/download/#{version}/tftab-#{version}.sh", :using => :nounzip
        sha256 "macos-intel-sha256-here"
      else
        url "https://github.com/nuggxyz/tftab/releases/download/#{version}/tftab-#{version}.sh", :using => :nounzip
        sha256 "macos-arm-sha256-here"
      end
    end
  
    on_linux do
      url "https://github.com/nuggxyz/tftab/releases/download/#{version}/tftab-#{version}.sh", :using => :nounzip
      sha256 "linux-sha256-here"
    end
  
    def install
      lib.install "tftab.sh"
      bin.install_symlink lib/"tftab.sh" => "tftab"
    end
  
    test do
      system "#{bin}/tftab", "--version"
    end
  end
  

