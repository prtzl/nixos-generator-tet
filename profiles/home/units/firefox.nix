{
  pillow,
  ...
}:

{
  programs.firefox = {
    enable = pillow.hasGUI;

    profiles = {
      default = {
        id = 0;
        name = "default";
        isDefault = true;

        settings = {
          # "browser.startup.homepage" = "https://duckduckgo.com";
          "browser.search.defaultenginename" = "ddg";
          "browser.search.order.1" = "DuckDuckGo";

          "signon.rememberSignons" = false;
          "widget.use-xdg-desktop-portal.file-picker" = 1;
          "browser.aboutConfig.showWarning" = false;
          "browser.compactmode.show" = true;
          "browser.cache.disk.enable" = false; # Be kind to hard drive
          "browser.toolbars.bookmarks.visibility" = "never";

          # "mousewheel.default.delta_multiplier_x" = 20;
          # "mousewheel.default.delta_multiplier_y" = 20;
          # "mousewheel.default.delta_multiplier_z" = 20;

          # Firefox 75+ remembers the last workspace it was opened on as part of its session management.
          # This is annoying, because I can have a blank workspace, click Firefox from the launcher, and
          # then have Firefox open on some other workspace.
          "widget.disable-workspace-management" = true;

          "sidebar.verticalTabs" = true;
          "sidebar.verticalTabs.dragToPinPromo.dismissed" = true;
          "sidebar.main.tools" = "history,bookmarks";
          "sidebar.visibility" = "hide";
        };

        search = {
          force = true;
          default = "ddg";
          order = [
            "ddg"
            "google"
          ];
        };
      };
    };
  };
}
