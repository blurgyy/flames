{ pkgs }: let
  fixTypo = target: typos:
    builtins.listToAttrs (
      map
        (t: { name = "${builtins.toString t}"; value = target; })
        typos
    );
  ll_command = "exa -lhgF --icons";
  ls_command = "exa -F";
  vi_command = "nvim";
in
fixTypo "blurgy" [
  "bluryg"
  "lburgy"
] // fixTypo "cd" [
  "c"
  "ccd"
  "cdc"
  "cdd"
  "cde"
  "ce"
  "lcd"
  "vcd"
] // fixTypo "git" [ "g" "gi" "it" "gt" ]
// fixTypo "g++" [ "g+" "g+=" "g=+" "g_" "g__" ]
// fixTypo ll_command [ "ll" "lll" ]
// fixTypo ls_command [ "ls" "lks" "lls" "lsc" "lsl" "s" "sl" ]
// fixTypo "meshlab" [
  "mehlsab"
  "mehslab"
  "meshla"
  "meslha"
  "meslhab"
  "meshalb"
  "meshlag"
  "meshlagb"
  "neshlab"
] // fixTypo "make" [
  "amek"
  "amke"
  "maek"
  "mak"
  "makje"
  "mkae"
  "mke"
] // fixTypo "nix" [
  "ix"
  "nxi"
  "xni"
  "xin"
  "ixn"
  "inx"
] // fixTypo "sudo" [
  "sdo"
  "sduo"
  "sodu"
  "sud"
  "suddo"
  "sudi"
  "sudoo"
  "sudp"
  "sudu"
  "suod"
  "susdo"
  "suso"
  "suudo"
  "usdo"
] // fixTypo vi_command [
  "bim"
  "cim"
  "fim"
  "fvim"
  "im"
  "ivim"
  "ivm"
  "v"
  "vi"
  "viam"
  "viim"
  "vij"
  "vijm"
  "vikm"
  "vim"
  "vimi"
  "vimj"
  "vimk"
  "vimm"
  "vin"
  "viom"
  "vium"
  "vivm"
  "vjim"
  "vjm"
  "vjmm"
  "vkim"
  "vkm"
  "vkmm"
  "vm"
  "vmi"
  "vmj"
  "vmk"
  "vmki"
  "vni"
  "voim"
  "vom"
  "vuim"
  "vum"
  "vun"
  "vvim"
] // {
  "..." = "../..";
  "...." = "../../..";
  "....." = "../../../..";
  "......" = "../../../../..";
  "......." = "../../../../../..";
  "........" = "../../../../../../..";
  "........." = "../../../../../../../..";
  ".........." = "../../../../../../../../..";
} // {
  cp = "cp -v";
  mv = "mv -v";
  rm = "rm -Iv";
} // {
  exa = "exa -F";
  la = "exa -aF";
  lla = "exa -alhgF --icons";
  l = "exa -F";
  tree = "exa -TF --icons";
} // {
  caat = "bat";
  cagt = "bat";
  catt = "bat";
  ccat = "bat";
  cat = "bat";
  dmesg = "sudo dmesg -TL=always | bat -n";
} // {
  g = "git";
  ga = "git add";
  "ga." = "git add .";
  "ga.." = "git add ..";
  "ga..." = "git add ../..";
  "ga...." = "git add ../../..";
  "ga....." = "git add ../../../..";
  gaa = "git add -A";
  gb = "git branch";
  gbs = "git branch --set-upstream-to";
  gc = "git commit -sv";
  gca = "git commit -sv --amend";
  gcan = "git commit -sv --amend --no-edit";
  gcinit = ''git commit --allow-empty -m "chore: initialize repository (empty)"'';
  gcnosign = "git commit -sv --no-gpg-sign";
  gcanosign = "git commit -sv --amend --no-gpg-sign";
  gcannosign = "git commit -sv --amend --no-edit --no-gpg-sign";
  gco = "git checkout";
  "gco." = "git checkout .";
  gd = "git diff";
  dg = "git diff";
  dgd = "git diff";
  ggd = "git diff";
  gdc = "git diff --cached";
  gdcp = "git diff --cached --no-ext-diff --patch";
  gddc = "git diff --cached";
  gdh = "git diff HEAD^ HEAD";
  gdp = "git diff --no-ext-diff --patch";
  gf = "git fetch";
  gl = "git log --all --graph --decorate --oneline -8";
  gln = "git log --all --graph --decorate --oneline";
  glb = "git log --graph --decorate --oneline -8";  # show latest 8 commit logs for current branch
  glbn = "git log --graph --decorate --oneline";
  lg = "git log --all --graph --decorate --oneline -8";
  lgl = "git log --all --graph --decorate --oneline -8";
  gla = "git log --all --graph --decorate --format=fuller";
  glad = "git log --all --graph --decorate --format=fuller --patch --ext-diff";
  glap = "git log --all --graph --decorate --format=fuller --patch";
  gll = "git pull --ff-only";
  glll = "git pull --ff-only";
  gp = "git push";
  pg = "git push";
  gfp = "git push --force";
  gpf = "git push --force";
  gs = "git status -s";
  gsa = "git status";
  gsd = "git stash --patch --ext-diff";
  gsl = "git status && git log --all --graph --decorate --oneline -8";
  gsp = "git stash --patch";
  gbisect = "git bisect";
  gclone = "git clone";
  gshow = "git show";
  gmerge = "git merge --signoff --verbose --no-edit";
  gmergenosign = "git merge --signoff --verbose --no-edit --no-gpg-sign";
  gmt = "git mergetool";
  grebase = "git rebase --committer-date-is-author-date";
  greset = "git reset";
  gstash = "git stash";
  gunstage = "git reset HEAD --";
  ginit = "git init";
  gremote = "git remote";
  grevert = "git revert --signoff --no-edit";
} // {
  cb = "cargo build";
  ci = "cargo install";
  cr = "cargo run";
  ct = "cargo test";
  cbd = "cargo build --debug";
  cid = "cargo install --debug";
  crd = "cargo run --debug";
  ctd = "cargo test --debug";
  cbr = "cargo build --release";
  cir = "cargo install --release";
  crr = "cargo run --release";
  ctr = "cargo test --release";
} // {
  bak = "tt bak";
  debak = "tt debak";
} // {
  black = "/usr/bin/black";
  bpvc = "pelican -rl";
  cf = "clang-format";
  cgls = "systemd-cgls";
  dl = "axel -n 16";
  dvim = "${vi_command} -V10/tmp/vim-debug.log";
  feh = "feh --auto-rotate --conversion-timeout=1";
  fgfg = "fg";
  dfg = "fg";
  "g++" = "g++ -Wall";
  gcc = "gcc -Wall";
  ghc = "ghc -dynamic -outputdir=/tmp/ghc";
  gpustat = ''gpustat --force-color -cpuFi 1 -P "draw,limit"'';
  hibernate = "systemctl hibernate";
  ip = "ip -br -c";
  jobs = "jobs -l";
  js = "sudo journalctl --system";
  jsu = "sudo journalctl --system -u";
  ju = "journalctl --user";
  juu = "journalctl --user -u";
  km = "make";
  lkm = "latexmk";
  lmk = "latexmk";
  lpvc = "latexmk -pvc";
  lpvcc = "yes x | latexmk -pvc";
  mk = "make";
  mtr = "mtr -n";
  n = "node";
  npm = "pnpm";
  nvrun = "__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia";
  p2 = "python2";
  p = "python3";
  parallel = "parallel -u";
  px = "cgproxy";
  pxx = "cgnoproxy";
  qfg = "fg";
  rsync = "rsync -aAHXv";
  sus = "systemctl --user";
  sys = "sudo systemctl --system";
  today = ''date +"%Y-%m-%d"'';
  ts = "PYTHONWARNINGS=ignore telegram-send --timeout 86400";
  viddy = "viddy -n 0.5 --pty";
  vimlite = "${vi_command} --clean";
  watch = "watch -n 0.5 -c";
  kwget = "wget --no-check-certificate";
}
