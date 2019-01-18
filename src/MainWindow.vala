using Granite.Widgets;

namespace Application {
public class MainWindow : Gtk.Window {

    private ListManager list_manager = ListManager.get_instance ();
    private StackManager stack_manager = StackManager.get_instance ();

    private HeaderBar header_bar = HeaderBar.get_instance ();

    public MainWindow (Gtk.Application application) {
        Object (application: application,
                icon_name: Constants.APPLICATION_NAME,
                resizable: true,
                height_request: Constants.APPLICATION_HEIGHT,
                width_request: Constants.APPLICATION_WIDTH);
    }

    construct {
        set_titlebar (header_bar);

        stack_manager.load_views (this);

        list_manager.get_list ().get_repositories ("");

        var response_translator = new ResponseTranslator ();
        if (!response_translator.check_if_aliases_are_configured ()) {
            stack_manager.get_stack ().visible_child_name = "welcome-view";
        }

        add_shortcuts ();
    }

    private void add_shortcuts () {
        key_press_event.connect ((e) => {
            switch (e.keyval) {
                case Gdk.Key.a:
                  if ((e.state & Gdk.ModifierType.CONTROL_MASK) != 0) {
                    stack_manager.get_stack ().visible_child_name = "create-view";
                  }
                  break;
                case Gdk.Key.f:
                  if ((e.state & Gdk.ModifierType.CONTROL_MASK) != 0) {
                    header_bar.search_entry.grab_focus ();
                  }
                  break;
                case Gdk.Key.q:
                  if ((e.state & Gdk.ModifierType.CONTROL_MASK) != 0) {
                    this.destroy ();
                  }
                  break;
            }

            return false;
        });
    }
}
}
