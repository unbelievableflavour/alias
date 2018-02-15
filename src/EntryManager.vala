using Granite.Widgets;

namespace Application {
public class EntryManager : Gtk.ListBox{

    static EntryManager? instance;
    string[] entries = new string[0];

    EntryManager() {
    }
 
    public static EntryManager get_instance() {
        if (instance == null) {
            instance = new EntryManager();
        }
        return instance;
    }

    public string[] getEntries (){
        var responseTranslator = new ResponseTranslator();
        return responseTranslator.getAliases();
    }

    public void addEntry (string entry){
        entries += entry;
    }
    
    public void removeEntry(string removedEntry){
        string[] newList = new string[0];
        
        foreach (string entry in entries) {
           if(entry != removedEntry) {
                newList += entry;
           }
        }

        entries = newList;
    }

    public string getWinner(){
        int randomIndex = GLib.Random.int_range (0, entries.length);
        return entries[randomIndex];
    }
}
}
