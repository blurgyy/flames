{ stdenvNoCC
, ckbcomp
, get-xkb-symbols
}:

stdenvNoCC.mkDerivation {
  name = "niz-68ec-use-sun_unix-layout-keymaps";

  buildInputs = [ ckbcomp ];

  buildCommand = ''
    install -Dvm444 ${./keymap.xkb} $out/share/kbd/keymap.xkb
    ${get-xkb-symbols} ${./keymap.xkb} $TMPDIR/xkb_symbols.xkb
    ckbcomp $TMPDIR/xkb_symbols.xkb >$out/share/kbd/keymap.vconsole
  '';

  meta = {
    homepage = "https://www.reddit.com/r/vim/comments/mrzafe/any_hhkb_users_what_do_you_use_to_enter_normal/";
    description = "Maps keyboard layout of a Niz 68EC keyboard to the Sun Unix layout";
  };
}
