class Vfkit < Formula
  desc "Command line hypervisor using Apple's Virtualization Framework"
  homepage "https://github.com/crc-org/vfkit"
  url "https://github.com/crc-org/vfkit.git",
      tag: "v0.0.4",
      revision: "41f5a6e906acfa07e5ed49b5da7c67ae84209144"
  license "Apache-2.0"
  head "https://github.com/crc-org/vfkit.git", branch: "main"

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"
    ENV["CGO_CFLAGS"] = "-mmacosx-version-min=11.0"
    ENV["GOOS"]="darwin"
    system "go", "build", "-o", "out/vfkit", "./cmd/vfkit"
    bin.install "out/vfkit"
  end

  test do
    # test version
    version_output = shell_output("#{bin}/vfkit --version 2>&1").strip
    assert_match(/vfkit version: #{version}/, version_output)

    # start a VM with non-existing kernel
    lines =  shell_output("#{bin}/vfkit --kernel foo --initrd bar --kernel-cmdline baz 2>&1", 1).strip.split(/\r?\n|\r/)
    assert_match(/open foo: no such file or directory/, lines.last)
  end
end

