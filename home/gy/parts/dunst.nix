{ lib, pkgs, config }: let
  inherit (config.ricing) themeColor;
  themeColorTransparency = "cc";
  transparentThemeColor = name: "${themeColor name}${themeColorTransparency}";
in {
  global = {
    # Which monitor should the notifications be displayed on.
    monitor = 0;

    # Display notification on focused monitor.  Possible modes are:
    #   mouse: follow mouse pointer
    #   keyboard: follow window with keyboard focus
    #   none: don't follow anything
    #
    # "keyboard" needs a window manager that exports the
    # _NET_ACTIVE_WINDOW property.
    # This should be the case for almost all modern window managers.
    #
    # If this option is set to mouse or keyboard, the monitor option
    # will be ignored.
    follow = "mouse";

    ### Geometry ###

    # dynamic width from 0 to 300
    # width = (0, 300)
    # constant width of 300
    width = 384;

    # The maximum height of a single notification, excluding the frame.
    height = 300;

    # Maximum number of notification (0 means no limit)
    notification_limit = 0;

    # Position the notification in the top right corner
    origin = "top-right";

    # Offset from the origin (<horizontal>x<vertical>)
    offset = "18x48";

    # Scale factor (X11 only). It is auto-detected if value is 0.
    scale = 0;

    ### Progress bar ###

    # Turn on the progess bar. It appears when a progress hint is passed with
    # for example dunstify -h int:value:12
    progress_bar = true;

    # Set the progress bar height. This includes the frame, so make sure
    # it's at least twice as big as the frame width.
    progress_bar_height = 10;

    # Set the frame width of the progress bar
    progress_bar_frame_width = 1;

    # Set the minimum width for the progress bar
    progress_bar_min_width = 150;

    # Set the maximum width for the progress bar
    progress_bar_max_width = 300;


    # Show how many messages are currently hidden (because of
    # notification_limit).
    indicate_hidden = true;

    # The transparency of the window.  Range: [0; 100].
    # This option will only work if a compositing window manager is
    # present (e.g. xcompmgr, compiz, etc.). (X11 only)
    transparency = 0;

    # Draw a line of "separator_height" pixel height between two
    # notifications.
    # Set to 0 to disable.
    separator_height = 2;

    # Padding between text and separator/border of the window in the vertical
    # axis.
    padding = 12;

    # Horizontal padding.
    horizontal_padding = 20;

    # Padding between text and icon.
    text_icon_padding = 0;

    # Defines width in pixels of frame around the notification window.
    # Set to 0 to disable.
    frame_width = 2;

    # Defines color of the frame around the notification window.
    frame_color = themeColor "blue";

    # Define a color for the separator.
    # possible values are:
    #  * auto: dunst tries to find a color fitting to the background;
    #  * foreground: use the same color as the foreground;
    #  * frame: use the same color as the frame;
    #  * anything else will be interpreted as a X color.
    separator_color = "frame";

    # Sort messages by urgency.
    sort = true;

    # Don't remove messages, if the user is idle (no mouse or keyboard input)
    # for longer than idle_threshold seconds.
    # Set to 0 to disable.
    # A client can set the 'transient' hint to bypass this. See the rules
    # section for how to disable this if necessary
    idle_threshold = 120;

    # bottom | top | overlay
    # Place dunst notifications on the selected layer. Using
    # overlay will cause notifications to be displayed above
    # fullscreen windows, though this may also occur at top
    # depending on your compositor.
    # The bottom layer is below all windows and above the
    # background.
    layer = "overlay";

    ### Text ###

    font = "system-ui 15";

    # The spacing between lines.  If the height is smaller than the
    # font height, it will get raised to the font height.
    line_height = 0;

    # Possible values are:
    # full: Allow a small subset of html markup in notifications:
    #        <b>bold</b>
    #        <i>italic</i>
    #        <s>strikethrough</s>
    #        <u>underline</u>
    #
    #        For a complete reference see
    #        <https://docs.gtk.org/Pango/pango_markup.html>.
    #
    # strip: This setting is provided for compatibility with some broken
    #        clients that send markup even though it's not enabled on the
    #        server. Dunst will try to strip the markup but the parsing is
    #        simplistic so using this option outside of matching rules for
    #        specific applications *IS GREATLY DISCOURAGED*.
    #
    # no:    Disable markup parsing, incoming notifications will be treated as
    #        plain text. Dunst will not advertise that it has the body-markup
    #        capability if this is set as a global setting.
    #
    # It's important to note that markup inside the format option will be
    # parsed regardless of what this is set to.
    markup = "full";

    # The format of the message.  Possible variables are:
    #   %a  appname
    #   %s  summary
    #   %b  body
    #   %i  iconname (including its path)
    #   %I  iconname (without its path)
    #   %p  progress value if set ([  0%] to [100%]) or nothing
    #   %n  progress value if set without any extra characters
    #   %%  Literal %
    # Markup is allowed
    format = "<span color='${themeColor "blue"}' weight='bold'>%s</span>\\n%b";

    # Alignment of message text.
    # Possible values are "left", "center" and "right".
    alignment = "left";

    # Vertical alignment of message text and icon.
    # Possible values are "top", "center" and "bottom".
    vertical_alignment = "center";

    # Show age of message if message is older than show_age_threshold
    # seconds.
    # Set to -1 to disable.
    show_age_threshold = 90;

    # Specify where to make an ellipsis in long lines.
    # Possible values are "start", "middle" and "end".
    ellipsize = "middle";

    # Ignore newlines '\n' in notifications.
    ignore_newline = false;

    # Stack together notifications with the same content
    stack_duplicates = true;

    # Hide the count of stacked notifications with the same content
    hide_duplicate_count = false;

    # Display indicators for URLs (U) and actions (A).
    show_indicators = true;

    ### Icons ###

    # Align icons left/right/off
    icon_position = "left";

    # Scale small icons up to this size, set to 0 to disable. Helpful
    # for e.g. small files or high-dpi screens. In case of conflict,
    # max_icon_size takes precedence over this.
    min_icon_size = 0;

    # Scale larger icons down to this size, set to 0 to disable
    max_icon_size = 32;

    # Paths in which to default icons.
    # HACK: The added complexity here is due to non-canonical file hierarchy of package flat-remix-icon-theme
    icon_path = with lib; let
      mkFlatRemixIconPath = { name, category, variant }:
        "${config.home.homeDirectory}/.nix-profile/share/icons/${name}/${category}/${variant}";
      mkHiColorIconPath = { category, variant }:
        "${config.home.homeDirectory}/.nix-profile/share/icons/hicolor/${variant}/${category}";
      variant = [ "" "scalable" "symbolic" "512" "256" "128" "64" "48" "32" "24" "22" "18" "16" ];
    in (concatMapStringsSep ":" mkFlatRemixIconPath (
      cartesianProductOfSets {
        name = [ config.services.dunst.iconTheme.name ];
        category = [
          "status"
          "devices"
          "actions"
          "animations"
          "apps"
          "categories"
          "emblems"
          "mimetypes"
          # "panel"  # Don't use panel icons for dunst
          "places"
        ];
        inherit variant;
      }
    ))
    + (concatMapStringsSep ":" mkHiColorIconPath (
      cartesianProductOfSets {
        inherit variant;
        category = [ "apps" "stock" ];
      }));

    ### History ###

    # Should a notification popped up from history be sticky or timeout
    # as if it would normally do.
    sticky_history = true;

    # Maximum amount of notifications kept in history
    history_length = 20;

    ### Misc/Advanced ###

    ## dmenu path.
    #dmenu = /usr/bin/dmenu -p dunst:

    # Browser for opening urls in context menu.
    browser = "${pkgs.handlr}/bin/handlr open";

    # Always run rule-defined scripts, even if the notification is suppressed
    always_run_script = true;

    # Define the title of the windows spawned by dunst
    title = "Dunst";

    # Define the class of the windows spawned by dunst
    class = "Dunst";

    # Define the corner radius of the notification window
    # in pixel size. If the radius is 0, you have no rounded
    # corners.
    # The radius will be automatically lowered if it exceeds half of the
    # notification height to avoid clipping text and/or icons.
    corner_radius = 16;

    # Ignore the dbus closeNotification message.
    # Useful to enforce the timeout set by dunst configuration. Without this
    # parameter, an application may close the notification sent before the
    # user defined timeout.
    ignore_dbusclose = false;

    ### Wayland ###
    # These settings are Wayland-specific. They have no effect when using X11

    # Set this to true to use X11 output on Wayland.
    force_xwayland = false;

    ### Legacy

    # Use the Xinerama extension instead of RandR for multi-monitor support.
    # This setting is provided for compatibility with older nVidia drivers that
    # do not support RandR and using it on systems that support RandR is highly
    # discouraged.
    #
    # By enabling this setting dunst will not be able to detect when a monitor
    # is connected or disconnected which might break follow mode if the screen
    # layout changes.
    force_xinerama = false;

    ### mouse

    # Defines list of actions for each mouse event
    # Possible values are:
    # * none: Don't do anything.
    # * do_action: Invoke the action determined by the action_name rule. If there is no
    #              such action, open the context menu.
    # * open_url: If the notification has exactly one url, open it. If there are multiple
    #             ones, open the context menu.
    # * close_current: Close current notification.
    # * close_all: Close all notifications.
    # * context: Open context menu for the notification.
    # * context_all: Open context menu for all notifications.
    # These values can be strung together for each mouse event, and
    # will be executed in sequence.
    mouse_left_click = "do_action, close_current";
    mouse_middle_click = "close_all";
    mouse_right_click = "close_current";
  };
  urgency_low = {
    background = transparentThemeColor "background";
    foreground = themeColor "foreground";
    frame_color = transparentThemeColor "background";
    timeout = 10;
  };
  urgency_normal = {
    background = transparentThemeColor "background";
    foreground = themeColor "foreground";
    highlight = transparentThemeColor "blue";
    timeout = 10;
  };
  urgency_critical = {
    background = transparentThemeColor "background";
    foreground = themeColor "foreground";
    frame_color = transparentThemeColor "orange";
    highlight = transparentThemeColor "blue";
    timeout = 0;
  };
  warning_message = {
    icon = "dialog-warning";
    background = transparentThemeColor "background";
    foreground = themeColor "foreground";
    frame_color = transparentThemeColor "orange";
  };
}
