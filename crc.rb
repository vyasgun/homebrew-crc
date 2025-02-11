class Crc < Formula
  desc "Run a minimal OpenShift cluster on your local machine"
  homepage "https://crc.dev"
  url "https://github.com/crc-org/crc.git",
      tag:      "v2.46.0",
      revision: "8f40e8421e4734e7869adce7b18057b3ddb65a87"
  license "Apache-2.0"
  head "https://github.com/crc-org/crc.git", branch: "main"

  depends_on "go" => :build
  depends_on "crc-admin-helper"
  depends_on "vfkit"

  def install
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    vfkit_path = Formula["vfkit"].bin
    admin_helper_path = Formula["crc-admin-helper"].bin
    build_params=buildpath/"build-params.json"
    build_params.write <<~EOS
      [
        {
          "name": "vfkit",
          "path": "#{vfkit_path}/vfkit"
        },
        {
          "name": "crc-admin-helper-darwin",
          "path": "#{admin_helper_path}/crc-admin-helper"
        }
      ]
    EOS
    system "make", "macos-release-binary", "CRC_BUILD_PARAMS_PATH=#{build_params}"
    bin.install "out/macos-#{arch}/crc"
  end

  test do
    assert_match(/^crc version: #{version}/, shell_output("#{bin}/crc version"))

    # Should error out as running crc requires root
    status_output = shell_output("#{bin}/crc setup 2>&1", 1)
    assert_match "Unable to set ownership", status_output
  end
end
