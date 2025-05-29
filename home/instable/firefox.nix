{pkgs, config, lib, ...}:
let 
  lock-false = {
    Value = false;
    Status = "locked";
  };
  lock-true = {
    Value = true;
    Status = "locked";
  };

  # function returning the install url of a given extension
  install_url = { name }:
    "https://addons.mozilla.org/firefox/downloads/latest/${name}/latest.xpi";
  extension_dict = { name }: {
    install_url = install_url { name = name; };
    installation_mode = "force_installed";
  };

  # extensions
  ublock = extension_dict { name = "ublock-origin"; };
  privacy_badger = extension_dict { name = "privacy-badger17"; };
  bitwarden = extension_dict { name = "bitwarden-password-manager"; };
  language_tool = extension_dict { name = "languagetool"; };
  consent_o_matic = extension_dict { name = "consent-o-matic"; };
  dark_reader = extension_dict { name = "darkreader"; };
  dearrow = extension_dict { name = "dearrow"; };
  enhancer_for_youtube = extension_dict { name = "enhancer-for-youtube"; };
  pocket_tube = extension_dict { name = "youtube-subscription-groups"; };
  return_youtube_dislike = extension_dict { name = "return-youtube-dislikes"; };
  web_archives = extension_dict { name = "view-page-archives"; };
  sponsor_block_youtube = extension_dict { name = "sponsorblock"; };
  sidebery = extension_dict { name = "sidebery"; };
  vimium-c = extension_dict { name = "vimium-c"; };
  nook = extension_dict { name = "nook"; };
  animalese_typing = extension_dict { name = "animalese-typing"; };

  firefox-extensions = {

    "*".installation_mode =
      "blocked"; # blocks all addons except the ones specified below
    # uBlock Origin:
    "uBlock0@raymondhill.net" = ublock;
    # Privacy Badger:
    "jid1-MnnxcxisBPnSXQ@jetpack" = privacy_badger;
    # Bitwarden Password Manager
    "{446900e4-71c2-419f-a6a7-df9c091e268b}" = bitwarden;
    # AI Grammar Checker & Paraphraser – LanguageTool
    "languagetool-webextension@languagetool.org" = language_tool;
    # Consent-O-Matic
    "gdpr@cavi.au.dk" = consent_o_matic;
    # Dark Reader
    "addon@darkreader.org" = dark_reader;
    # DeArrow
    "deArrow@ajay.app" = dearrow;
    # Enhancer for YouTube™
    "enhancerforyoutube@maximerf.addons.mozilla.org" = enhancer_for_youtube;
    # PocketTube: Youtube Subscription Manager
    "danabok16@gmail.com" = pocket_tube;
    # Return YouTube Dislike
    "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" = return_youtube_dislike;
    # Web Archives
    "{d07ccf11-c0cd-4938-a265-2a4d6ad01189}" = web_archives;
    # SponsorBlock for YouTube - Skip Sponsorships
    "sponsorBlocker@ajay.app" = sponsor_block_youtube;
    # Sidebery
    "{3c078156-979c-498b-8990-85f7987dd929}" = sidebery;
    # "" = {
    #   install_url = ;
    #   installation_mode = "force_installed";
    # };
  
  };

  firefox-about-config = {
    "extensions.pocket.enabled" = lock-false;
    "extensions.screenshots.disabled" = lock-true;
    "browser.topsites.contile.enabled" = lock-false;
    "browser.formfill.enable" = lock-false;
    "browser.search.suggest.enabled" = lock-false;
    "browser.search.suggest.enabled.private" = lock-false;
    "browser.urlbar.suggest.searches" = lock-false;
    "browser.urlbar.showSearchSuggestionsFirst" = lock-false;
    "browser.newtabpage.activity-stream.feeds.section.topstories" = lock-false;
    "browser.newtabpage.activity-stream.feeds.snippets" = lock-false;
    "browser.newtabpage.activity-stream.section.highlights.includePocket" =
      lock-false;
    "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" =
      lock-false;
    "browser.newtabpage.activity-stream.section.highlights.includeDownloads" =
      lock-false;
    "browser.newtabpage.activity-stream.section.highlights.includeVisited" =
      lock-false;
    "browser.newtabpage.activity-stream.showSponsored" = lock-false;
    "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
    "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
    "full-screen-api.ignore-widgets" = lock-true;
  };

  firefox-tracking-protection = {
    Value = true;
    Locked = true;
    Cryptomining = true;
    Fingerprinting = true;
    EmailTracking = true;
  };

  firefox-sanitize-on-shutdown = {
    Cache = false;
    Cookies = false;
    FormData = false;
    History = false;
    Sessions = false;
    SiteSettings = false;
    Locked = true;
  };
  #
  firefox-policies = {
    DisableTelemetry = true;
    DisableFirefoxStudies = true;
    EnableTrackingProtection = firefox-tracking-protection;
    DisablePocket = true;
    DisableFirefoxAccounts = true;
    DisableAccounts = false;
    DisableFirefoxScreenshots = true;
    OverrideFirstRunPage = "";
    OverridePostUpdatePage = "";
    DontCheckDefaultBrowser = true;
    DisplayBookmarksToolbar = "never"; # alternatives: "always" or "newtab"
    DisplayMenuBar = "never"; # alternatives: "always", "never" or "default-on"
    SearchBar = "unified"; # alternative: "separate"

    # ExpireAtSessionEnd determines when cookies expire. (Deprecated. Use SanitizeOnShutdown instead)
    SanitizeOnShutdown = firefox-sanitize-on-shutdown;
    # ---- PREFERENCES ----
    # Check about:config for options.
    Preferences = firefox-about-config;
    ExtensionSettings = firefox-extensions;
  };
in 
{
  programs.firefox = {
    # package = pkgs.firefox-unwrapped;
    enable = true;
    languagePacks = [ "fr" "en-US" ];
    policies = firefox-policies;
  };
}
