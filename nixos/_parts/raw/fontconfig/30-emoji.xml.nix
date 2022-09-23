{ emojiFontName ? "Apple Color Emoji" }: ''
<match target="pattern">
    <test qual="any" name="family">
        <string>emoji</string>
    </test>
    <edit name="family" mode="assign" binding="same">
        <string>${emojiFontName}</string>
    </edit>
</match>

<!--
    Use ${emojiFontName} when other popular fonts are being specifically
    requested.

    It is quite common that websites would only request Apple and Google
    emoji fonts, and then fallback to b&w Symbola.
    These aliases will make ${emojiFontName} be selected in such cases to
    provide good-looking emojis.
-->
<match target="pattern">
    <test qual="any" name="family">
        <string>EmojiOne</string>
    </test>
    <edit name="family" mode="assign" binding="same"><string>${emojiFontName}</string></edit>
</match>

<match target="pattern">
    <test qual="any" name="family">
        <string>Emoji One</string>
    </test>
    <edit name="family" mode="assign" binding="same">
        <string>${emojiFontName}</string>
    </edit>
</match>

<match target="pattern">
    <test qual="any" name="family">
        <string>EmojiOne Color</string>
    </test>
    <edit name="family" mode="assign" binding="same">
        <string>${emojiFontName}</string>
    </edit>
</match>

<match target="pattern">
    <test qual="any" name="family">
        <string>EmojiOne Mozilla</string>
    </test>
    <edit name="family" mode="assign" binding="same">
        <string>${emojiFontName}</string>
    </edit>
</match>

<match target="pattern">
    <test qual="any" name="family">
        <string>Segoe UI Emoji</string>
    </test>
    <edit name="family" mode="assign" binding="same">
        <string>${emojiFontName}</string>
    </edit>
</match>

<match target="pattern">
    <test qual="any" name="family">
        <string>Segoe UI Symbol</string>
    </test>
    <edit name="family" mode="assign" binding="same">
        <string>${emojiFontName}</string>
    </edit>
</match>

<match target="pattern">
    <test qual="any" name="family">
        <string>Noto Color Emoji</string>
    </test>
    <edit name="family" mode="assign" binding="same">
        <string>${emojiFontName}</string>
    </edit>
</match>

<match target="pattern">
    <test qual="any" name="family">
        <string>NotoColorEmoji</string>
    </test>
    <edit name="family" mode="assign" binding="same">
        <string>${emojiFontName}</string>
    </edit>
</match>

<match target="pattern">
    <test qual="any" name="family">
        <string>Android Emoji</string>
    </test>
    <edit name="family" mode="assign" binding="same">
        <string>${emojiFontName}</string>
    </edit>
</match>

<match target="pattern">
    <test qual="any" name="family">
        <string>Noto Emoji</string>
    </test>
    <edit name="family" mode="assign" binding="same">
        <string>${emojiFontName}</string>
    </edit>
</match>

<match target="pattern">
    <test qual="any" name="family">
        <string>Twitter Color Emoji</string>
    </test>
    <edit name="family" mode="assign" binding="same">
        <string>${emojiFontName}</string>
    </edit>
</match>

<match target="pattern">
    <test qual="any" name="family">
        <string>Twemoji</string>
    </test>
    <edit name="family" mode="assign" binding="same">
        <string>${emojiFontName}</string>
    </edit>
</match>

<match target="pattern">
    <test qual="any" name="family">
        <string>Twemoji Mozilla</string>
    </test>
    <edit name="family" mode="assign" binding="same">
        <string>${emojiFontName}</string>
    </edit>
</match>

<match target="pattern">
    <test qual="any" name="family">
        <string>TwemojiMozilla</string>
    </test>
    <edit name="family" mode="assign" binding="same">
        <string>${emojiFontName}</string>
    </edit>
</match>

<match target="pattern">
    <test qual="any" name="family">
        <string>EmojiTwo</string>
    </test>
    <edit name="family" mode="assign" binding="same">
        <string>${emojiFontName}</string>
    </edit>
</match>

<match target="pattern">
    <test qual="any" name="family">
        <string>Emoji Two</string>
    </test>
    <edit name="family" mode="assign" binding="same">
        <string>${emojiFontName}</string>
    </edit>
</match>

<match target="pattern">
    <test qual="any" name="family">
        <string>EmojiSymbols</string>
    </test>
    <edit name="family" mode="assign" binding="same">
        <string>${emojiFontName}</string>
    </edit>
</match>

<match target="pattern">
    <test qual="any" name="family">
        <string>Symbola</string>
    </test>
    <edit name="family" mode="assign" binding="same">
        <string>${emojiFontName}</string>
    </edit>
</match>
''

# vim: ft=xml:
