namespace Application {
public class FormComponent : Gtk.Grid {

    protected HeaderLabel general_header = new HeaderLabel (_("A form"));

    protected Gtk.Entry name_entry = new FormEntry (_("name"));
    protected Gtk.Entry shortcut_entry = new FormEntry (_("command"));

    protected Gtk.ButtonBox button_box = new Gtk.ButtonBox (Gtk.Orientation.HORIZONTAL);

    public FormComponent () {

        var name_label = new FormLabel (_("Name:"));
        var shortcut_label = new FormLabel (_("Command:"));

        button_box.set_layout (Gtk.ButtonBoxStyle.END);
        button_box.set_margin_start (12);
        button_box.margin_bottom = 0;

        column_homogeneous = true;
        row_spacing = 12;
        column_spacing = 12;
        margin = 12;

        attach (general_header, 0, 0, 2, 1);
        attach (name_label, 0, 1, 1, 1);
        attach (name_entry, 1, 1, 1, 1);
        attach (shortcut_label, 0, 2, 1, 1);
        attach (shortcut_entry, 1, 2, 1, 1);

        attach (button_box, 1, 8, 1, 1);
    }

    public bool is_not_valid (Alias new_alias) {
        if (new_alias.get_name () == "" || new_alias.get_shortcut () == "") {
            return true;
        }
        return false;
    }
}
}
