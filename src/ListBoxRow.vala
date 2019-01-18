using Granite.Widgets;

namespace Application {
public class ListBoxRow : Gtk.ListBoxRow {

    private StackManager stack_manager = StackManager.get_instance ();
    private Gtk.Image edit_image = new Gtk.Image.from_icon_name (
        "document-properties-symbolic",
         Gtk.IconSize.SMALL_TOOLBAR
    );
    private Gtk.Image delete_image = new Gtk.Image.from_icon_name ("edit-delete-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
    private Gtk.Image icon = new Gtk.Image.from_icon_name ("utilities-terminal", Gtk.IconSize.DND);
    private ListManager list_manager = ListManager.get_instance ();
    private Gtk.Box vertical_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 6);

    public ListBoxRow (Alias entry) {
        var edit_button = generate_edit_button (entry);
        var delete_button = generate_delete_button (entry);
        var name_label = generate_name_label (entry);
        var shortcut_label = generate_shortcut_label (entry.get_shortcut ());

        vertical_box.add (name_label);
        vertical_box.add (shortcut_label);

        var row = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);
        row.margin = 12;
        row.add (icon);
        row.add (vertical_box);

        row.pack_end (delete_button, false, false);
        row.pack_end (edit_button, false, false);
        this.add (row);
    }

    public Gtk.Label generate_name_label (Alias entry) {
        var name = entry.get_name ();

        var name_label = new Gtk.Label (name);
        name_label.get_style_context ().add_class ("name-label");
        name_label.halign = Gtk.Align.START;

        return name_label;
    }

    public Gtk.Label generate_shortcut_label (string ssh_command ) {

        var summary_label = new Gtk.Label (ssh_command);
        summary_label.get_style_context ().add_class ("shorcut-label");

        return summary_label;
    }

    public Gtk.EventBox generate_edit_button (Alias alias) {
        var edit_button = new Gtk.EventBox ();
        edit_button.add (edit_image);
        edit_button.set_tooltip_text (_("Edit this alias"));
        edit_button.button_press_event.connect (() => {
            stack_manager.set_edit_view (alias);
            stack_manager.get_stack ().visible_child_name = "edit-view";
            return true;
        });

        return edit_button;
    }

    public Gtk.EventBox generate_delete_button (Alias alias) {
        var delete_button = new Gtk.EventBox ();
        delete_button.add (delete_image);
        delete_button.set_tooltip_text (_("Remove this alias"));
        delete_button.button_press_event.connect (() => {
            new DeleteConfirm (alias);
            list_manager.get_list ().get_repositories ("");
            return true;
        });

        return delete_button;
   }
}
}
