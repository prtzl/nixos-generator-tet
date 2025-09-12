{
  lib,
  nixpkgs,
  home-manager,
}:

let
  mkSystem =
    {
      pillow,
      modules,
      specialArgs ? { },
    }:
    lib.nixosSystem {
      system = pillow.hostPlatform;
      modules = modules ++ [
        home-manager.nixosModules.home-manager
      ];
      specialArgs = specialArgs // {
        inherit pillow;
      };
    };

  mkUser =
    pillow:
    {
      imports,
      name,
      uid ? 1000,
      initialHashedPassword ? null,
      extraGroups ? [ ],
      extraSpecialArgs ? { },
    }:
    {
      # Home Manager config for this user
      home-manager.users.${name} = {
        inherit imports;
      };

      # Add shared special args (applies globally, but you can merge all users' needs here)
      home-manager.extraSpecialArgs = {
        inherit pillow;
      }
      // extraSpecialArgs;

      # NixOS user account
      users.users.${name} = {
        isNormalUser = true;
        inherit uid name extraGroups;
        initialHashedPassword = initialHashedPassword;
      };
    };
in
{
  inherit mkSystem mkUser;
}
