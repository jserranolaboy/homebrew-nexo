cask "nexo@preview" do
  version "0.4.1,12"
  sha256 "86b593c05a371456396c8713034c2daae5956e968a547eae225b117b1c86472f"

  url "https://github.com/jserranolaboy/nexo/releases/download/v#{version.csv.first}-preview.2/Nexo-#{version.csv.first}-#{version.csv.second}-universal.dmg"
  name "Nexo Preview"
  desc "Events, attendance, volunteer coordination, and documents"
  homepage "https://github.com/jserranolaboy/nexo"

  livecheck do
    url :url
    regex(/\ANexo-(\d+\.\d+\.\d+)-([1-9]\d*)-universal\.dmg\z/i)
    strategy :github_releases do |json, regex|
      next [] unless json.is_a?(Array)

      json.flat_map do |release|
        next [] unless release.is_a?(Hash)
        next [] if release["draft"] != false || release["prerelease"] != true
        next [] if release["published_at"].to_s.empty?

        tag = release["tag_name"].to_s.match(/\Av(\d+\.\d+\.\d+)-preview\.[1-9]\d*\z/)
        next [] unless tag
        next [] unless release["assets"].is_a?(Array)

        asset_prefix = "https://github.com/jserranolaboy/nexo/releases/download/#{release["tag_name"]}/"
        release["assets"].filter_map do |asset|
          next unless asset.is_a?(Hash)
          next if asset["state"] != "uploaded"
          next unless asset["size"].is_a?(Integer)
          next unless asset["size"].positive?

          match = asset["name"].to_s.match(regex)
          next unless match
          next if match[1] != tag[1]

          next if asset["browser_download_url"] != "#{asset_prefix}#{asset["name"]}"

          "#{match[1]},#{match[2]}"
        end
      end
    end
  end

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
