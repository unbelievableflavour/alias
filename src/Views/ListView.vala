namespace Application {
public class ListView : Gtk.ScrolledWindow {
       
   ListManager listManager = ListManager.get_instance();

   public ListView(){ 
        add(listManager.getList());
    
        hscrollbar_policy = Gtk.PolicyType.NEVER;        
        
        this.show_all();
   }
}
}
