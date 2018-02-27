namespace Application {
public class CreateView : FormComponent {

    private ListManager listManager = ListManager.get_instance();
    private StackManager stackManager = StackManager.get_instance();
    ResponseTranslator responseTranslator = new ResponseTranslator();

    public CreateView(){
        general_header.set_text(_("Add a new alias"));

        var create_button = new Gtk.Button.with_label (_("Create"));
        create_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);
        create_button.clicked.connect (() => {
           AddAliasToFile();
        });

        button_box.pack_end (create_button);
    }

    public void AddAliasToFile(){
        var alias = new Alias();
        alias.setName(nameEntry.text);
        alias.setShortcut(shortcutEntry.text);
       
        var aliases = responseTranslator.getAliases();

        if(isNotValid(alias)){
            new Alert(_("Fields are invalid"), _("Please correctly fill in all the required fields"));
            return;
        }

        if(alreadyExists(alias, aliases)){
            new Alert(_("Alias with this name already exists"), _("Please choose a different name"));
            return;
        }

        if(alias.getShortcut().substring(0,1) != "\""){
            alias.setShortcut("\"" + alias.getShortcut());
        }

        if(alias.getShortcut().substring(-1) != "\""){
            alias.setShortcut(alias.getShortcut() + "\"");
        }

        aliases += alias;

        responseTranslator.writeToFile(aliases);
        listManager.getList().getRepositories(""); 
        stackManager.getStack().visible_child_name = "list-view";
    }

    public bool alreadyExists(Alias newAlias, Alias[] aliases){
        foreach (Alias alias in aliases) {
           if(alias.getName() == newAlias.getName()) {
                return true;
           }
        }
        return false;
    }
}
}
