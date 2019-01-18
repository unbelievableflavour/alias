using Granite.Widgets;

namespace Application {
public class WelcomeView : Gtk.ScrolledWindow {

    private StackManager stack_manager = StackManager.get_instance ();

    public WelcomeView () {
        var welcome_view = new Welcome (
            _("You are new!"),
             _("Few lines of code will be added to your .bashrc file, to use your aliases.")
        );
        welcome_view.append ("document-properties", _("I'm OK with that."), "");

        welcome_view.activated.connect ((option) => {
            switch (option) {
                case 0:
                    configure_aliases ();
                    break;
            }
        });
        this.add (welcome_view);
    }

    private void configure_aliases () {
        var response_translater = new ResponseTranslator ();
        response_translater.configure_aliases ();
        stack_manager.get_stack ().set_visible_child_name ("list-view");
    }
}
}
