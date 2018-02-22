namespace Application {
public class ResponseTranslator : Object{

    FileManager fileManager = new FileManager();

    public Alias[] getAliases (){
        Alias[] aliases = {};

        var file = fileManager.getFile("/.bash_aliases");
        
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
                alias.setShortcut(splittedLine2[1].strip());
                alias.setName(splittedLine2[0].strip());

                aliases += alias;
            }

           return aliases;

        } catch (Error e) {
            error ("%s", e.message);
        }
    }

    public bool checkIfAliasesAreConfigured (){
        var file = fileManager.getFile("/.bashrc");
        
        try {
            var lines = new DataInputStream (file.read ());

            string line;

            while ((line = lines.read_line (null)) != null) {

                if(line == "" || line == null){
                    continue;
                }

                if(line == "#include_bash_aliases"){
                    return true;
                }
            }

           return false;

        } catch (Error e) {
            error ("%s", e.message);
        }
    }

    public void configureAliases(){

        var file = fileManager.getFile("/.bashrc");

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

        fileManager.writeToFile(file, newFileString);
    }

    public string convertToString(Alias[] aliases){
        string rawString = "";
        
        foreach (Alias alias in aliases) { 
            string rawAlias = "alias " + alias.getName() + "=" + alias.getShortcut() + "\n";
            rawString += rawAlias;
        }
        
        return rawString;
    }

    public void writeToFile(Alias[] aliases){
        string newFileString = convertToString(aliases);

        var file = fileManager.getFile("/.bash_aliases");
        fileManager.writeToFile(file, newFileString);
    }
}
}
