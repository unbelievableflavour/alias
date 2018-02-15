namespace Application {
public class DeleteConfirm : Gtk.Dialog {

    ListManager listManager = ListManager.get_instance();

    public DeleteConfirm(string repository){
        if(repository == ""){
            new Alert(_("No person was selected"), _("Please select a person and try again."));  
            return;
        }

        var image = new Gtk.Image.from_icon_name ("dialog-warning", Gtk.IconSize.DIALOG);
        image.valign = Gtk.Align.START;

        var primary_label = new Gtk.Label (_("Are you sure?"));
        primary_label.selectable = true;
        primary_label.max_width_chars = 50;
        primary_label.wrap = true;
        primary_label.xalign = 0;

        var secondary_label = new Gtk.Label (_("You are about to remove this person from the list. Are you sure?"));
        secondary_label.use_markup = true;
        secondary_label.selectable = true;
        secondary_label.max_width_chars = 50;
        secondary_label.wrap = true;
        secondary_label.xalign = 0;

        var message_grid = new Gtk.Grid ();
        message_grid.column_spacing = 12;
        message_grid.row_spacing = 6;
        message_grid.margin_left = message_grid.margin_right = 12;
        message_grid.attach (image, 0, 0, 1, 2);
        message_grid.attach (primary_label, 1, 0, 1, 1);
        message_grid.attach (secondary_label, 1, 1, 1, 1);
        message_grid.show_all ();

        get_content_area ().add (message_grid);

        resizable = false;
        deletable =  false;
        skip_taskbar_hint = true;
        transient_for = null;
        
        var close_button = new Gtk.Button.with_label (_("Cancel"));
        close_button.margin_end = 12;
        close_button.clicked.connect (() => {
            this.destroy ();
        });

        var delete_button = new Gtk.Button.with_label (_("Delete"));
        delete_button.get_style_context ().add_class (Gtk.STYLE_CLASS_DESTRUCTIVE_ACTION);
        delete_button.clicked.connect (() => {
            listManager.getList().getRepositories("");
            this.destroy ();
        });

        var button_box = new Gtk.ButtonBox (Gtk.Orientation.HORIZONTAL);
        button_box.set_layout (Gtk.ButtonBoxStyle.END);
        button_box.pack_start (close_button);
        button_box.pack_start (delete_button);
        button_box.margin = 12;
        button_box.margin_bottom = 0;

        get_content_area ().add (button_box);
        this.show_all ();
    }
}
}
