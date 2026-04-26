* {
    all: unset;
    font-family: "JetBrains Mono", monospace;
}

window, window.background, #clock, #sysinfo {
    background-color: rgba(0, 0, 0, 0);
    background: none;
}


/* ── CLOCK ─────────────────────────────── */
.clock-box {
    background-color: rgba(0, 0, 0, 0);
    padding: 6px 0px;
}

.clock-time-row {
    background-color: rgba(0, 0, 0, 0);
}

.clock-hh {
    font-family: "Product Sans", sans-serif;
    font-size: 82px;
    font-weight: 700;
    color: {{fg}};
    letter-spacing: -3px;
    text-shadow: 0px 0px 28px {{blue_a28}},
                 0px 2px 18px rgba(0, 0, 0, 0.95);
}

.clock-colon {
    font-family: "Product Sans", sans-serif;
    font-size: 62px;
    font-weight: 300;
    color: {{blue_a55}};
    margin-left: 3px;
    margin-right: 3px;
    text-shadow: 0px 2px 10px rgba(0, 0, 0, 0.8);
}

.clock-mm {
    font-family: "Product Sans", sans-serif;
    font-size: 82px;
    font-weight: 300;
    color: {{fg_a55}};
    letter-spacing: -3px;
    text-shadow: 0px 2px 18px rgba(0, 0, 0, 0.95);
}

.clock-date {
    font-family: "Product Sans", sans-serif;
    font-size: 11px;
    font-weight: 500;
    color: {{overlay_a85}};
    letter-spacing: 3px;
    margin-top: 2px;
    text-shadow: 0px 1px 8px rgba(0, 0, 0, 0.9);
}

/* ── MONITOR BOX ────────────────────────── */
.monitor-box {
    background-color: {{bg}};
    border-radius: 16px;
    border: 1px solid {{surface}};
    padding: 16px 16px;
}

.monitor-header {
    margin-bottom: 12px;
    padding: 14px 8px;
}

.fetch-logo {
    font-family: "JetBrainsMono Nerd Font Mono", monospace;
    font-size: 75px;
    color: {{blue}};
    margin-left: 34px;
    margin-right: 34px;
    text-shadow: 0px 0px 16px {{blue_a35}};
}

.fetch-titles {
    background-color: rgba(0, 0, 0, 0);
    margin-right: 12px;
}

.fetch-label {
    font-family: "JetBrains Mono", monospace;
    font-size: 12px;
    font-weight: 700;
    color: {{green}};
    margin-bottom: 6px;
}

.fetch-values {
    background-color: rgba(0, 0, 0, 0);
}

.fetch-value {
    font-family: "JetBrains Mono", monospace;
    font-size: 12px;
    font-weight: 400;
    color: {{fg}};
    margin-bottom: 6px;
}

.monitor-title {
    font-family: "JetBrains Mono", monospace;
    font-size: 11px;
    font-weight: 700;
    letter-spacing: 2px;
    color: {{surface2}};
}

.status-dot {
    background-color: {{green}};
    border-radius: 50%;
    min-width: 5px;
    min-height: 5px;
    margin-left: 8px;
}

.monitor-divider {
    background-color: {{surface}};
    min-height: 1px;
    margin: 10px 0px;
}

.storage-label {
    font-family: "JetBrains Mono", monospace;
    font-size: 10px;
    letter-spacing: 2px;
    color: {{surface2}};
    margin-bottom: 8px;
}

/* ── STAT ROWS ──────────────────────────── */
.stat-row {
    margin-bottom: 10px;
}

.stat-header {
    font-family: "JetBrains Mono", monospace;
    font-size: 12px;
    font-weight: 500;
    color: {{fg_dim}};
    margin-bottom: 4px;
}

/* ── BARS (scale widget) ────────────────── */
scale.stat-bar {
    padding: 0;
    margin-top: 4px;
}

scale.stat-bar trough {
    background-color: {{bg_alt}};
    border-radius: 3px;
    border: 1px solid {{surface}};
    min-height: 6px;
}

scale.stat-bar trough highlight {
    border-radius: 3px;
    min-height: 6px;
}

scale.stat-bar slider {
    min-width: 0;
    min-height: 0;
    background: none;
    border: none;
    padding: 0;
    opacity: 0;
}

scale.stat-bar.fill-blue   trough highlight { background-color: {{blue}}; }
scale.stat-bar.fill-purple trough highlight { background-color: {{accent}}; }
scale.stat-bar.fill-green  trough highlight { background-color: {{green}}; }
scale.stat-bar.fill-yellow trough highlight { background-color: {{yellow}}; }
scale.stat-bar.fill-orange trough highlight { background-color: {{orange}}; }
