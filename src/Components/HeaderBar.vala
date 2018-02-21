using Granite.Widgets;

namespace Application {
public class HeaderBar : Gtk.HeaderBar {
    
    static HeaderBar? instance;

    ListManager listManager = ListManager.get_instance();
    StackManager stackManager = StackManager.get_instance();
   
    public Gtk.SearchEntry searchEntry = new Gtk.SearchEntry ();
    Gtk.Button create_button = new Gtk.Button.from_icon_name ("tag-new", Gtk.IconSize.LARGE_TOOLBAR);
    Gtk.Button return_button = new Gtk.Button ();

    HeaderBar() {
        //Granite.Widgets.Utils.set_color_primary (this, Constants.BRAND_COLOR);
        
        generateSearchEntry();
        generateCreateButton();
        generateReturnButton();

        this.show_close_button = true;

        this.pack_start (return_button);
        this.pack_start (create_button);
        this.pack_end (searchEntry);
    }
 
    public static HeaderBar get_instance() {
        if (instance == null) {
            instance = new HeaderBar();
        }
        return instance;
    }

    private void generateSearchEntry(){
        searchEntry.set_placeholder_text(_("Search for aliases"));
        searchEntry.set_tooltip_text(_("Search for names of aliases"));
        searchEntry.search_changed.connect (() => {
            listManager.getList().getRepositories(searchEntry.text); 
        });
    }

    private void generateCreateButton(){
        create_button.set_tooltip_text(_("Add a new alias"));
        create_button.clicked.connect (() => {
            stackManager.getStack().visible_child_name = "create-view";
        });
    }

    private void generateReturnButton(){
        return_button.label = _("Back");
        return_button.no_show_all = true;
        return_button.get_style_context ().add_class ("back-button");
        return_button.visible = false;
        return_button.clicked.connect (() => {
            stackManager.getStack().visible_child_name = "list-view";
        });
    }

    public void showButtons(bool answer){
        searchEntry.visible = answer;
        create_button.visible = answer;
    }

    public void showReturnButton(bool answer){
        return_button.visible = answer;
    }

    public string getFilePath(){
		
		// The FileChooserDialog:
		Gtk.FileChooserDialog chooser = new Gtk.FileChooserDialog (
				"Select your favorite file", null, Gtk.FileChooserAction.OPEN,
				"_Cancel",
				Gtk.ResponseType.CANCEL,
				"_Open",
				Gtk.ResponseType.ACCEPT);

		// Multiple files can be selected:
		chooser.select_multiple = false;

		// We are only interested in .snap files:
		Gtk.FileFilter filter = new Gtk.FileFilter ();
		chooser.set_filter (filter);
		filter.add_mime_type ("text/csv");

		// Add a preview widget:
		Gtk.Image preview_area = new Gtk.Image ();
		chooser.set_preview_widget (preview_area);
		chooser.update_preview.connect (() => {
			string uri = chooser.get_preview_uri ();
			// We only display local files:
			if (uri != null && uri.has_prefix ("file://") == true) {
				try {
					Gdk.Pixbuf pixbuf = new Gdk.Pixbuf.from_file_at_scale (uri.substring (7), 150, 	150, true);
					preview_area.set_from_pixbuf (pixbuf);
					preview_area.show ();
				} catch (Error e) {
					preview_area.hide ();
				}
			} else {
				preview_area.hide ();
			}
		});

		string filePath = "";

		// Process response:
		if (chooser.run () == Gtk.ResponseType.ACCEPT) {
			SList<string> uris = chooser.get_uris ();
			
			foreach (unowned string uri in uris) {
				filePath = uri.replace("file://", "");
			}
		}

		// Close the FileChooserDialog:
		chooser.close ();

		return filePath;
	}
}
}
