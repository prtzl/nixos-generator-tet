{ ... }:

{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    fileWidgetOptions = [
      "--walker-skip .git,node_modules,target"
      "--preview 'bat -n --color=always {}'"
      "--bind 'ctrl-/:change-preview-window(down|hidden|)'"
    ];
    changeDirWidgetOptions = [
      "--walker-skip .git,node_modules,target"
      "--preview 'tree -C {}'"
    ];
    historyWidgetOptions = [
      "--bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'"
      "--color header:italic"
      "--header 'Press CTRL-Y to copy command into clipboard'"
    ];
  };
}
