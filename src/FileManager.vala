namespace Application {
public class FileManager : Object {

    public File get_file (string custom_path) {
        string path = Environment.get_home_dir () + custom_path;

        var file = File.new_for_path (path);
        if (!file.query_exists ()) {
            try {
                file.create (FileCreateFlags.REPLACE_DESTINATION, null);
                get_file (custom_path);
            } catch (Error e) {
                error ("%s", e.message);
            }
        }

        return file;
    }

    public void write_to_file (File file, string new_file_string) {
        try {
            if (file.query_exists () == true) {

                file.delete (null);
                FileOutputStream fos = file.create (FileCreateFlags.REPLACE_DESTINATION, null);
                DataOutputStream dos = new DataOutputStream (fos);

                dos.put_string (new_file_string, null);
            }
        } catch (Error e) {
            stderr.printf ("Error: %s\n", e.message);
        }
    }
}
}
