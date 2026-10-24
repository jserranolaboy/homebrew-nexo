cask "nexo@preview" do
  version "0.4.1,12"
  sha256 "86b593c05a371456396c8713034c2daae5956e968a547eae225b117b1c86472f"

  url "https://github.com/jserranolaboy/nexo/releases/download/v0.4.1-preview.2/Nexo-0.4.1-12-universal.dmg"
  name "Nexo Preview"
  desc "Events, attendance, volunteer coordination, and documents"
  homepage "https://github.com/jserranolaboy/nexo"

  depends_on arch: [:arm64, :x86_64]
  depends_on macos: :sequoia

  app "Nexo.app"

  caveats <<~EOS
    This experimental preview is ad-hoc signed, not Developer ID signed or notarized.
    macOS Gatekeeper may prevent it from opening. This cask does not bypass security checks.
    Close Nexo and keep an independent backup before replacing an existing installation.
    Uninstalling the cask leaves Nexo workspace data and backups untouched.
  EOS
end
