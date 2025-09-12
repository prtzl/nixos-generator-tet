{
  lib,
  nixpkgs,
  home-manager,
  homeModules ? [ ],
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
    let
      homeImports =
        imports ++ lib.map (module: module.homeManagerModules.${pillow.hostPlatform}.default) homeModules;
    in
    {
      # Home Manager config for this user
      home-manager.users.${name} = {
        imports = homeImports;
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
