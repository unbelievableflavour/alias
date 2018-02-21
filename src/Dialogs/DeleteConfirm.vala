namespace Application {
public class DeleteConfirm : Object {
      
    private StackManager stackManager = StackManager.get_instance();
    private ListManager listManager = ListManager.get_instance();

    public DeleteConfirm(Alias alias){
        var message_dialog = new Granite.MessageDialog.with_image_from_icon_name (_("Are you sure?"), _("You are about to remove this alias. Are you sure?"), "edit-delete", Gtk.ButtonsType.CANCEL);

        var suggested_button = new Gtk.Button.with_label ("Delete");
        suggested_button.get_style_context ().add_class (Gtk.STYLE_CLASS_DESTRUCTIVE_ACTION);
        message_dialog.add_action_widget (suggested_button, Gtk.ResponseType.ACCEPT);

        message_dialog.show_all ();
        if (message_dialog.run () == Gtk.ResponseType.ACCEPT) {
            deleteAlias(alias);
        }
        message_dialog.destroy ();
    }

    private void deleteAlias(Alias deletedAlias) {
        var responseTranslator = new ResponseTranslator(); 
        var aliases = responseTranslator.getAliases(); 
        Alias[] newAliasList = {};

        foreach (Alias alias in aliases) {
           if(alias.getName() != deletedAlias.getName()) {
                newAliasList += alias;
           }
        }

        responseTranslator.writeToFile(newAliasList); 
        listManager.getList().getRepositories(""); 
        stackManager.getStack().visible_child_name = "list-view";
    }
}
}
