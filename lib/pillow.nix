{
  inputs,
  lib,
  version,
}:

let
  overlays = [
    # inputs.waybar.overlays.waybar
    # inputs.hyprland.overlays.hyprland-packages
    # (self: super: {
    #   waybar = super.waybar.overrideAttrs (old: {
    #     doCheck = false;
    #     mesonFlags = (old.mesonFlags or [ ]) ++ [
    #       "-Dtests=disabled"
    #     ];
    #   });
    # })
  ];

  mk-pkgs-unfree =
    system:
    import inputs.nixpkgs {
      inherit system overlays;
      config.allowUnfree = true;
    };
in
{
  makePillowArgs =
    {
      edition,
      host,
      hostPlatform,
      useDefaults ? true,
      hasGUI ? (edition == "workstation" || edition == "virtual"),
      settings ? { },
    }:
    assert edition == "workstation" || edition == "virtual" || edition == "wsl";
    let
      ws = edition == "workstation"; # enable virtualization for all workstations by default
    in
    {
      inherit
        edition
        hasGUI
        hostPlatform
        useDefaults
        ;
      # my attempt at forcing user to declare necessary host fields
      host = host // {
        name = host.name;
        interfaces = host.interfaces;
      };
      onHardware = (edition == "workstation" || edition == "virtual");
      settings = {
        virtualisation.enable = ws;
        containers.docker.enable = ws;
        containers.podman.enable = ws;
      }
      // settings;
    };

  pillowSystem =
    {
      pillow,
      modules,
      specialArgs ? { },
    }:
    let
      system = pillow.hostPlatform;
      pkgs-unfree = mk-pkgs-unfree system;
    in
    lib.nixosSystem {
      modules = modules ++ [
        inputs.disko.nixosModules.default
        inputs.home-manager.nixosModules.home-manager
        # inputs.hyprland.nixosModules.default
        inputs.jlink.nixosModules.default
        inputs.nix-monitored.nixosModules.default
        inputs.nvimnix.nixosModules.default
        ../profiles/system
        ({
          nixpkgs = {
            hostPlatform = "${pillow.hostPlatform}";
            overlays = overlays;
          };
        })
      ];

      specialArgs = specialArgs // {
        inherit
          inputs
          pillow
          pkgs-unfree
          version
          ;
      };
    };

  pillowUser =
    pillow:
    {
      imports,
      name,
      initialPassword ? null,
      extraGroups ? [ ],
      extraSpecialArgs ? { },
      # since this is for me I want sensible defaults for me
      personal ? true,
      privileged ? true,
    }:
    { config, lib, ... }:
    let
      pkgs-unfree = mk-pkgs-unfree pillow.hostPlatform;
      homeImports = imports ++ [
        # inputs.hyprland.homeManagerModules.default
        inputs.nvimnix.homeManagerModules.default
      ];

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
          backupFileExtension = "backup";
          useGlobalPkgs = true;
          useUserPackages = true;

          users.${name} = {
            imports = homeImports;
          };

          extraSpecialArgs = {
            inherit inputs version pkgs-unfree;
            pillow = pillow // {
              inherit personal;
            };
            nixosConfig = config;
          }
          // extraSpecialArgs;
        };

        users.users.${name} = {
          inherit initialPassword;
          extraGroups = allGroups;
          isNormalUser = true;
        };
      };
    };
}
