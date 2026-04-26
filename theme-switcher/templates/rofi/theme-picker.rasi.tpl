/* theme-picker.rasi - Symphony style for Vic's Dotfiles */
@import "~/.config/rofi/config.rasi"

* {
    accent: {{accent}};
}

configuration {
    show-icons: true;
    hover-select: true;
    me-select-entry: "";
    me-accept-entry: "MousePrimary";
}

window {
    width: 60%;
    border: 0;
    border-radius: 20px;
    padding: 0;
    background-color: {{bg}}f2;
    location: center;
    anchor: center;
}

mainbox {
    padding: 20px;
    spacing: 15px;
    background-color: transparent;
    children: [ "listview" ];
}

listview {
    columns: 4;
    lines: 2;
    spacing: 15px;
    padding: 10px;
    fixed-height: false;
    fixed-columns: true;
    background-color: transparent;
    border: 0;
}

element {
    orientation: vertical;
    padding: 15px;
    spacing: 10px;
    border-radius: 15px;
    background-color: transparent;
    cursor: pointer;
}

element selected.normal {
    background-color: {{accent}}33;
    border: 2px;
    border-color: @accent;
}

element-icon {
    size: 200px;
    border-radius: 10px;
    horizontal-align: 0.5;
}

element-text {
    horizontal-align: 0.5;
    vertical-align: 0.5;
    text-color: {{fg}};
    font: "{{font_family}} 12";
}

element selected.normal element-text {
    text-color: @accent;
}
