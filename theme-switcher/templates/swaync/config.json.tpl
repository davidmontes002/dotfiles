{
  "$schema": "/etc/xdg/swaync/configSchema.json",
  "positionX": "right",
  "positionY": "top",
  "layer": "overlay",
  "cssPriority": "user",

  "control-center-width": 400,
  "control-center-height": 700,
  "control-center-margin-top": 11,
  "control-center-margin-right": 3,
  "control-center-margin-left": 0,

  "notification-window-width": 360,
  "notification-icon-size": 48,
  "notification-body-image-height": 100,
  "notification-body-image-width": 200,

  "timeout": 5,
  "timeout-low": 2,
  "timeout-critical": 0,

  "fit-to-screen": false,
  "keyboard-shortcuts": true,
  "image-visibility": "when-available",
  "transition-time": 200,
  "hide-on-clear": true,
  "hide-on-action": true,
  "script-fail-notify": true,

  "widgets": [
    "dnd",
    "buttons-grid",
    "volume",
    "mpris",
    "title",
    "notifications"
  ],

  "widget-config": {
    "dnd": {
      "text": "Do not Disturb"
    },
    "title": {
      "text": "Notifications",
      "clear-all-button": true,
      "button-text": "Clear"
    },
    "mpris": {
      "image-size": 0,
      "image-radius": 0
    },
    "volume": {
      "label": ""
    },
    "buttons-grid": {
      "buttons-per-row": 4,
      "actions": [
        {
          "label": "󰖩",
          "type": "toggle",
          "active": true,
          "command": "sh -c '[[ $SWAYNC_TOGGLE_STATE == true ]] && nmcli radio wifi on || nmcli radio wifi off'",
          "update-command": "sh -c '[[ $(nmcli r wifi) == \"enabled\" ]] && echo true || echo false'"
        },
        {
          "label": "󰂯",
          "type": "toggle",
          "active": true,
          "command": "blueberry",
          "update-command": "sh -c 'bluetoothctl show | grep -q \"Powered: yes\" && echo true || echo false'"
        },
        {
          "label": "󰕾",
          "type": "toggle",
          "active": false,
          "command": "pactl set-sink-mute @DEFAULT_SINK@ toggle",
          "update-command": "sh -c 'pactl get-sink-mute @DEFAULT_SINK@ | grep -q \"no\" && echo true || echo false'"
        },
        {
          "label": "󰌾",
          "command": "hyprlock"
        },
        {
          "label": "󰭻",
          "command": "brave --class=webapp-chatgpt --app=https://chatgpt.com"
        },
        {
          "label": "󰚩",
          "command": "brave --class=webapp-claude --app=https://claude.ai/new"
        },
        {
          "label": "󰭹",
          "command": "brave --class=webapp-gemini --app=https://gemini.google.com/"
        },
        {
          "label": "󰘦",
          "command": "brave --class=webapp-copilot --app=https://copilot.microsoft.com/chats/"
        }
      ]
    }
  }
}
