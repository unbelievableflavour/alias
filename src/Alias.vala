namespace Application {
public class Alias : Object {

    private string name;
    private string shortcut;

    public string get_name () {
        return this.name;
    }

    public void set_name (string name) {
        this.name = name;
    }

    public string get_shortcut () {
        return this.shortcut;
    }

    public void set_shortcut (string shortcut) {
        this.shortcut = shortcut;
    }
}
}
