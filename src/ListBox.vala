using Granite.Widgets;

namespace Application {
public class ListBox : Gtk.ListBox {

    private ResponseTranslator response_translator = new ResponseTranslator ();
    private StackManager stack_manager = StackManager.get_instance ();

    public void empty () {
        this.foreach ((ListBoxRow) => {
            this.remove (ListBoxRow);
        });
    }

    public void get_repositories (string search_word = "") {
        this.empty ();

        stack_manager.get_stack ().visible_child_name = "list-view";

        var entries = response_translator.get_aliases ();

        if (search_word_doesnt_match_any_in_the_list (search_word, entries)) {
            stack_manager.get_stack ().visible_child_name = "not-found-view";
            return;
        }

        foreach (Alias entry in entries) {
            if (search_word == "") {
                this.add (new ListBoxRow (entry));
                continue;
            }

            if (search_word in entry.get_name ()) {
                this.add (new ListBoxRow (entry));
            }
        }

        this.show_all ();
    }

    private bool search_word_doesnt_match_any_in_the_list (string search_word, Alias[] entries) {
        int matchCount = 0;

        if (search_word == "") {
            return false;
        }

        foreach (Alias entry in entries) {
            if (search_word in entry.get_name ()) {
                matchCount++;
            }
        }
        return matchCount == 0;
    }
}
}
