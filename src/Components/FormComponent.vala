namespace Application {
public class FormComponent : Gtk.Grid{

    protected HeaderLabel general_header = new HeaderLabel (_("A bookmark form"));

    protected Gtk.Entry nameEntry = new FormEntry (_("if not set. shortcut is used"));
    protected Gtk.Entry shortcutEntry = new FormEntry (_("server1"));
    protected Gtk.Entry shortcutNameEntry = new FormEntry (_("127.0.0.1"));
    protected Gtk.Entry userNameEntry = new FormEntry (_("james"));
    protected Gtk.Entry portEntry = new FormEntry (_("80"));
    protected Gtk.Entry proxyCommandEntry = new FormEntry (_("ssh bookmark nc %h %p"));

    protected Gtk.ButtonBox button_box = new Gtk.ButtonBox (Gtk.Orientation.HORIZONTAL);

    public FormComponent(){

        var nameLabel = new FormLabel (_("Name:"));
        var shortcutLabel = new FormLabel (_("shortcut:*"));

        button_box.set_layout (Gtk.ButtonBoxStyle.END);
        button_box.set_margin_start(12);
        button_box.margin_bottom = 0;

        column_homogeneous = true;
        row_spacing = 12;
        column_spacing = 12;
        margin = 12;

        attach (general_header, 0, 0, 2, 1);
        attach (nameLabel, 0, 1, 1, 1);
        attach (nameEntry, 1, 1, 1, 1);
        attach (shortcutLabel, 0, 2, 1, 1);
        attach (shortcutEntry, 1, 2, 1, 1);

        attach (button_box, 1, 8, 1, 1); 
    }

    public bool isNotValid(Alias newAlias){
        if(newAlias.getName() == "" || newAlias.getShortcut() == ""){
            return true;
        }
        return false;
    }
}
}
