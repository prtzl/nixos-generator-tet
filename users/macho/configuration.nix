{
  ...
}:
{
  imports = [
    ../../profiles/home
  ];

  programs.git = {
    userName = "prtzl";
    userEmail = "matej.blagsic@protonmail.com";
    extraConfig = {
      core = {
        init.defaultBranch = "master";
      };
    };
  };
}
