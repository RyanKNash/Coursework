package banking;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class CommandStorageTest {
    private CommandStorage storage;

    @BeforeEach
    void setUp() {
        storage = new CommandStorage();
    }

    @Test
    void stores_invalid_commands() {
        storage.addInvalidCommand("bad command");

        List<String> result = storage.getInvalidCommands();
        assertEquals(1, result.size());
        assertEquals("bad command", result.get(0));
    }

    @Test
    void stores_multiple_invalid_commands_in_order() {
        storage.addInvalidCommand("bad1");
        storage.addInvalidCommand("bad2");
        storage.addInvalidCommand("bad3");

        List<String> result = storage.getInvalidCommands();

        assertEquals(3, result.size());
        assertEquals("bad1", result.get(0));
        assertEquals("bad2", result.get(1));
        assertEquals("bad3", result.get(2));
    }

}
