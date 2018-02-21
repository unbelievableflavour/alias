using Granite.Widgets;

namespace Application {
public class App:Granite.Application{

    construct {
        application_id = Constants.APPLICATION_ID;
        program_name = Constants.APP_NAME;
        app_years = Constants.APP_YEARS;
        exec_name = Constants.EXEC_NAME;
        app_launcher = Constants.DESKTOP_NAME;
        build_version = Constants.VERSION;
        app_icon = Constants.ICON;
        main_url = Constants.MAIN_URL;
        bug_url = Constants.BUG_URL;
    }

    public override void activate() {
        loadGresources();

        var window = new MainWindow ();
        window.destroy.connect (Gtk.main_quit);
        window.show_all();
    }

    public static int main(string[] args) {
    
        new App().run(args);

        Gtk.main();
 
        return 0;
    }

    private void loadGresources(){

        var provider = new Gtk.CssProvider ();
        provider.load_from_resource ("/com/github/bartzaalberg/alias/application.css");
        Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default (), provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
       

        weak Gtk.IconTheme default_theme = Gtk.IconTheme.get_default ();
        default_theme.add_resource_path ("/com/github/bartzaalberg/alias");
    }
 
}
}

