{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      command_timeout = 50;
      add_newline = false;

      format = "$username$hostname$directory $git_branch $git_status $nix_shell$fill$cmd_duration$line_break$jobs$character";

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
        format = "[$duration]($style)";
      };

      directory = {
        before_repo_root_style = "bold blue";
        format = "[:$path]($style)[ $read_only]($read_only_style)";
        repo_root_format = "[:$repo_root]($repo_root_style)[$path]($style)[$read_only]($read_only_style)";
        repo_root_style = "bold italic purple";
        style = "bold cyan";
        truncate_to_repo = true;
        truncation_length = 5;
        truncation_symbol = "../";
      };

      git_branch = {
        always_show_remote = true;
        format = "[$symbol$branch(󰹴$remote_name/$remote_branch)]($style)";
        style = "bold purple";
        symbol = " ";
      };

      git_status = {
        ahead = "⇡($count)";
        behind = "⇣($count)";
        conflicted = "[\\[($count)\\]](bold red)";
        deleted = "[\\[($count)\\]](bold red)";
        diverged = "⇕⇡($ahead_count)⇣($behind_count)";
        format = "[$ahead_behind$all_status]($style)";
        modified = "[\\[󰷈($count)\\]](bold yellow)";
        renamed = "[\\[($count)\\]](bold cyan)";
        staged = "[\\[+($count)\\]](bold green)";
        stashed = "[\\[󰆧($count)\\]](bold purple)";
        untracked = "[\\[($count)\\]](bold white)";
        up_to_date = "[\\[✓\\]](bold purple)";
        style = "bold purple";
      };

      hostname = {
        disabled = false;
        format = "[@$hostname$ssh_symbol]($style)";
        ssh_only = true;
        ssh_symbol = " 󰔇";
        style = "bold green";
      };

      nix_shell = {
        format = "[$symbol]($style)";
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
