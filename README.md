# nix-config

OhMyMndy's Nix (OS) configs!

## Use on a already configured machine

```bash
sudo nixos-rebuild switch --flake .
```

## Test new configuration in VM

```bash
just vm
```

## Update flake

```bash
just update
```

## Reformat all .nix files

```bash
just format
```

## Delete older revisions

```bash
just clean
```
