using Granite.Widgets;

namespace Application {
public class HeaderBar : Gtk.HeaderBar {
    
    static HeaderBar? instance;

    ListManager listManager = ListManager.get_instance();
    StackManager stackManager = StackManager.get_instance();
    EntryManager entryManager = EntryManager.get_instance();
   
    public Gtk.SearchEntry searchEntry = new Gtk.SearchEntry ();
    Gtk.Button cheatsheet_button = new Gtk.Button.from_icon_name ("open-menu", Gtk.IconSize.LARGE_TOOLBAR);
    Gtk.Button create_button = new Gtk.Button.from_icon_name ("contact-new", Gtk.IconSize.LARGE_TOOLBAR);
    Gtk.Button import_button = new Gtk.Button.from_icon_name ("document-import", Gtk.IconSize.LARGE_TOOLBAR);
    Gtk.Button return_button = new Gtk.Button ();
    Gtk.Button lottery_button = new Gtk.Button();

    HeaderBar() {
        Granite.Widgets.Utils.set_color_primary (this, Constants.BRAND_COLOR);
        
        generateSearchEntry();
        generateCreateButton();
        generateImportButton();
        generateReturnButton();
        generateChooseWinnerButton();
        generateCheatsheetButton();

        this.show_close_button = true;

        this.pack_start (return_button);
        this.pack_start (create_button);
        this.pack_start (import_button);
        this.pack_start (searchEntry);

        this.pack_end (cheatsheet_button);
        this.pack_end (lottery_button);
    }
 
    public static HeaderBar get_instance() {
        if (instance == null) {
            instance = new HeaderBar();
        }
        return instance;
    }    
    
    private void generateCheatsheetButton(){
        cheatsheet_button.no_show_all = true;
        cheatsheet_button.set_tooltip_text(_("A list of available shortcuts"));
        cheatsheet_button.clicked.connect (() => {
            new Cheatsheet ();
        });
    }

    private void generateSearchEntry(){
        searchEntry.set_placeholder_text(_("Search names"));
        searchEntry.set_tooltip_text(_("Search for names"));
        searchEntry.search_changed.connect (() => {
            listManager.getList().getRepositories(searchEntry.text); 
        });
    }

    private void generateChooseWinnerButton(){
        var icon = new Gtk.Image.from_icon_name ("lottery-crown", Gtk.IconSize.LARGE_TOOLBAR);
        lottery_button.set_image(icon);
        lottery_button.set_tooltip_text(_("Randomly generate a winner"));
        lottery_button.clicked.connect (() => {
            stackManager.showWinnerView();    
        });

    }

    private void generateCreateButton(){
        create_button.set_tooltip_text(_("Add a new name"));
        create_button.clicked.connect (() => {
            new AddEntry();
        });
    }

    private void generateImportButton(){
        import_button.set_tooltip_text(_("Import names from CSV"));
        import_button.clicked.connect (importNames);
    }

    public void importNames(){
        var path = getFilePath();

        if(path == ""){
            return;
        }

        var file = File.new_for_path (path);
        if (!file.query_exists ()) {
            new Alert(_("File doesnt exist"), _("File ") + file.get_path () + _(" doesn't exist"));
            return;
        }

        importNamesFromCSV(file);
    }

    public void importNamesFromCSV(File file) {
        try {
            var dis = new DataInputStream (file.read ());
            string line;
            // Read lines until end of file (null) is reached
            while ((line = dis.read_line (null)) != null) {
                string[] names = line.split (",");
                foreach(string name in names){
                    if(name.strip() == ""){
                        continue;
                    }
                    entryManager.addEntry(name);
                }
            }
        } catch (Error e) {
            error ("%s", e.message);
        }

        listManager.getList().getRepositories("");
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
        import_button.visible = answer;
        lottery_button.visible = answer;
        cheatsheet_button.visible = answer;
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
