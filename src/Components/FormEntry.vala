namespace Application {
public class FormEntry : Gtk.Entry {

    public FormEntry (string placeholder_text) {
        this.set_placeholder_text (placeholder_text);
        halign = Gtk.Align.FILL;
    }
}
}
