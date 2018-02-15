namespace Application {
public class ResponseTranslator : Object{

    public string[] getAliases (){
        string[] settings = new string[0];

        var file = getFile();
        
        try {
            var lines = new DataInputStream (file.read ());

            string line;

            while ((line = lines.read_line (null)) != null) {

                if(line == "" || line == null){
                    continue;
                }                

                var splittedLine = line.split("alias");
                var splittedLine2 = splittedLine[1].split("=");
                var shortcut = splittedLine2[1];
                var name = splittedLine2[0];

                settings += (name + shortcut);
            }

           return settings;

        } catch (Error e) {
            error ("%s", e.message);
        }
    }

    public string getfilteredVariable(string[] splittedLine){
        foreach (string part in splittedLine) {
            if(part == ""){
                continue;
            }
            return part;
        }
        return splittedLine[0];
    }

    private File getFile(){
        string path = Environment.get_home_dir ();

        var file = File.new_for_path (path + "/.aliases");
        if (!file.query_exists ()) {
            try {
                file.create (FileCreateFlags.REPLACE_DESTINATION, null);
                getFile();
            } catch (Error e) {
                error ("%s", e.message);
            }
        }

        return file;
    }
}
}
