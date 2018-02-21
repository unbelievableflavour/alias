namespace Application {
public class Alias : Object {

    private string name;
    private string shortcut;

    public string getName(){
        return this.name;
    }

    public void setName(string name){
        this.name = name;
    }

    public string getShortcut(){
        return this.shortcut;
    }

    public void setShortcut(string shortcut){
        this.shortcut = shortcut;
    }
}
}
