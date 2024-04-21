vm:
    nixos-rebuild build --flake .
    rm -rf *.qcow2
    time nixos-rebuild build-vm --flake .

update:
    nix flake lock --update-input nixpkgs .
    time nix flake update .

clean:
    # --dry-run
    time sudo nix-collect-garbage --delete-older-than 30d

switch:
    time sudo nixos-rebuild switch --flake .

format:
    nixpkgs-fmt .

garbage:
    time nix-env --delete-generations 14d
    time nix-store --gc