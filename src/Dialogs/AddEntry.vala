namespace Application {
public class AddEntry : Gtk.Dialog {
  
    private EntryManager entryManager = EntryManager.get_instance();
    ListManager listManager = ListManager.get_instance();
    Gtk.Entry aptEntry;

    public AddEntry(){
        title = _("Enter a name");
        var description = _("Please enter a unique name");
        set_default_size (630, 430);
        resizable = false;
 
        var image = new Gtk.Image.from_icon_name ("contact-new", Gtk.IconSize.DIALOG);
        image.valign = Gtk.Align.START;

        aptEntry = new Gtk.Entry ();
        aptEntry.set_placeholder_text (_("Sam Johnson"));
        aptEntry.set_tooltip_text (_("Please enter the name here."));

        var primary_label = new Gtk.Label ("<b>%s</b>".printf (title));
        primary_label.use_markup = true;
        primary_label.selectable = true;
        primary_label.max_width_chars = 50;
        primary_label.wrap = true;
        primary_label.xalign = 0;

        var secondary_label = new Gtk.Label (description);
        secondary_label.use_markup = true;
        secondary_label.selectable = true;
        secondary_label.max_width_chars = 50;
        secondary_label.wrap = true;
        secondary_label.xalign = 0;

        var message_grid = new Gtk.Grid ();
        message_grid.column_spacing = 12;
        message_grid.row_spacing = 6;
        message_grid.margin_end = 12;
        message_grid.attach (image, 0, 0, 1, 2);
        message_grid.attach (primary_label, 1, 0, 1, 1);
        message_grid.attach (secondary_label, 1, 1, 1, 1);
        message_grid.attach (aptEntry, 1, 2, 1, 1);
        message_grid.show_all ();

        get_content_area ().add (message_grid);

        resizable = false;
        deletable =  false;
        skip_taskbar_hint = true;
        transient_for = null;
        
        var close_button = new Gtk.Button.with_label (_("Close"));
        close_button.set_margin_end(12);
        close_button.clicked.connect (() => {
            this.destroy ();
        });

        var create_button = new Gtk.Button.with_label (_("Create"));
        create_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);        
        create_button.clicked.connect (() => {
            createNewPerson();
        });

        var button_box = new Gtk.ButtonBox (Gtk.Orientation.HORIZONTAL);
        button_box.set_layout (Gtk.ButtonBoxStyle.END);
        button_box.pack_start (close_button);
        button_box.pack_end (create_button);
        button_box.margin = 12;
        button_box.margin_bottom = 0;

        get_content_area ().add (button_box);
        this.show_all ();

        key_press_event.connect ((e) => { 
            switch (e.keyval) { 
                case Gdk.Key.Return:
                  createNewPerson(); 
                  break; 
            }
 
            return false; 
        });

    }

    public void createNewPerson(){
        var entries = entryManager.getEntries();

        if(isNotValid(aptEntry.text)){
            new Alert(_("Please enter a name"), _("You didn't enter a name. Please do so to continue!"));
            return;
        }

        if(alreadyExists(aptEntry.text, entries)){
            new Alert(_("This person is already in the list"), _("Please choose a different name"));
            return;
        }
        
        entryManager.addEntry(aptEntry.text);

        listManager.getList().getRepositories("");
        this.destroy ();
    }

    public bool isNotValid(string inputField){
        if(inputField ==  ""){
            return true;
        }
        return false;
    }

    public bool alreadyExists(string newEntry, string[] entries){
        foreach (string entry in entries) {
           if(entry == newEntry) {
                return true;
           }
        }
        return false;
    }

}
}
