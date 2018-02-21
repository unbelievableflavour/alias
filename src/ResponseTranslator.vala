namespace Application {
public class ResponseTranslator : Object{

    public Alias[] getAliases (){
        Alias[] aliases = {};

        var file = getFile();
        
        try {
            var lines = new DataInputStream (file.read ());

            string line;

            while ((line = lines.read_line (null)) != null) {

                if(line == "" || line == null){
                    continue;
                }                

                var alias = new Alias();

                var splittedLine = line.split("alias");
                var splittedLine2 = splittedLine[1].split("=");
                alias.setShortcut(splittedLine2[1]);
                alias.setName(splittedLine2[0]);

                aliases += alias;
            }

           return aliases;

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

    public void writeToFile(Alias[] aliases){
        var file = getFile();

        try {
            if(file.query_exists() == true){
                string newFileString = convertToString(aliases);

                file.delete(null);
                FileOutputStream fos = file.create (FileCreateFlags.REPLACE_DESTINATION, null);
                DataOutputStream dos = new DataOutputStream (fos);
                
                dos.put_string (newFileString, null);
            }
        } catch (Error e) {
            stderr.printf ("Error: %s\n", e.message);
        }
    }

    private string convertToString(Alias[] aliases){
        string rawString = "";
        
        foreach (Alias alias in aliases) { 
            string rawAlias = "alias " + alias.getName() + "=" + alias.getShortcut() + "\n";
            rawString += rawAlias;  
        }
        
        return rawString;
    }
}
}
