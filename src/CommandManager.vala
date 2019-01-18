namespace Application {
public class CommandManager : Object {

    public void reload_aliases () {
        string result;
        string error;
        int status;

        try {
            Process.spawn_command_line_sync ("io.elementary.terminal -x 'source ~/.bashrc'",
                out result,
                out error,
                out status
            );

            if (error != null && error != "") {
                new Alert ("An error occured",error);
            }

        } catch (SpawnError e) {
            new Alert ("An error occured", e.message);
        }
    }
}
}
