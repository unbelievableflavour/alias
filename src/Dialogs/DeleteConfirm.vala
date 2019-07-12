namespace Application {
public class DeleteConfirm : Object {

    private StackManager stack_manager = StackManager.get_instance ();
    private ListManager list_manager = ListManager.get_instance ();
    private CommandManager command_manager = new CommandManager ();

    public DeleteConfirm (Alias alias) {
        var message_dialog = new Granite.MessageDialog.with_image_from_icon_name (
            _("Are you sure?"),
            _("You are about to remove this alias. Are you sure?"),
            "edit-delete",
             Gtk.ButtonsType.CANCEL
        );

        var suggested_button = new Gtk.Button.with_label ( _("Delete"));
        suggested_button.get_style_context ().add_class (Gtk.STYLE_CLASS_DESTRUCTIVE_ACTION);
        message_dialog.add_action_widget (suggested_button, Gtk.ResponseType.ACCEPT);

        message_dialog.show_all ();
        if (message_dialog.run () == Gtk.ResponseType.ACCEPT) {
            delete_alias (alias);
        }
        message_dialog.destroy ();
    }

    private void delete_alias (Alias delete_alias) {
        var response_translator = new ResponseTranslator ();
        var aliases = response_translator.get_aliases ();
        Alias[] new_alias_list = {};

        foreach (Alias alias in aliases) {
           if (alias.get_name () != delete_alias.get_name ()) {
                new_alias_list += alias;
           }
        }

        response_translator.write_to_file (new_alias_list);
        list_manager.get_list ().get_aliases ("");
        command_manager.reload_aliases ();
        stack_manager.get_stack ().visible_child_name = "list-view";
    }
}
}
