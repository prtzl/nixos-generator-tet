{
  ...
}:

let
  lock-false = {
    Value = false;
    Status = "locked";
  };
  lock-true = {
    Value = true;
    Status = "locked";
  };
  lock-empty-string = {
    Value = "";
    Status = "locked";
  };
in
{
  programs.firefox = {
    enable = true;

    # policies = {
    #   DisableTelemetry = true;
    #   DisableFirefoxStudies = true;
    #   DontCheckDefaultBrowser = true;
    #   DisablePocket = true;
    #   SearchBar = "unified";
    #
    #   Preferences = {
    #     "browser.formfill.enable" = lock-false;
    #     "browser.newtabpage.activity-stream.showSponsored" = lock-false;
    #     "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
    #     "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
    #     "browser.newtabpage.pinned" = lock-empty-string;
    #     "browser.search.suggest.enabled" = lock-false;
    #     "browser.search.suggest.enabled.private" = lock-false;
    #     "browser.topsites.contile.enabled" = lock-false;
    #     "browser.urlbar.showSearchSuggestionsFirst" = lock-false;
    #     "browser.urlbar.suggest.searches" = lock-false;
    #     "browser.uiCustomization.state" = {
    #       "placements" = {
    #         "widget-overflow-fixed-list" = [ ];
    #         "unified-extensions-area" = [
    #           "ublock0_raymondhill_net-browser-action"
    #           "firefox-enpass_enpass_io-browser-action"
    #           "_b271a84f-6f7c-4784-9b00-3c1b4faa2dce_-browser-action"
    #           "idcac-pub_guus_ninja-browser-action"
    #           "user-agent-switcher_ninetailed_ninja-browser-action"
    #           "amptra_keepa_com-browser-action"
    #           "_174b2d58-b983-4501-ab4b-07e71203cb43_-browser-action"
    #           "_762f9885-5a13-4abd-9c77-433dcd38b8fd_-browser-action"
    #         ];
    #         "nav-bar" = [
    #           "sidebar-button"
    #           "back-button"
    #           "forward-button"
    #           "stop-reload-button"
    #           "urlbar-container"
    #           "downloads-button"
    #           "fxa-toolbar-menu-button"
    #           "unified-extensions-button"
    #         ];
    #         "toolbar-menubar" = [
    #           "menubar-items"
    #         ];
    #         "TabsToolbar" = [ ];
    #         "vertical-tabs" = [
    #           "tabbrowser-tabs"
    #         ];
    #         "PersonalToolbar" = [
    #           "import-button"
    #           "personal-bookmarks"
    #         ];
    #       };
    #       "seen" = [
    #         "developer-button"
    #         "screenshot-button"
    #         "firefox-enpass_enpass_io-browser-action"
    #         "_b271a84f-6f7c-4784-9b00-3c1b4faa2dce_-browser-action"
    #         "idcac-pub_guus_ninja-browser-action"
    #         "user-agent-switcher_ninetailed_ninja-browser-action"
    #         "amptra_keepa_com-browser-action"
    #         "_174b2d58-b983-4501-ab4b-07e71203cb43_-browser-action"
    #         "_762f9885-5a13-4abd-9c77-433dcd38b8fd_-browser-action"
    #         "ublock0_raymondhill_net-browser-action"
    #       ];
    #       "dirtyAreaCache" = [
    #         "nav-bar"
    #         "vertical-tabs"
    #         "PersonalToolbar"
    #         "toolbar-menubar"
    #         "TabsToolbar"
    #         "unified-extensions-area"
    #       ];
    #     };
    #     "extensions.pocket.enabled" = lock-false;
    #     "extensions.screenshots.disabled" = lock-true;
    #   };
    #
    #   ExtensionSettings = {
    #     "uBlock0@raymondhill.net" = {
    #       install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
    #       installation_mode = "force_installed";
    #     };
    #     "extension@tabliss.io" = {
    #       install_url = "https://addons.mozilla.org/firefox/downloads/file/3940751/tabliss-2.6.0.xpi";
    #       installation_mode = "force_installed";
    #     };
    #     "firefox-enpass@enpass.io" = {
    #       install_url = "https://dl.enpass.io/stable/extensions/firefox/versions/v6.11.7.2/enpass_password_manager-6.11.7.2.xpi";
    #       installation_mode = "force_installed";
    #     };
    #     "idcac-pub@guus.ninja" = {
    #       install_url = "https://addons.mozilla.org/firefox/downloads/latest/istilldontcareaboutcookies/latest.xpi";
    #       installation_mode = "force_installed";
    #     };
    #     "user-agent-switcher@ninetailed.ninja" = {
    #       install_url = "https://addons.mozilla.org/firefox/downloads/latest/uaswitcher/latest.xpi";
    #       installation_mode = "force_installed";
    #     };
    #     "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" = {
    #       install_url = "https://addons.mozilla.org/firefox/downloads/latest/return-youtube-dislikes/latest.xpi";
    #       installation_mode = "force_installed";
    #     };
    #     "{b271a84f-6f7c-4784-9b00-3c1b4faa2dce}" = {
    #       install_url = "https://addons.mozilla.org/firefox/downloads/latest/youtube-comment-search/latest.xpi";
    #       installation_mode = "force_installed";
    #     };
    #     "{174b2d58-b983-4501-ab4b-07e71203cb43}" = {
    #       install_url = "https://addons.mozilla.org/firefox/downloads/latest/dark-mode-webextension/latest.xpi";
    #       installation_mode = "force_installed";
    #     };
    #   };
    # };
  };
}
