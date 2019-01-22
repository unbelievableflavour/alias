namespace Application {
public class ResponseTranslator : Object {

    FileManager file_manager = new FileManager ();

    public Alias[] get_aliases () {
        Alias[] aliases = {};

        var file = file_manager.get_file ("/.bash_aliases");

        try {
            var lines = new DataInputStream (file.read ());

            string line;

            while ((line = lines.read_line (null)) != null) {

                line = line.strip ();

                if (line == "" || line == null) {
                    continue;
                }

                if (line.length > 6 && line.substring (0, 5) == "alias") {
                    var alias = new Alias ();

                    var splitted_line = line.split ("alias", 2);
                    var splitted_line2 = splitted_line[1].split ("=", 2);
                    alias.set_shortcut (splitted_line2[1].strip ());
                    alias.set_name (splitted_line2[0].strip ());
                    alias.set_command ("alias");

                    aliases += alias;
                    continue;
                }

                if (line.length > 6 && line.substring (0, 6) == "export") {
                    var alias = new Alias ();

                    var splitted_line = line.split ("export");
                    var splitted_line2 = splitted_line[1].split ("=", 2);
                    alias.set_shortcut (splitted_line2[1].strip ());
                    alias.set_name (splitted_line2[0].strip ());
                    alias.set_command ("export");

                    aliases += alias;
                    continue;
                }

                var alias = new Alias ();
                alias.set_command ("unknown");
                alias.set_name (line);

                aliases += alias;
            }

           return aliases;

        } catch (Error e) {
            error ("%s", e.message);
        }
    }

    public bool aliases_are_configured () {
        var file = file_manager.get_file ("/.bashrc");

        try {
            var lines = new DataInputStream (file.read ());

            string line;

            while ((line = lines.read_line (null)) != null) {

                if (line == "" || line == null) {
                    continue;
                }

                if (line == "# Alias definitions.") {
                    return true;
                }

                if (line == "#include_bash_aliases") {
                    return true;
                }
            }

           return false;

        } catch (Error e) {
            error ("%s", e.message);
        }
    }

    public void configure_aliases () {
        try {
            var file = file_manager.get_file ("/.bashrc");

            string newFileString = "";
            var lines = new DataInputStream (file.read ());

            string line;
            while ((line = lines.read_line (null)) != null) {
                newFileString += (line + "\n");
            }

            newFileString += "\n
    #include_bash_aliases
    if [ -f ~/.bash_aliases ]; then
        source ~/.bash_aliases
    fi;";

            file_manager.write_to_file (file, newFileString);
        } catch (Error e) {
            error ("%s", e.message);
        }
    }

    public string convert_to_string (Alias[] aliases) {
        string raw_string = "";

        foreach (Alias alias in aliases) {

            if (alias.get_command () == "unknown") {
                raw_string += alias.get_name () + "\n";
                continue;
            }

            string raw_alias = alias.get_command () + " " + alias.get_name () + "=" + alias.get_shortcut () + "\n";
            raw_string += raw_alias;
        }

        return raw_string;
    }

    public void write_to_file (Alias[] aliases) {
        string new_file_string = convert_to_string (aliases);

        var file = file_manager.get_file ("/.bash_aliases");
        file_manager.write_to_file (file, new_file_string);
    }
}
}
