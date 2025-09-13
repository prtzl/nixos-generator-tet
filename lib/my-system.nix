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
        ++ (importModules "nixosModules");
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
