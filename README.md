# nix-config
OhMyMndy's Nix (OS) configs!



## Use on a already configured machine

```bash
sudo nixos-rebuild switch --flake .
```

## Test new configuration in VM

```bash
sudo nixos-rebuild build --flake .
sudo rm -rf *.qcow2
sudo nixos-rebuild build-vm --flake .
```


## Update flake
```bash
nix flake lock --update-input nixpkgs .
time nix flake update .
```

## Reformat all .nix files

```bash
nixpkgs-fmt .
```