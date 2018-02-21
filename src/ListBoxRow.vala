using Granite.Widgets;

namespace Application {
public class ListBoxRow : Gtk.ListBoxRow {

    private StackManager stackManager = StackManager.get_instance();
    private Gtk.Image edit_image = new Gtk.Image.from_icon_name ("document-properties-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
    private Gtk.Image delete_image = new Gtk.Image.from_icon_name ("edit-delete-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
    private Gtk.Image icon = new Gtk.Image.from_icon_name ("utilities-terminal", Gtk.IconSize.DND);
    private ListManager listManager = ListManager.get_instance();
    private Gtk.Box vertical_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 6);

    public ListBoxRow (Alias entry){
        var edit_button = generateEditButton(entry);
        var delete_button = generateDeleteButton(entry);
        var name_label  = generateNameLabel(entry);
        var shortcut_label  = generateShortcutLabel(entry.getShortcut());

        vertical_box.add (name_label);
        vertical_box.add (shortcut_label);
      
        var row = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);
        row.margin = 12;
        row.add (icon);
        row.add(vertical_box);

        row.pack_end (delete_button, false, false);
        row.pack_end (edit_button, false, false);
        this.add (row);
    }

    public Gtk.Label generateNameLabel(Alias entry){
        var name = entry.getName();
        
        var name_label = new Gtk.Label ("<b>%s</b>".printf (name));
        name_label.use_markup = true;
        name_label.halign = Gtk.Align.START;

        return name_label;
    }

    public Gtk.Label generateShortcutLabel(string sshCommand){

        var summary_label = new Gtk.Label (sshCommand);
        summary_label.halign = Gtk.Align.START;

        return summary_label;
    }

    public Gtk.EventBox generateEditButton(Alias alias){
        var edit_button = new Gtk.EventBox();
        edit_button.add(edit_image);
        edit_button.set_tooltip_text(_("Edit this bookmark"));
        edit_button.button_press_event.connect (() => {
            stackManager.setEditView(alias);
            stackManager.getStack().visible_child_name = "edit-view";
            return true;
        });

        return edit_button;
    }

    public Gtk.EventBox generateDeleteButton(Alias alias){
        var delete_button = new Gtk.EventBox();
        delete_button.add(delete_image);
        delete_button.set_tooltip_text(_("Remove this name"));
        delete_button.button_press_event.connect (() => {
            new DeleteConfirm(alias);
            listManager.getList().getRepositories("");
            return true;
        });

        return delete_button;
   }
}
}
