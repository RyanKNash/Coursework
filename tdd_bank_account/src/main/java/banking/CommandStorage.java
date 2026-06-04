package banking;

import java.util.ArrayList;
import java.util.List;

public class CommandStorage {

    private final List<String> invalidCommands = new ArrayList<>();

    public void addInvalidCommand(String badCommand) {
        invalidCommands.add(badCommand);
    }

    public List<String> getInvalidCommands() {
        return invalidCommands;
    }
}