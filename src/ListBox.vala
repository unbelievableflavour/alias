using Granite.Widgets;

namespace Application {
public class ListBox : Gtk.ListBox{

    private ResponseTranslator responseTranslator = new ResponseTranslator();
    private StackManager stackManager = StackManager.get_instance();

    public void empty(){
        this.foreach ((ListBoxRow) => {
            this.remove(ListBoxRow);
        }); 
    }

    public void getRepositories(string searchWord = ""){
        this.empty();

        stackManager.getStack().visible_child_name = "list-view";

        var entries = responseTranslator.getAliases();

        if(searchWordDoesntMatchAnyInList(searchWord, entries)) {
            stackManager.getStack().visible_child_name = "not-found-view";
            return;
        }

        this.add(MessageRow());

        foreach (Alias entry in entries) {
            if(searchWord == ""){
                this.add (new ListBoxRow (entry));
                continue;
            }

            if(searchWord in entry.getName()){
                this.add (new ListBoxRow (entry));
            }
        }

        this.show_all();
    }

    private bool searchWordDoesntMatchAnyInList(string searchWord, Alias[] entries){
        int matchCount = 0;
        
        if(searchWord == ""){
            return false;
        }

        foreach (Alias entry in entries) {
            if(searchWord in entry.getName()){
                matchCount++;                
            }
        }
        return matchCount == 0;    
    }

    public Gtk.ListBoxRow MessageRow(){
        var name = _("Note: Changes take effect after relogging in.");

        var name_label = new Gtk.Label ("%s".printf (name));
        name_label.use_markup = true;

        var messageRow = new Gtk.ListBoxRow();
        messageRow.get_style_context().add_class("listbox-message-row");
        messageRow.add(name_label);
        return messageRow;
   }
}
}
