namespace Application {
public class FileManager : Object{

    public File getFile(string customPath){
        string path = Environment.get_home_dir () + customPath;

        var file = File.new_for_path (path);
        if (!file.query_exists ()) {
            try {
                file.create (FileCreateFlags.REPLACE_DESTINATION, null);
                getFile(customPath);
            } catch (Error e) {
                error ("%s", e.message);
            }
        }

        return file;
    }

    public void writeToFile(File file, string newFileString){
        try {
            if(file.query_exists() == true){

                file.delete(null);
                FileOutputStream fos = file.create (FileCreateFlags.REPLACE_DESTINATION, null);
                DataOutputStream dos = new DataOutputStream (fos);
                
                dos.put_string (newFileString, null);
            }
        } catch (Error e) {
            stderr.printf ("Error: %s\n", e.message);
        }
    }
}
}
