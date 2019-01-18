namespace Application {
public class EditView : FormComponent {

    private ListManager list_manager = ListManager.get_instance ();
    private StackManager stack_manager = StackManager.get_instance ();
    CommandManager command_manager = new CommandManager ();

    public EditView () {

        general_header.set_text (_("Edit a alias"));

        name_entry.set_sensitive (false);

        var edit_button = new Gtk.Button.with_label (_("Edit"));
        edit_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);
        edit_button.clicked.connect (() => {
           edit_alias_in_file ();
        });

        button_box.pack_end (edit_button);
    }

    public void load_view (Alias alias) {

        name_entry.text = "";
        shortcut_entry.text = "";

        if (alias.get_name () != null) {
            name_entry.text = alias.get_name ();
        }
        if (alias.get_shortcut () != null) {
            shortcut_entry.text = alias.get_shortcut ();
        }
    }

    public void edit_alias_in_file () {

        var alias_name = name_entry.text;

        var response_translator = new ResponseTranslator ();
        var aliases = response_translator.get_aliases ();

        var alias = get_correct_alias_by_name (alias_name, aliases);
        alias.set_name (name_entry.text);
        alias.set_shortcut (shortcut_entry.text);

        if (is_not_valid (alias)) {
            new Alert (_("Fields are invalid"), _("Please correctly fill in all the required fields"));
            return;
        }

        if (alias.get_shortcut ().substring (0,1) != "\"") {
            alias.set_shortcut ("\"" + alias.get_shortcut ());
        }

        if (alias.get_shortcut ().substring (-1) != "\"") {
            alias.set_shortcut (alias.get_shortcut () + "\"");
        }

        var index = get_correct_alias_in_index (alias, aliases);
        aliases[index] = alias;

        response_translator.write_to_file (aliases);
        list_manager.get_list ().get_repositories ("");
        command_manager.reload_aliases ();
        stack_manager.get_stack ().visible_child_name = "list-view";
    }

    public int get_correct_alias_in_index (Alias edited_alias, Alias[] aliases) {
        var index = 0;
        foreach (Alias alias in aliases) {
            if (alias.get_name () == edited_alias.get_name ()) {
                return index;
            }
            index++;
        }
        return index;
    }

    public Alias get_correct_alias_by_name (string alias_name, Alias[] aliases) {
        foreach (Alias alias in aliases) {
            if (alias.get_name () == alias_name) {
                return alias;
            }
        }
        return new Alias ();
    }
}
}
