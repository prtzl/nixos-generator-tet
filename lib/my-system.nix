{
  externalModules ? [ ],
  home-manager,
  lib,
  nixpkgs,
  version,
}:

let
  importModules =
    {
      type,
      system,
    }:
    lib.map (module: module.${type}.${system}.default) externalModules;
  mkSystem =
    {
      pillow,
      modules,
      specialArgs ? { },
    }:
    let
      system = pillow.hostPlatform;
    in
    lib.nixosSystem {
      inherit system;
      modules =
        modules
        ++ [
          home-manager.nixosModules.home-manager
          (
            { ... }:
            {
              system.stateVersion = version;
            }
          )
        ]
        ++ (importModules {
          type = "nixosModules";
          inherit system;
        });
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
        imports
        ++ (importModules {
          type = "homeManagerModules";
          system = pillow.hostPlatform;
        })
        ++ [
          (
            { ... }:
            {
              home.stateVersion = version;
            }
          )
        ];
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
