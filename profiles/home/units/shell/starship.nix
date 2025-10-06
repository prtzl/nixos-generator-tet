{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      command_timeout = 50;
      add_newline = true;

      format = "$username$hostname$directory$fill$cmd_duration$fill$nix_shell$git_branch$git_status$shell$line_break$character";

      fill = {
        symbol = " ";
      };

      character = {
        error_symbol = "[»](bold red)";
        success_symbol = "[»](bold green)";
        vicmd_symbol = "[«](bold blue)";
      };

      cmd_duration = {
        min_time = 1000;
        format = "[$duration ]($style)";
      };

      directory = {
        format = "[:$path]($style)";
        style = "bold cyan";
        truncate_to_repo = false;
        truncation_length = 5;
        truncation_symbol = ">";
      };

      git_branch = {
        always_show_remote = true;
        format = "[$symbol$branch ]($style)";
        style = "bold purple";
        symbol = " ";
      };

      git_status = {
        ahead = "⇡($count)";
        behind = "⇣($count)";
        conflicted = "";
        deleted = "";
        disabled = false;
        diverged = "⇕⇡($ahead_count)⇣($behind_count)";
        format = "[\\[$all_status(|$ahead_behind)\\]]($style)";
        modified = "󰷈";
        renamed = "";
        staged = "[++($count)](green)";
        stashed = "󰆧";
        style = "bold yellow";
        untracked = "";
        up_to_date = "✓";
      };

      hostname = {
        disabled = false;
        format = "[@$hostname$ssh_symbol]($style)";
        ssh_only = true;
        ssh_symbol = " 󰔇";
        style = "bold green";
      };

      nix_shell = {
        format = "[$symbol$name ]($style)";
        style = "bold blue";
        symbol = "";
      };

      username = {
        disabled = false;
        format = "[$user]($style)";
        show_always = true;
        style_root = "bold red";
        style_user = "bold yellow";
      };
    };
  };
}
