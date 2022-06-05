{
  enable = true;
  userEmail = "gy@blurgy.xyz";
  userName = "Gaoyang Zhang";
  aliases = {
    unstage = "reset HEAD --";
    a = "add";
    b = "branch";
    bs = "branch --set-upstream-to";
    bv = "branch -vv";
    c = "commit -S -sv";
    ca = "commit -S -sv --amend";
    can = "commit -S -sv --amend --no-edit";
    cnosign = "commit -sv";
    canosign = "commit -sv --amend";
    cannosign = "commit -sv --amend --no-edit";
    co = "checkout";
    d = "diff";
    dc = "diff --cached";
    f = "fetch";
    l = "log --all --graph --decorate --oneline";
    la = "log --all --graph --decorate --format=fuller";
    ll = "pull";
    p = "push";
    pf = "push -f";
    s = "status";
  };
  attributes = [
    "#       text=auto diff=ada"
    "*.bash  text=auto diff=bash"
    "#       text=auto diff=Covers"
    "*.bib   text=auto diff=bibtex"

    "*.cpp   text=auto diff=cpp"
    "*.hpp   text=auto diff=cpp"
    "*.c     text=auto diff=cpp"
    "*.h     text=auto diff=cpp"

    "*.cs    text=auto diff=csharp"
    "*.css   text=auto diff=css"
    "*.dts   text=auto diff=dts"
    "#       text=auto diff=elixir"
    "*.f     text=auto diff=fortran"
    "#       text=auto diff=fountain"
    "*.go    text=auto diff=golang"
    "*.html  text=auto diff=html"
    "*.java  text=auto diff=java"
    "*.md    text=auto diff=markdown"
    "*.m     text=auto diff=matlab"
    "*.objc  text=auto diff=objc"
    "*.pas   text=auto diff=pascal"
    "*.pl    text=auto diff=perl"
    "*.php   text=auto diff=php"
    "*.py    text=auto diff=python"
    "*.rb    text=auto diff=ruby"
    "*.rs    text=auto diff=rust"
    "*.tex   text=auto diff=latex"
    "*.txt   text=auto"
    "*.TXT   text=auto"
  ];
  difftastic = {
    enable = true;
    color = "always";
  };
  signing = {
    key = "ff02f82f94915004";
    signByDefault = true;
  };
  extraConfig = {
    diff.sopsdiff.textconv = "sops -d";
    merge.tool = "vimdiff";
    mergetool.vimdiff.cmd = "nvim -d $MERGED $LOCAL $REMOTE -c 'wincmd J'";
    mergetool.keepBackup = false;
    mergetool.prompt = false;
    fetch.prune = false;
    init.defaultBranch = "main";
  };
}
