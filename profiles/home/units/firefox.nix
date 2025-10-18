{
  ...
}:

{
  programs.firefox = {
    enable = true;

    # profiles = {
    #   default = {
    #     id = 0;
    #     name = "default";
    #     isDefault = true;
    #
    #     settings = {
    #       "browser.aboutConfig.showWarning" = false;
    #       "browser.cache.disk.enable" = false; # Be kind to hard drive
    #       "browser.compactmode.show" = false;
    #       "browser.search.defaultenginename" = "ddg";
    #       "browser.search.order.1" = "DuckDuckGo";
    #       "browser.toolbars.bookmarks.visibility" = "never";
    #       "sidebar.main.tools" = "history,bookmarks";
    #       "sidebar.new-sidebar.has-used" = true;
    #       "sidebar.revamp" = true;
    #       "sidebar.verticalTabs" = true;
    #       "sidebar.verticalTabs.dragToPinPromo.dismissed" = true;
    #       "sidebar.visibility" = "always-show"; # hide prevents it to expand on demand ...
    #       "signon.rememberSignons" = false;
    #       "widget.disable-workspace-management" = true;
    #       "widget.use-xdg-desktop-portal.file-picker" = 1;
    #     };
    #
    #     search = {
    #       force = true;
    #       default = "ddg";
    #       order = [
    #         "ddg"
    #         "google"
    #       ];
    #     };
    #   };
    # };
  };
}
