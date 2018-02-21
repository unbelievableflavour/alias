namespace Application {
public class StackManager : Object {
    
    static StackManager? instance;
    EntryManager entryManager = EntryManager.get_instance();
    
    private Gtk.Stack stack;

    private const string LIST_VIEW_ID = "list-view";
    private const string NOT_FOUND_VIEW_ID = "not-found-view";
    private const string WELCOME_VIEW_ID = "welcome-view";
    private const string WINNER_VIEW_ID = "winner-view";
    private const string CREATE_VIEW_ID = "create-view";
    private const string EDIT_VIEW_ID = "edit-view";

    EditView editView;

    // Private constructor
    StackManager() {
        stack = new Gtk.Stack ();
        stack.transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT;
    }
 
    // Public constructor
    public static StackManager get_instance() {
        if (instance == null) {
            instance = new StackManager();
        }
        return instance;
    }

    public Gtk.Stack getStack() {
        return this.stack;
    }

    public void loadViews(Gtk.Window window){
        stack.add_named (new ListView(), LIST_VIEW_ID);
        stack.add_named (new NotFoundView(), NOT_FOUND_VIEW_ID);
        stack.add_named (new WelcomeView(), WELCOME_VIEW_ID);
        stack.add_named (new CreateView(), CREATE_VIEW_ID);

        editView = new EditView();
        stack.add_named (editView, EDIT_VIEW_ID);

        stack.notify["visible-child"].connect (() => {
            var headerBar = HeaderBar.get_instance();

            if(stack.get_visible_child_name() == WELCOME_VIEW_ID){
                headerBar.showReturnButton(false);
                headerBar.showButtons(true);
            }

            if(stack.get_visible_child_name() == NOT_FOUND_VIEW_ID){
                headerBar.showReturnButton(false);
                headerBar.showButtons(true);
            }

            if(stack.get_visible_child_name() == LIST_VIEW_ID){
                headerBar.showReturnButton(false);
                headerBar.showButtons(true);
            }

            if(stack.get_visible_child_name() == CREATE_VIEW_ID){
                headerBar.showReturnButton(true);
                headerBar.showButtons(false);
            }

            if(stack.get_visible_child_name() == EDIT_VIEW_ID){
                headerBar.showReturnButton(true);
                headerBar.showButtons(false);
            }
        });


        window.add(stack);
        window.show_all();
    }

    public void setEditView(Alias alias){
        editView.loadView(alias);
    }
}
}
