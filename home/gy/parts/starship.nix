{
  enable = true;
  enableFishIntegration = false;
  settings = {
    format = "$all";
    scan_timeout = 30;
    command_timeout = 500;
    add_newline = false;
    character = {
      success_symbol = "[](bold green)";
      error_symbol = "[✗](bold red)";
      vimcmd_symbol = "[](bold blue)";
      vimcmd_replace_one_symbol = "[](bold purple)";
      vimcmd_replace_symbol = "[](bold underline purple)";
      vimcmd_visual_symbol = "[…](bold underline yellow)";
    };
    time = {
      disabled = false;
      format = "at [$time]($style) ";
      style = "bold yellow";
      use_12hr = false;
      utc_time_offset = "local";
      time_range = "-";
    };
    cmake.disabled = true;
    python.format = "is [$symbol$pyenv_prefix($version )(\($virtualenv\) )]($style)";
    shell = {
      disabled = false;
      format = "[|](black)$indicator[|](black) ";
      bash_indicator = "[b](yellow underline)";
      fish_indicator = "[f](green bold italic)";
      zsh_indicator = "[z](purple underline)";
      powershell_indicator = "[p](blue)";
      ion_indicator = "[i](blue)";
      elvish_indicator = "[e](blue)";
      tcsh_indicator = "[t](blue)";
      unknown_indicator = "[?](red)";
    };
    hostname = {
      ssh_only = true;
      trim_at = ".";
      format = "[$hostname]($style) in ";
      style = "green dimmed bold";
      disabled = false;
    };
    username = {
      format = "[$user]($style) @ ";
      style_root = "red bold";
      style_user = "yellow bold";
      show_always = false;
      disabled = false;
    };
    directory = {
      truncation_length = 3;
      truncate_to_repo = true;
      fish_style_pwd_dir_length = 0;
      use_logical_path = true;
      format = "[$path]($style)[$read_only]($read_only_style) ";
      style = "cyan bold";
      disabled = false;
      read_only = " 🔒";
      read_only_style = "red";
      truncation_symbol = "…/";
      home_symbol = "~";
    };
  };
}
