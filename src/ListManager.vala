namespace Application {
public class ListManager : Object {
    
    static ListManager? instance;

    private ListBox listBox;

    // Private constructor
    ListManager() {
        listBox = new ListBox ();
    }
 
    // Public constructor
    public static ListManager get_instance() {
        if (instance == null) {
            instance = new ListManager();
        }
        return instance;
    }

    public ListBox getList() {
        return this.listBox;
    }
}
}
