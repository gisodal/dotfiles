// ==UserScript==
// @name        Prevent keyboard shortcut hijacking
// @description Prevent websites to hijack keyboard shortcuts, for example <Ctrl+F> on Discourse
// @namespace   Violentmonkey Scripts
// @match       *://*/*
// @grant       none
// @version     1.0
// @author      notDavid
// ==/UserScript==

(window.opera ? document.body : document).addEventListener(
  "keydown",
  function (e) {
    //alert(e.keyCode ); //uncomment to find more keyCodes

    var OS = "Unknown";
    if (navigator.userAgent.toUpperCase().indexOf("MAC") >= 0) OS = "macOS";
    //if (navigator.userAgent.toUpperCase().indexOf("LINUX")>=0) OS="Linux";
    //if (navigator.userAgent.toUpperCase().indexOf("X11")>=0) OS="UNIX";
    //if (navigator.userAgent.toUpperCase().indexOf("WIN")>=0) OS="Windows";
    //console.log(OS);

    // macOS uses the Command key, identified as metaKey
    // Windows and Linux use the Control key, identified as ctrlKey
    var modifier_cmd = e.metaKey;
    var modifier_ctrl = e.ctrlKey;

    if (e.keyCode === 116) {
      // F5 should never be captured
      e.stopImmediatePropagation();
      return;
    }

    // abort if modifier isn't pressed
    if (modifier_cmd || modifier_ctrl) {
      if (modifier_ctrl) {
        switch (e.keyCode) {
          case 70: // f - find
            e.stopImmediatePropagation();
            return;
        }
      }

      if (OS == "macOS" && modifier_cmd) {
        switch (e.keyCode) {
          case 188: // , - settings
          case 82: // r - reload
          case 70: // f - find (Discourse)
          case 68: // d - bookmark
          case 66: // b - bold
            e.stopImmediatePropagation();
            return;
        }
      }
    }
  },
  true,
);
