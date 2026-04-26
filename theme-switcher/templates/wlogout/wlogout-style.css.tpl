* {
  font-family: {{font_family}}, sans-serif;
  font-size: 17px;
  box-shadow: none;
  transition: 20ms;
}

window {
  background: url("{{blurred_wallpaper}}");
  background-size: cover;
}

button {
  color: {{fg}};
  border-radius: 16px;
  border: 1px solid {{accent}};
  background-color: transparent;
  box-shadow: inset 2px 2px 14px rgba(255,255,255,0.08),
              inset 0 1px 2px rgba(255,255,255,0.1);

  margin: 8px;
  padding: 12px 16px;

  background-repeat: no-repeat;
  background-position: center 38%;
  background-size: 26%;

  transition: all 0.3s cubic-bezier(.55, 0.0, .28, 1.682),
              box-shadow 0.2s ease-in-out,
              background-color 0.2s ease-in-out;
}

button:hover {
  border: 1px solid {{accent}};
  background-color: {{surface_rgba}};
  background-size: 30%;
  box-shadow: 0 0 30px {{accent}};
  opacity: 0.9;
}

#lock {
  background-image: url("{{icon_dir}}/lock.svg");
}

#logout {
  background-image: url("{{icon_dir}}/logout.svg");
}

#suspend {
  background-image: url("{{icon_dir}}/suspend.svg");
}

#hibernate {
  background-image: url("{{icon_dir}}/hibernate.svg");
}

#reboot {
  background-image: url("{{icon_dir}}/reboot.svg");
}

#shutdown {
  background-image: url("{{icon_dir}}/shutdown.svg");
}

label {
  margin-top: 4px;
  color: {{fg}};
}
