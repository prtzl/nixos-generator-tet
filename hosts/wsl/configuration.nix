{
  ...
}:

{
  imports = [ <nixos-wsl/modules> ];

  wsl.enable = true;
  wsl.defaultUser = "nixos";

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = true;
    };
  };
}
