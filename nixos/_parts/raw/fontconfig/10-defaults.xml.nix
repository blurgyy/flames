''
<!-- Default Sans-Serif fonts -->
<match target="pattern">
    <test name="family">
        <string>sans-serif</string>
    </test>
    <edit name="family" mode="prepend" binding="strong">
        <!-- rubik -->
        <string>Rubik</string>
        <!-- harmonyos-sans -->
        <string>HarmonyOS Sans SC</string>
        <string>HarmonyOS Sans TC</string>
        <!--
          noto-fonts
          noto-fonts-extra
          noto-fonts-cjk-sans
          noto-fonts-cjk-serif
        -->
        <string>Noto Sans CJK SC</string>
        <string>Noto Sans CJK TC</string>
        <string>Noto Sans CJK JP</string>
        <string>Noto Sans CJK KR</string>
        <!-- lxgw-wenkai -->
        <string>LXGW Wenkai</string>
        <!-- apple-color-emoji -->
        <string>Apple Color Emoji</string>
        <!-- font-awesome -->
        <string>Font Awesome 6 Free</string>
        <string>Font Awesome 6 Brands</string>
        <!-- TexLive (manually install) -->
        <string>Font Awesome 5 Free</string>
        <string>Font Awesome 5 Brands</string>
        <!-- vscode-codicons -->
        <string>codicon</string>
        <!-- symbols-nerd-font -->
        <string>Symbols Nerd Font</string>
    </edit>
</match>

<!-- Default condensed sans font -->
<match>
    <test name="family">
        <string>condensed-sans-serif</string>
    </test>
    <edit name="family" mode="prepend" binding="strong">
        <string>HarmonyOS Sans Condensed</string>
        <string>Noto Sans Condensed</string>
        <!-- Fallback to sans-serif if neither is found -->
        <string>sans-serif</string>
    </edit>
</match>

<!-- Default Serif fonts -->
<match target="pattern">
    <test name="family">
        <string>serif</string>
    </test>
    <edit name="family" mode="prepend" binding="strong">
        <string>Noto Serif CJK SC</string>
        <string>Noto Serif CJK TC</string>
        <string>Noto Serif CJK JP</string>
        <string>Noto Serif CJK KR</string>
        <string>Noto Serif</string>
        <string>LXGW Wenkai</string>
        <string>Apple Color Emoji</string>
        <string>Font Awesome 6 Free</string>
        <string>Font Awesome 6 Brands</string>
        <string>Font Awesome 5 Free</string>
        <string>Font Awesome 5 Brands</string>
        <string>codicon</string>
        <string>Symbols Nerd Font</string>
    </edit>
</match>

<!-- Default Slab-Serif fonts -->
<match target="pattern">
    <test name="family">
        <string>slab-serif</string>
    </test>
    <edit name="family" mode="prepend" binding="strong">
        <string>Iosevka Term Slab</string>
        <string>Iosevka Slab</string>
        <string>LXGW Wenkai</string>
        <string>Apple Color Emoji</string>
        <string>Font Awesome 6 Free</string>
        <string>Font Awesome 6 Brands</string>
        <string>Font Awesome 5 Free</string>
        <string>Font Awesome 5 Brands</string>
        <string>codicon</string>
        <string>Symbols Nerd Font</string>
    </edit>
</match>

<!-- Default monospace fonts-->
<match target="pattern">
    <test name="family">
        <string>monospace</string>
    </test>
    <edit name="family" mode="prepend" binding="strong">
        <string>Iosevka Fixed</string>
        <!-- 
          noto-fonts
          noto-fonts-extra
          noto-fonts-cjk-sans
          noto-fonts-cjk-serif
        -->
        <string>Noto Sans Mono CJK SC</string>
        <string>Noto Sans Mono</string>
        <string>LXGW Wenkai</string>
        <string>Apple Color Emoji</string>
        <string>Font Awesome 6 Free</string>
        <string>Font Awesome 6 Brands</string>
        <string>Font Awesome 5 Free</string>
        <string>Font Awesome 5 Brands</string>
        <string>codicon</string>
        <string>Symbols Nerd Font</string>
    </edit>
</match>

<!-- Replace requested Noto Sans -->
<!-- Latin fonts -->
<match target="pattern">
    <test name="family">
        <string>Noto Sans</string>
    </test>
    <edit name="family" mode="prepend" binding="same">
        <string>Rubik</string>
        <string>HarmonyOS Sans SC</string>
        <string>Noto Sans CJK TC</string>
    </edit>
</match>
<!-- Simplified Chinese characters -->
<match target="pattern">
    <test name="family">
        <string>Noto Sans CJK SC</string>
    </test>
    <edit name="family" mode="prepend" binding="same">
        <string>HarmonyOS Sans SC</string>
        <string>HarmonyOS Sans TC</string>
    </edit>
</match>
<!-- Traditional Chinese characters -->
<match target="pattern">
    <test name="family">
        <string>Noto Sans CJK TC</string>
    </test>
    <edit name="family" mode="prepend" binding="same">
        <string>HarmonyOS Sans TC</string>
    </edit>
</match>
''

# vim: ft=xml:
