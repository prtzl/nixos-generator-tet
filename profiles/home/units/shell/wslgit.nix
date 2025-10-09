{
  pkgs,
  ...
}:

let
  wslgit = pkgs.writeShellApplication {
    name = "wslgit";
    runtimeInputs = with pkgs; [ git ];
    text = ''
      # Detect if current directory is on a Windows-mounted drive (/mnt/c, /mnt/d, etc.)
      is_win_dir() {
        [[ "$PWD" =~ ^/mnt/[a-zA-Z]/ ]]
      }

      # Find git.exe if available (returns 0 if found)
      find_win_git() {
        which git.exe >/dev/null 2>&1
      }

      if is_win_dir; then
        if find_win_git; then
          # Use Windows git.exe
          git_exe_path="$(which git.exe)"
          "$git_exe_path" "$@"
        else
          echo "⚠️  Windows git.exe not found!"
          return 1
        fi
      else
        git "$@"
      fi
    '';
  };
in
wslgit
