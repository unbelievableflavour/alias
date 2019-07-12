namespace Application {
public class CreateView : FormComponent {

    private ListManager list_manager = ListManager.get_instance ();
    private StackManager stack_manager = StackManager.get_instance ();
    ResponseTranslator response_translator = new ResponseTranslator ();
    CommandManager command_manager = new CommandManager ();

    public CreateView () {
        general_header.set_text (_("Add a new alias"));

        var create_button = new Gtk.Button.with_label (_("Create"));
        create_button.get_style_context ().add_class ("primary-button");
        create_button.clicked.connect (() => {
           add_alias_to_file ();
        });

        button_box.pack_end (create_button);
    }

    public void add_alias_to_file () {
        var alias = new Alias ();
        alias.set_name (name_entry.text);
        alias.set_shortcut (shortcut_entry.text);
        alias.set_command ("alias");
        
        var aliases = response_translator.get_aliases ();

        if (is_not_valid (alias)) {
            new Alert (_("Fields are invalid"), _("Please correctly fill in all the required fields"));
            return;
        }

        if (already_exists (alias, aliases)) {
            new Alert (_("Alias with this name already exists"), _("Please choose a different name"));
            return;
        }

        if (alias.get_shortcut ().substring (0,1) != "\"") {
            alias.set_shortcut ("\"" + alias.get_shortcut ());
        }

        if (alias.get_shortcut ().substring (-1) != "\"") {
            alias.set_shortcut (alias.get_shortcut () + "\"");
        }

        aliases += alias;

        response_translator.write_to_file (aliases);
        list_manager.get_list ().get_aliases ("");
        command_manager.reload_aliases ();
        stack_manager.get_stack ().visible_child_name = "list-view";
    }

    public bool already_exists (Alias new_alias, Alias[] aliases) {
        foreach (Alias alias in aliases) {
           if (alias.get_name () == new_alias.get_name ()) {
                return true;
           }
        }
        return false;
    }
}
}
