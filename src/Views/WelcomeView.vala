using Granite.Widgets;

namespace Application {
public class WelcomeView : Gtk.ScrolledWindow {

    private StackManager stackManager = StackManager.get_instance();

    public WelcomeView(){ 
        var welcome_view = new Welcome(_("You are new!"), _("Some lines of code has to be added to your .bashrc file to use your aliases."));
            welcome_view.append("document-properties", _("I'm OK with that."), "");

        welcome_view.activated.connect ((option) => {
            switch (option) {		
                case 0:
                    configureAliases();
                    break;
            }
        });
        this.add(welcome_view);
    }

    private void configureAliases(){

        var responseTranslator = new ResponseTranslator();
        responseTranslator.configureAliases();
        stackManager.getStack().set_visible_child_name ("list-view");
    }
}
}
