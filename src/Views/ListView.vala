namespace Application {
public class ListView : Gtk.ScrolledWindow {

   ListManager list_manager = ListManager.get_instance ();

   public ListView () {
        add (list_manager.get_list ());

        hscrollbar_policy = Gtk.PolicyType.NEVER;

        this.show_all ();
   }
}
}
