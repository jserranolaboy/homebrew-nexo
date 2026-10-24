# Nexo Homebrew tap

Experimental preview releases of [Nexo](https://github.com/jserranolaboy/nexo), for macOS 15 or later on Apple Silicon and Intel Macs.

## Install

Review the [cask](Casks/nexo@preview.rb) and its pinned release before installing:

```sh
brew install --cask jserranolaboy/nexo/nexo@preview
```

This fully qualified command selects only this cask from `jserranolaboy/homebrew-nexo`. Homebrew verifies the download against the pinned SHA-256 checksum.

**This preview is ad-hoc signed, not Developer ID signed or notarized.** macOS Gatekeeper may prevent it from opening. Neither this tap nor its checks disable or bypass those protections. A correct checksum is not proof of notarization or permission to run the app.

Close Nexo and keep an independent backup before replacing an existing installation. This cask installs only `Nexo.app`; it does not migrate or remove workspace data. To remove the app while preserving its workspace data and backups:

```sh
brew uninstall --cask jserranolaboy/nexo/nexo@preview
```

There is deliberately no `zap` stanza.

## Validation and updates

The workflow separately reports syntax/style/download-integrity checks and Homebrew's full new-cask audit. The audit's actual result is retained, including signing or eligibility failures; a green download check does not mean the audit passed. Checks download and inspect the package but do not install or launch Nexo.

Update the fixed release URL, version/build and checksum only after the exact release asset has been published and independently verified. Do not use `latest`, `sha256 :no_check`, installation hooks, data-removal commands, or security-bypass options.
