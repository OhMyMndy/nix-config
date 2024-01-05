vm:
    nixos-rebuild build --flake .
    rm -rf *.qcow2
    time nixos-rebuild build-vm --flake .

update:
    nix flake lock --update-input nixpkgs .
    time nix flake update .

clean:
    time nix-collect-garbage --delete-older-than 30d --dry-run

switch:
    time sudo nixos-rebuild switch --flake .