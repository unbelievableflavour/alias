using Granite.Widgets;

namespace Application {
public class MainWindow : Gtk.Window{

    private ListManager listManager = ListManager.get_instance();
    private StackManager stackManager = StackManager.get_instance();

    private HeaderBar headerBar = HeaderBar.get_instance();

    construct {
        set_default_size(Constants.APPLICATION_WIDTH, Constants.APPLICATION_HEIGHT);
        set_titlebar (headerBar);

        stackManager.loadViews(this);

        listManager.getList().getRepositories("");

        var responseTranslator = new ResponseTranslator();
        if(!responseTranslator.checkIfAliasesAreConfigured()){
            stackManager.getStack().visible_child_name = "welcome-view";
        }

        addShortcuts();
    }

    private void addShortcuts(){
        key_press_event.connect ((e) => { 
            switch (e.keyval) {
                case Gdk.Key.a:    
                  if ((e.state & Gdk.ModifierType.CONTROL_MASK) != 0) {  
                    stackManager.getStack().visible_child_name = "create-view";
                  }
                  break;
                case Gdk.Key.f:
                  if ((e.state & Gdk.ModifierType.CONTROL_MASK) != 0) {  
                    headerBar.searchEntry.grab_focus();
                  }
                  break;
                case Gdk.Key.q:
                  if ((e.state & Gdk.ModifierType.CONTROL_MASK) != 0) {  
                    Gtk.main_quit();
                  }
                  break;
            }

            return false; 
        });
    }
}
}
