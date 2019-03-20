using Granite.Widgets;

namespace Application {
public class HeaderBar : Gtk.HeaderBar {

    static HeaderBar? instance;

    ListManager list_manager = ListManager.get_instance ();
    StackManager stack_manager = StackManager.get_instance ();

    public Gtk.SearchEntry search_entry = new Gtk.SearchEntry ();
    Gtk.Button create_button = new Gtk.Button.from_icon_name ("tag-new-symbolic", Gtk.IconSize.LARGE_TOOLBAR);
    Gtk.Button return_button = new Gtk.Button ();
    private Granite.ModeSwitch dark_mode_switch = new Granite.ModeSwitch.from_icon_name (
        "display-brightness-symbolic", "weather-clear-night-symbolic"
    );

    HeaderBar () {
        Granite.Widgets.Utils.set_color_primary (this, Constants.BRAND_COLOR);

        generate_search_entry ();
        generate_create_button ();
        generate_return_button ();
        generate_dark_mode_button ();

        this.show_close_button = true;

        this.pack_start (return_button);
        this.pack_start (create_button);
        this.set_custom_title (search_entry);
        this.pack_end (dark_mode_switch);
    }

    public static HeaderBar get_instance () {
        if (instance == null) {
            instance = new HeaderBar ();
        }
        return instance;
    }

    private void generate_search_entry () {
        search_entry.set_placeholder_text (_("Search for aliases"));
        search_entry.set_tooltip_text (_("Search for names of aliases"));
        search_entry.no_show_all = true;
        search_entry.visible = true;
        search_entry.search_changed.connect (() => {
            list_manager.get_list ().get_aliases (search_entry.text);
        });
    }

    private void generate_create_button () {
        create_button.set_tooltip_text (_("Add new alias"));
        create_button.no_show_all = true;
        create_button.visible = true;
        create_button.clicked.connect (() => {
            stack_manager.get_stack ().visible_child_name = "create-view";
        });
    }

    private void generate_return_button () {
        return_button.label = _("Back");
        return_button.no_show_all = true;
        return_button.get_style_context ().add_class ("back-button");
        return_button.visible = false;
        return_button.clicked.connect (() => {
            stack_manager.get_stack ().visible_child_name = "list-view";
        });
    }

    public void show_buttons (bool answer) {
        search_entry.visible = answer;
        create_button.visible = answer;
    }

    public void show_return_button (bool answer) {
        return_button.visible = answer;
    }

    public string get_file_path () {

        Gtk.FileChooserDialog chooser = new Gtk.FileChooserDialog (
            "Select your favorite file", null, Gtk.FileChooserAction.OPEN,
            "_Cancel",
            Gtk.ResponseType.CANCEL,
            "_Open",
            Gtk.ResponseType.ACCEPT
        );

        // Multiple files can be selected:
        chooser.select_multiple = false;

        // We are only interested in .snap files:
        Gtk.FileFilter filter = new Gtk.FileFilter ();
        chooser.set_filter (filter);
        filter.add_mime_type ("text/csv");

        // Add a preview widget:
        Gtk.Image preview_area = new Gtk.Image ();
        chooser.set_preview_widget (preview_area);
        chooser.update_preview.connect (() => {
            string uri = chooser.get_preview_uri ();
            // We only display local files:
            if (uri != null && uri.has_prefix ("file://") == true) {
                try {
                    Gdk.Pixbuf pixbuf = new Gdk.Pixbuf.from_file_at_scale (uri.substring (7), 150, 150, true);
                    preview_area.set_from_pixbuf (pixbuf);
                    preview_area.show ();
                } catch (Error e) {
                    preview_area.hide ();
                }
            } else {
                preview_area.hide ();
            }
        });

        string filePath = "";

        // Process response:
        if (chooser.run () == Gtk.ResponseType.ACCEPT) {
            SList<string> uris = chooser.get_uris ();

            foreach (unowned string uri in uris) {
                filePath = uri.replace ("file://", "");
            }
        }

        // Close the FileChooserDialog:
        chooser.close ();

        return filePath;
    }

    private void generate_dark_mode_button () {
        GLib.Settings settings = new GLib.Settings (Constants.APPLICATION_NAME);
        var gtk_settings = Gtk.Settings.get_default ();
        dark_mode_switch.primary_icon_tooltip_text = _("Light mode");
        dark_mode_switch.secondary_icon_tooltip_text = _("Dark mode");
        dark_mode_switch.valign = Gtk.Align.CENTER;
        dark_mode_switch.bind_property ("active", gtk_settings, "gtk_application_prefer_dark_theme");
        settings.bind ("use-dark-theme", dark_mode_switch, "active", GLib.SettingsBindFlags.DEFAULT);
    }
}
}
