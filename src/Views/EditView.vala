namespace Application {
public class EditView : FormComponent { 

    private ListManager listManager = ListManager.get_instance();
    private StackManager stackManager = StackManager.get_instance();

    public EditView(){ 

        general_header.set_text(_("Edit a alias"));

        nameEntry.set_sensitive(false);

        var edit_button = new Gtk.Button.with_label (_("Edit"));
        edit_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);
        edit_button.clicked.connect (() => {
           EditAliasInFile();
        });

        button_box.pack_end (edit_button);
    }

    public void loadView(Alias alias){
               
        nameEntry.text = "";
        shortcutEntry.text = "";
       
        if(alias.getName() != null){
            nameEntry.text = alias.getName();
        }
        if(alias.getShortcut() != null){ 
            shortcutEntry.text = alias.getShortcut();
        }
    }

    public void EditAliasInFile(){
        
        var aliasName = nameEntry.text;

        var responseTranslator = new ResponseTranslator(); 
        var aliases = responseTranslator.getAliases(); 

        var alias = getCorrectAliasByName(aliasName, aliases);
        alias.setName(nameEntry.text);        
        alias.setShortcut(shortcutEntry.text);

        if(isNotValid(alias)){
            new Alert(_("Fields are invalid"), _("Please correctly fill in all the required fields"));
            return;
        }

        var index = getCorrectAliasIndex(alias, aliases);
        
        aliases[index] = alias;

        responseTranslator.writeToFile(aliases);
        listManager.getList().getRepositories("");
        stackManager.getStack().visible_child_name = "list-view";
    }

    public int getCorrectAliasIndex(Alias editedAlias, Alias[] aliases){
        var index = 0;           
        foreach (Alias alias in aliases) {
            if(alias.getName() == editedAlias.getName()) {
                return index;
            }
            index++;
        }
        return index;
    }

    public Alias getCorrectAliasByName(string aliasName, Alias[] aliases){           
        foreach (Alias alias in aliases) {
            if(alias.getName() == aliasName) {
                return alias;
            }
        }
        return new Alias();
    }
}
}
