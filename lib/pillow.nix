{
  externalModules ? [ ],
  inputs,
  lib,
  version,
}:

let
  importModules =
    type:
    lib.concatMap (
      module: if (module ? ${type}) then [ module.${type}.default ] else [ ]
    ) externalModules;

in
{
  makePillowArgs =
    {
      edition,
      hasGUI,
      host,
      hostPlatform,
      settings ? { },
      useDefaults ? true,
    }:
    {
      inherit
        edition
        hasGUI
        hostPlatform
        settings
        useDefaults
        ;
      # my attempt at forcing user to declare necessary host fields
      host = host // {
        name = host.name;
        interfaces = host.interfaces;
      };
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
          inputs.home-manager.nixosModules.home-manager
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

              # Create group where all members (privileged) have access to /etc/nixos where the config SHOULD be placed
              users.groups.nixos-editors = { };
              systemd.tmpfiles.rules = [
                "d /etc/nixos 0770 root nixos-editors -"
              ];
            }
          )
        ]
        ++ (lib.optionals pillow.useDefaults [ ../profiles/system ])
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
      initialHashedPassword ? null,
      extraGroups ? [ ],
      extraSpecialArgs ? { },
      # since this is for me I want sensible defaults for me
      personal ? true,
      privileged ? true,
    }:
    { config, lib, ... }:
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

      groupMapping = import ../lib/groupMapping.nix { inherit config lib; };

      # Sum together base groups and priviledged groups (with dynamic)
      allowedGroups = lib.unique (
        groupMapping.baseGroups
        ++ (if privileged then groupMapping.privilegedGroups else [ ])
        ++ groupMapping.dynamicGroups
      );

      allGroups = lib.unique (allowedGroups ++ extraGroups);
    in
    {
      config = {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;

          users.${name} = {
            imports = homeImports;
          };

          extraSpecialArgs = {
            pillow = pillow // {
              inherit personal;
            };
          }
          // extraSpecialArgs;
        };

        users.users.${name} = {
          extraGroups = allGroups;
          initialHashedPassword = initialHashedPassword;
          isNormalUser = true;
        };
      };
    };
}
