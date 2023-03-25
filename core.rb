class Core < Formula:
    desc "Core utilities"
    homepage "    url "
    version "2023-01-01"

    depends_on :xcode

    depends_on "just"

    def install:
        system "make", "install", "PREFIX=#{prefix}"
    end

__END__