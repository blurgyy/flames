{ config, pkgs, proxy }: {
  enable = true;
  userEmail = "gy@blurgy.xyz";
  userName = "Gaoyang Zhang";
  lfs.enable = true;
  aliases = {
    a = "add";
    aa = "add -A";
    b = "branch";
    bs = "branch --set-upstream-to";
    bv = "branch -vv";
    c = "commit -sv";  # signing flag `-S` can be omitted since signing.signByDefault is set
    ca = "commit -sv --amend";
    can = "commit -sv --amend --no-edit";
    cannosign = "commit -sv --amend --no-edit";
    canosign = "commit -sv --amend";
    cnosign = "commit -sv";
    cinit = ''commit --allow-empty -m "chore: initialize repository (empty)"'';
    co = "checkout";
    d = "diff";
    dp = "diff --no-ext-diff --patch";
    dc = "diff --cached";
    dcp = "diff --cached --no-ext-diff --patch";
    f = "fetch";
    l = "log --all --graph --decorate --oneline -8";
    ln = "log --all --graph --decorate --oneline";
    la = "log --all --graph --decorate --format=fuller";
    lb = "log --graph --decorate --oneline -8";
    lbn = "log --graph --decorate --oneline";
    lad = "log --all --graph --decorate --format=fuller --patch --ext-diff";
    lap = "log --all --graph --decorate --format=fuller --patch";
    ll = "pull --ff-only";
    lll = "pull --ff-only";
    mt = "mergetool";
    patch = "push rad HEAD:refs/patches";
    p = "push";
    pf = "push -f";
    s = "status -s";
    sa = "status";
    sd = "stash --patch --ext-diff";
    sp = "stash --patch";
    unstage = "reset HEAD --";
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
    "*.tex   text=auto diff=tex"
    "*.txt   text=auto"
    "*.TXT   text=auto"
  ];
  difftastic = {
    enable = true;
    color = "always";
  };
  signing = {
    key = "ff02f82f94915004";
    signByDefault = !config.home.presets.sans-systemd;
  };
  extraConfig = {
    core.pager = "${pkgs.less}/bin/less --quit-if-one-screen";
    merge.tool = "vimdiff";
    mergetool.vimdiff.cmd = "nvim -d $MERGED $LOCAL $REMOTE -c 'wincmd J'";
    mergetool.keepBackup = false;
    mergetool.prompt = false;
    merge.ff = false;  # create an extra merge commit even if fast-forward is possible, use --ff-only to override
    fetch.prune = false;
    init.defaultBranch = "main";
  };
}
