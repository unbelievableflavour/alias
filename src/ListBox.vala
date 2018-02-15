using Granite.Widgets;

namespace Application {
public class ListBox : Gtk.ListBox{

    private EntryManager entryManager = EntryManager.get_instance();
    private StackManager stackManager = StackManager.get_instance();

    public void empty(){
        this.foreach ((ListBoxRow) => {
            this.remove(ListBoxRow);
        }); 
    }

    public void getRepositories(string searchWord = ""){
        this.empty();

        stackManager.getStack().visible_child_name = "list-view";

        var entries = entryManager.getEntries();

        if(searchWordDoesntMatchAnyInList(searchWord, entries)) {
            stackManager.getStack().visible_child_name = "not-found-view";
            return;
        }

        foreach (string entry in entries) {
            if(searchWord == ""){
                this.add (new ListBoxRow (entry));
                continue;
            }

            if(searchWord in entry){             
                this.add (new ListBoxRow (entry));
            }
        }

        this.show_all();
    }

    private bool searchWordDoesntMatchAnyInList(string searchWord, string[] entries){
        int matchCount = 0;
        
        if(searchWord == ""){
            return false;
        }

        foreach (string entry in entries) {
            if(searchWord in entry){
                matchCount++;                
            }
        }
        return matchCount == 0;    
    }
}
}
