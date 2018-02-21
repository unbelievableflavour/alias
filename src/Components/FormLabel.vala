namespace Application {
public class FormLabel : Gtk.Label {
    
    public FormLabel (string text) {
        label = text;
        halign = Gtk.Align.START;
    }
}
}
