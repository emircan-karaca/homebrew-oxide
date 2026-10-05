# Homebrew Cask sablonu. `scripts/release.sh` 0.3.0 ve 222726cc65aa3800964e8f92310663779670dcf19b5f8efb9535565d0985e60e'yi doldurup
# github.com/emircan-karaca/homebrew-oxide/Casks/oxide.rb olarak push eder.
#
# NEDEN CASK, FORMULA DEGIL
# -------------------------
# Formula kaynaktan derler ya da "bottle" dagitir; ikisi de ikiliyi Homebrew'un
# eline verir ve imza/entitlement zincirini (Developer ID + hardened runtime +
# notarization) kirar — `cargo install`in imzayi dusurmesiyle ayni sinif sorun
# (olculdu, bkz. scripts/install.sh). Cask notarize edilmis DMG'yi oldugu gibi
# kurar, yeniden imzalamaz.
#
# `auto_updates` YOK: `oxide self-update` Homebrew kurulumuna dokunmuyor
# (Caskroom'u gorunce `brew upgrade --cask oxide` diyor), yani paketi yalnizca
# brew degistirir ve brew'un kaydi hep dogru kalir.
cask "oxide" do
  version "0.3.0"
  sha256 "222726cc65aa3800964e8f92310663779670dcf19b5f8efb9535565d0985e60e"

  url "https://github.com/emircan-karaca/oxide-releases/releases/download/v#{version}/Oxide-#{version}.dmg"
  name "Oxide"
  desc "Daemonless container engine built on Virtualization.framework"
  homepage "https://github.com/emircan-karaca/oxide-releases"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  # Info.plist LSMinimumSystemVersion 13.0 (Ventura). Dogrulanan: macOS 26.
  depends_on macos: :ventura

  app "Oxide.app"
  binary "#{appdir}/Oxide.app/Contents/Helpers/oxide"
  bash_completion "#{appdir}/Oxide.app/Contents/Resources/completions/oxide.bash", target: "oxide"
  zsh_completion "#{appdir}/Oxide.app/Contents/Resources/completions/_oxide"
  fish_completion "#{appdir}/Oxide.app/Contents/Resources/completions/oxide.fish"

  zap trash: "~/Library/Application Support/oxide"

  caveats <<~EOS
    Oxide needs no daemon: nothing runs until you start a container.
    Installed with Homebrew, upgrade with
      brew upgrade --cask oxide
    (`oxide self-update` detects the Homebrew install and defers to brew.)
  EOS
end
