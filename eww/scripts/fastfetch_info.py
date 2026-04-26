#!/usr/bin/env python3
import json
import subprocess
import os

def get_fastfetch_data():
    try:
        result = subprocess.run(['fastfetch', '--format', 'json'], capture_output=True, text=True)
        if result.returncode != 0:
            return {"error": "fastfetch failed"}
        return json.loads(result.stdout)
    except Exception as e:
        return {"error": str(e)}

def parse_data(raw_data):
    info = {
        "os": "N/A",
        "os_icon": "󰣇",
        "kernel": "N/A",
        "uptime": "N/A",
        "packages": "N/A",
        "shell": "N/A",
        "resolution": "N/A",
        "wm": "N/A",
        "terminal": "N/A",
        "cpu": "N/A",
        "gpu": "N/A",
        "memory": "N/A",
        "disk": "N/A",
        "theme": "N/A",
        "icons": "N/A",
        "font": "N/A"
    }

    for item in raw_data:
        t = item.get("type")
        r = item.get("result")
        
        if not r: continue

        if t == "OS":
            info["os"] = r.get("name", "N/A")
        elif t == "Kernel":
            info["kernel"] = r.get("release", "N/A")
        elif t == "Uptime":
            info["uptime"] = r.get("pretty", "N/A")
        elif t == "Packages":
            info["packages"] = f"{r.get('all', '0')}"
        elif t == "Shell":
            info["shell"] = r.get("exe", "N/A").split('/')[-1]
        elif t == "Display":
            if isinstance(r, list) and len(r) > 0:
                info["resolution"] = f"{r[0].get('width', '0')}x{r[0].get('height', '0')}"
        elif t == "WM":
            info["wm"] = r.get("pretty", "N/A")
        elif t == "Terminal":
            info["terminal"] = r.get("pretty", "N/A")
        elif t == "CPU":
            info["cpu"] = r.get("name", "N/A")
        elif t == "GPU":
            if isinstance(r, list) and len(r) > 0:
                info["gpu"] = r[0].get("name", "N/A")
        elif t == "Memory":
            used = r.get("bytes", {}).get("used", 0) / (1024**3)
            total = r.get("bytes", {}).get("total", 0) / (1024**3)
            info["memory"] = f"{used:.1f}G / {total:.1f}G"
        elif t == "Disk":
             if isinstance(r, list) and len(r) > 0:
                used = r[0].get("bytes", {}).get("used", 0) / (1024**3)
                total = r[0].get("bytes", {}).get("total", 0) / (1024**3)
                info["disk"] = f"{used:.1f}G / {total:.1f}G"
        elif t == "Theme":
            info["theme"] = r.get("pretty", "N/A")
        elif t == "Icons":
            info["icons"] = r.get("pretty", "N/A")
        elif t == "Font":
            info["font"] = r.get("pretty", "N/A")

    # Set icon based on OS
    if "Arch" in info["os"]: info["os_icon"] = "󰣇"
    elif "Ubuntu" in info["os"]: info["os_icon"] = "󰕈"
    elif "Fedora" in info["os"]: info["os_icon"] = "󰣛"
    elif "Debian" in info["os"]: info["os_icon"] = "󰣚"
    elif "NixOS" in info["os"]: info["os_icon"] = "󱄅"

    return info

if __name__ == "__main__":
    raw = get_fastfetch_data()
    if isinstance(raw, list):
        parsed = parse_data(raw)
        print(json.dumps(parsed))
    else:
        print(json.dumps({"error": "could not get data"}))
