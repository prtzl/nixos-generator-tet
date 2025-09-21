{
  externalModules ? [ ],
  inputs,
  lib,
  version,
}:

let
  home-manager = inputs.home-manager;
  importModules =
    type:
    lib.concatMap (
      module: if (module ? ${type}) then [ module.${type}.default ] else [ ]
    ) externalModules;
in
{
  makePillowArgs =
    {
      buildPlatform,
      edition,
      hasGUI,
      hostPlatform,
      host,
    }:
    {
      inherit
        buildPlatform
        edition
        hasGUI
        host
        hostPlatform
        ;
      onHardware = (edition == "workstation" || edition == "virtual");
    };

  pillowSystem =
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

              nixpkgs.overlays = [
                (final: prev: {
                  pkgs-unfree = import inputs.nixpkgs {
                    inherit system;
                    config.allowUnfree = true;
                  };
                  pkgs-unstable = import inputs.nixpkgs-unstable {
                    inherit system;
                    config.allowUnfree = true;
                  };
                })
              ];
            }
          )
        ]
        ++ (importModules "nixosModules");
      specialArgs = specialArgs // {
        inherit pillow;
      };
    };

  pillowUser =
    pillow:
    {
      imports,
      name,
      uid ? 1000,
      initialHashedPassword ? null,
      extraGroups ? [ ],
      extraSpecialArgs ? { },
      personal ? true,
    }:
    let
      homeImports =
        imports
        ++ [
          (
            { ... }:
            {
              home.stateVersion = version;
            }
          )
        ]
        ++ (importModules "homeManagerModules");
    in
    {
      home-manager = {
        useGlobalPkgs = true; # <--- IMPORTANT: Uses nixpkgs from nixos
        useUserPackages = true;

        # Home Manager config for this user
        users.${name} = {
          imports = homeImports;
        };

        # Add shared special args (applies globally, but you can merge all users' needs here)
        extraSpecialArgs =
          let
            pillow_local = pillow // {
              inherit personal;
            };
          in
          {
            pillow = pillow_local;
          }
          // extraSpecialArgs;
      };

      # NixOS user account
      users.users.${name} = {
        isNormalUser = true;
        inherit uid name extraGroups;
        initialHashedPassword = initialHashedPassword;
      };
    };
}
