namespace Application {
public class ListManager : Object {

    static ListManager? instance;

    private ListBox list_box;

    ListManager () {
        list_box = new ListBox ();
    }

    public static ListManager get_instance () {
        if (instance == null) {
            instance = new ListManager ();
        }
        return instance;
    }

    public ListBox get_list () {
        return this.list_box;
    }
}
}
