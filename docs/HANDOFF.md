# Handoff — `~/.config` cleanup, 2026-10-05

Durable record of a session that removed accumulated cruft from `~/.config` (and three
dotfiles outside it). The flake itself was **not** modified — `git status` was clean before
and after. This doc is the only file this session adds.

## Goal

The user, working in COSMIC Terminal, said: "i think i have lots of trash in the config,
can you clean them up?" Scope started at `.hm-backup` files and empty COSMIC dirs, then the
user chose to widen it to a broad `~/.config` audit (reported before deleting).

## Decisions

- **`.hm-backup` files are home-manager's pre-migration copies.** Every one corresponded to an
  app deliberately retired from the flake. Four of five were recoverable verbatim from git
  history, which is what made deletion safe rather than destructive.
- **An app's presence is judged by the flake, not by the live system.** The live system is the
  Aug 4→Oct 5 generation while the flake has commits through Oct 5 12:20, so `command -v`
  returning nothing proves nothing about intent. Two near-miss deletions followed from this:
  - the 5 browser dirs (`BraveSoftware`, `chromium`, `microsoft-edge`, `opera`, `vivaldi`) are
    **not** trash — each holds `NativeMessagingHosts/com.anthropic.claude_code_browser_extension.json`
    installed by flake-declared `claude-code`;
  - `~/.config/openchamber` is **not** an app dir — it is VSCodium extension
    `FedaykinDev.openchamber`'s config. Both were pulled from the delete list.
- **"0 files" ≠ empty.** `celluloid`, `lf`, `mpv`, `helix`, `git`, `fontconfig`, `systemd`,
  `environment.d` are home-manager **symlink** dirs (`find -type f` skips symlinks). Kept.
  Use `find -type f -o -type l` when judging these.
- **The safety archive is slimmed.** A full tar of the deletions was 616 MB — as large as what
  it replaced, because app caches don't compress. It was rebuilt keeping only files < 128 KB
  (configs), dropping 689 files that held 647 MB of caches, `.asar` bundles, LSP indexes and
  clipboard-history DBs.

## Files touched

**No repo files.** All changes are under `$HOME`.

Removed — 8 `.hm-backup` files (now zero under `$HOME`):
`~/.config/{kitty/kitty.conf,kitty/session.conf,ranger/rc.conf,zellij/config.kdl,mimeapps.list}`,
`~/.config/cosmic/com.system76.CosmicTerm/v1/use_bright_bold`,
`~/.local/share/applications/mimeapps.list`, `~/.gtkrc-2.0`, `~/.tmux.conf`.

Removed — 30 orphan config dirs + 12 empty COSMIC dirs + 10 dead Thunderbird launchers:
`~/.config/{discord,vesktop,cursor-clip,io.hoppscotch.desktop,intelephense,obsidian,Postman,bruno,GIMP,calibre,vlc,copyq,superfile,kate,geeqie,transmission,fragments,haruna,qalculate,warp-terminal,doom.bak,app.yaak.desktop,google-chrome-for-testing,epiphany,nautilus,plasma-workspace,qtvirtualkeyboard,rclone}`,
`~/.config/zellij/`, `~/.config/cosmic/com.system76.CosmicViewer/v1`.

Kept deliberately: `~/.config/google-chrome-headless` (explicit user exception; 331 MB) and
`~/.config/openchamber`.

## Verified vs unverified

**Verified:** all 30 dirs gone; zero `.hm-backup` under `$HOME`; zero Thunderbird launchers;
kept items still present (`google-chrome-headless`, `openchamber`, `cosmic`, `herdr/plugins`,
`VSCodium`); slim archive passes `gzip -t` and its 18 373 entries exactly match the
`-size -128k` file count; repo `git status` clean.

**Unverified:** nothing was activated — no rebuild was run, and none was needed for these
changes. The `~/.config/gtk-4.0/assets` and similar zero-file dirs were left alone as COSMIC
or app-generated.

**Ambiguity left standing:** the user's answer for the orphan-app pile was the custom text
`don delete google-chrome-headless`. It was interpreted as *keep* `google-chrome-headless` and
delete the rest (natural grammar, less destructive). If the opposite was meant:
`rm -rf ~/.config/google-chrome-headless`.

## Next step

Three commits are newer than the live system generation (2026-10-05 06:41), so the archive
tooling they add is **not** in `PATH` — `7zz`, `zip`, `unrar` and `ffmpegthumbnailer` are all
absent, while `unzip` and `celluloid` resolve from
`/etc/profiles/per-user/ivan/bin`:

    19de6d3  fix(desktop): Celluloid gets the video MIME types …
    265d44a  docs(readme): the swap entry moved into the host config …
    768ba4a  feat(tools): archives and video thumbnails — 7zz, zip/unzip, unrar, ffmpegthumbnailer

Activate with:

    sudo nixos-rebuild switch --flake .#spica

Then confirm with `command -v 7zz zip unrar ffmpegthumbnailer`.

Recovery net: `~/.local/state/config-trash-2026-10-05-batch2-slim.tar.gz` (87 MB) and
`…-2026-10-05.tar.gz` (7.8 KB). Restore with `tar xzf <archive> -C ~`. Both can be deleted
once the cleanup has proven itself; there is no other copy of the deleted caches.
