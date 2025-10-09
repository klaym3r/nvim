# nvim-config v2.0

Config for neovim based on [NvChad](https://github.com/NvChad/NvChad).

## Dependencies

```bash
sudo pacman -S nvim prettier omnisharp black ktlint
```

## Installation

```bash
cp -r ~/.config/nvim ~/.config/nvim-backup
cp -r ~/.local/state/nvim ~/.local/state/nvim-backup
cp -r ~/.local/share/nvim ~/.local/share/nvim-backup
cd ~/.config
git clone https://github.com/klaym3r/nvim ~/.config/nvim && nvim
```

Run `:MasonInstallAll`

Delete the `.git` folder from nvim folder.

## Update

Run `Lazy sync` command

## Uninstall

```bash
rm -rf ~/.config/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.local/share/nvim
```
