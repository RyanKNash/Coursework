package banking;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class GivenFinalTest {

    private MasterControl masterControl;
    private List<String> input;

    @BeforeEach
    void setUp() {
        Bank bank = new Bank();
        CommandValidator validator = new CommandValidator(bank);
        CommandProcessor processor = new CommandProcessor(bank);
        CommandStorage storage = new CommandStorage();
        masterControl = new MasterControl(validator, processor, storage);
        input = new ArrayList<>();
    }

    @Test
    void sample_make_sure_this_passes_unchanged_or_you_will_fail() {
        input.add("Create savings 12345678 0.6");
        input.add("Deposit 12345678 700");
        input.add("Deposit 12345678 5000");
        input.add("creAte cHecKing 98765432 0.01");
        input.add("Deposit 98765432 300");
        input.add("Transfer 98765432 12345678 300");
        input.add("Pass 1");
        input.add("Create cd 23456789 1.2 2000");

        List<String> actual = masterControl.start(input);

        assertEquals(5, actual.size());
        assertEquals("Savings 12345678 1000.50 0.60", actual.get(0));
        assertEquals("Deposit 12345678 700", actual.get(1));
        assertEquals("Transfer 98765432 12345678 300", actual.get(2));
        assertEquals("Cd 23456789 2000.00 1.20", actual.get(3));
        assertEquals("Deposit 12345678 5000", actual.get(4));
    }

    @Test
    void accounts_are_output_in_creation_order() {
        input.add("create savings 11111111 0.6");
        input.add("create cd 22222222 1.2 2000");

        List<String> actual = masterControl.start(input);

        assertEquals("Savings 11111111 0.00 0.60", actual.get(0));
        assertEquals("Cd 22222222 2000.00 1.20", actual.get(1));
    }
}