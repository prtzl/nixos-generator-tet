{
  pillow,
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
  lock-string = string: {
    Value = string;
    Status = "locked";
  };
in
{
  programs.firefox = {
    enable = pillow.hasGUI;

    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DontCheckDefaultBrowser = true;
      DisablePocket = true;
      SearchBar = "unified";

      Preferences = {
        # Privacy settings
        "extensions.pocket.enabled" = lock-false;
        "browser.newtabpage.pinned" = lock-empty-string;
        "browser.topsites.contile.enabled" = lock-false;
        "browser.newtabpage.activity-stream.showSponsored" = lock-false;
        "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
      };

      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
        "extension@tabliss.io" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/file/3940751/tabliss-2.6.0.xpi";
          installation_mode = "force_installed";
        };
        "firefox-enpass@enpass.io" = {
          install_url = "https://dl.enpass.io/stable/extensions/firefox/versions/v6.11.7.2/enpass_password_manager-6.11.7.2.xpi";
          installation_mode = "force_installed";
        };
        "idcac-pub@guus.ninja" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/istilldontcareaboutcookies/latest.xpi";
          installation_mode = "force_installed";
        };
        "user-agent-switcher@ninetailed.ninja" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/uaswitcher/latest.xpi";
          installation_mode = "force_installed";
        };
        "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/return-youtube-dislikes/latest.xpi";
          installation_mode = "force_installed";
        };
        "{b271a84f-6f7c-4784-9b00-3c1b4faa2dce}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/youtube-comment-search/latest.xpi";
          installation_mode = "force_installed";
        };
        "{174b2d58-b983-4501-ab4b-07e71203cb43}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/dark-mode-webextension/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };
  };
}
