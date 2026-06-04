package banking;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

public class MasterControlTest {

    private MasterControl masterControl;
    private Bank bank;
    private CommandValidator validator;
    private CommandProcessor processor;
    private CommandStorage storage;
    private List<String> input;

    @BeforeEach
    void setUp() {
        bank = new Bank();
        validator = new CommandValidator(bank);
        processor = new CommandProcessor(bank);
        storage = new CommandStorage();
        masterControl = new MasterControl(validator, processor, storage);
        input = new ArrayList<>();
    }

    private void assertSingleCommand(String command, List<String> actual) {
        assertEquals(1, actual.size());
        assertEquals(command, actual.get(0));
    }

    private void assertInvalidOutput(List<String> actual, String... expected) {
        assertEquals(expected.length, actual.size());
        for (int i = 0; i < expected.length; i++) {
            assertEquals(expected[i], actual.get(i));
        }
    }

    private MasterControl createMasterControl(Bank customBank, CommandStorage customStorage) {
        CommandValidator customValidator = new CommandValidator(customBank);
        CommandProcessor customProcessor = new CommandProcessor(customBank);
        return new MasterControl(customValidator, customProcessor, customStorage);
    }

    private MasterControl createPassOutputMasterControl(Bank customBank) {
        CommandValidator permissiveValidator = new CommandValidator(customBank) {
            @Override
            public boolean validate(String command) {
                return true;
            }
        };

        CommandProcessor scriptedProcessor = new CommandProcessor(customBank) {
            @Override
            public String process(String command) {
                if (command.equalsIgnoreCase("transfer 12345678 87654321 50")) {
                    return "Transfer 12345678 87654321 50";
                }

                if (command.equalsIgnoreCase("pass 1")) {
                    return null;
                }

                return super.process(command);
            }
        };

        return new MasterControl(permissiveValidator, scriptedProcessor, new CommandStorage());
    }

    @Test
    void typo_in_create_command_is_invalid() {
        input.add("creat checking 12345678 1.0");

        List<String> actual = masterControl.start(input);

        assertSingleCommand("creat checking 12345678 1.0", actual);
    }

    @Test
    void typo_in_deposit_command_is_invalid() {
        input.add("depposit 12345678 100");

        List<String> actual = masterControl.start(input);

        assertSingleCommand("depposit 12345678 100", actual);
    }

    @Test
    void two_typo_commands_both_invalid() {
        input.add("creat checking 12345678 1.0");
        input.add("depposit 12345678 100");

        List<String> actual = masterControl.start(input);

        assertInvalidOutput(actual,
                "creat checking 12345678 1.0",
                "depposit 12345678 100"
        );
    }

    @Test
    void three_typo_commands_all_invalid() {
        input.add("creat checking 12345678 1.0");
        input.add("depposit 12345678 100");
        input.add("dep five ten");

        List<String> actual = masterControl.start(input);

        assertInvalidOutput(actual,
                "creat checking 12345678 1.0",
                "depposit 12345678 100",
                "dep five ten"
        );
    }

    @Test
    void invalid_to_create_accounts_with_same_ID() {
        input.add("create checking 12345678 1.0");
        input.add("create checking 12345678 1.0");

        List<String> actual = masterControl.start(input);

        assertSingleCommand("create checking 12345678 1.0", actual);
    }

    @Test
    void deposit_success_outputs_message() {
        input.add("create checking 12345678 1.0");
        input.add("deposit 12345678 100");

        List<String> actual = masterControl.start(input);

        assertEquals(1, actual.size());
        assertEquals("Deposit 12345678 100", actual.get(0));
    }

    @Test
    void deposit_output_is_normalized() {
        input.add("CREATE checking 12345678 1.0");
        input.add("  DePoSiT 12345678 100   ");

        List<String> actual = masterControl.start(input);

        assertEquals(1, actual.size());
        assertEquals("Deposit 12345678 100", actual.get(0));
    }

    @Test
    void create_commands_do_not_output_messages() {
        input.add("create checking 12345678 1.0");
        input.add("create savings 87654321 0.6");
        input.add("create cd 23456789 1.2 2000");

        List<String> actual = masterControl.start(input);

        assertEquals(2, actual.size());
        assertTrue(actual.contains("Savings 87654321 0.00 0.60"));
        assertTrue(actual.contains("Cd 23456789 2000.00 1.20"));
        assertFalse(actual.contains("Checking 12345678 0.00 1.00"));

        for (String line : actual) {
            assertFalse(line.toLowerCase().startsWith("create"));
        }
    }

    @Test
    void transfer_success_outputs_message() {
        input.add("create checking 12345678 1.0");
        input.add("create savings 87654321 0.6");
        input.add("deposit 12345678 300");
        input.add("transfer 12345678 87654321 300");

        List<String> actual = masterControl.start(input);

        assertTrue(actual.contains("Transfer 12345678 87654321 300"));
    }

    @Test
    void pass_time_produces_no_output() {
        input.add("create savings 12345678 0.6");
        input.add("deposit 12345678 1000");
        input.add("pass 1");

        List<String> actual = masterControl.start(input);

        for (String line : actual) {
            assertFalse(line.toLowerCase().startsWith("pass"));
        }
    }

    @Test
    void outputs_savings_account_summary_in_required_format() {
        input.add("create savings 12345678 0.6");

        List<String> actual = masterControl.start(input);

        assertTrue(actual.contains("Savings 12345678 0.00 0.60"));
    }

    @Test
    void outputs_cd_account_summary_in_required_format() {
        input.add("create cd 23456789 1.2 2000");

        List<String> actual = masterControl.start(input);

        assertTrue(actual.contains("Cd 23456789 2000.00 1.20"));
    }

    @Test
    void does_not_output_checking_account_when_balance_is_zero() {
        input.add("create checking 98765432 0.01");

        List<String> actual = masterControl.start(input);

        for (String line : actual) {
            assertFalse(line.startsWith("Checking 98765432"));
        }
    }

    @Test
    void invalid_command_is_saved_in_command_storage() {
        input.add("creat checking 12345678 1.0");

        masterControl.start(input);

        assertTrue(storage.getInvalidCommands().contains("creat checking 12345678 1.0"));
    }

    @Test
    void transfer_to_same_account_is_invalid() {
        input.add("create checking 12345678 1.0");
        input.add("transfer 12345678 12345678 50");

        List<String> actual = masterControl.start(input);

        assertTrue(actual.contains("transfer 12345678 12345678 50"));
    }

    @Test
    void invalid_commands_appear_after_account_output() {
        input.add("create savings 12345678 0.6");
        input.add("bad command");

        List<String> actual = masterControl.start(input);

        assertEquals("Savings 12345678 0.00 0.60", actual.get(0));
        assertEquals("bad command", actual.get(1));
    }

    @Test
    void transfer_to_self_is_invalid_command() {
        input.add("create checking 1 1.0");
        input.add("transfer 1 1 50");

        List<String> actual = masterControl.start(input);

        assertTrue(actual.contains("transfer 1 1 50"));
    }

    @Test
    public void transfer_output_when_only_source_account_should_be_reported() {
        Bank customBank = new Bank();
        customBank.createChecking(12345678, 1.0);
        customBank.createChecking(87654321, 1.0);

        customBank.deposit(12345678, 500);

        MasterControl mc = createMasterControl(customBank, new CommandStorage());

        List<String> input = List.of(
                "transfer 12345678 87654321 200"
        );

        List<String> output = mc.start(input);

        assertTrue(output.get(0).toLowerCase().contains("transfer"));
    }

    @Test
    public void transfer_output_when_only_destination_account_should_be_reported() {
        Bank customBank = new Bank();
        customBank.createChecking(12345678, 1.0);
        customBank.createChecking(87654321, 1.0);

        customBank.deposit(87654321, 300);

        MasterControl mc = createMasterControl(customBank, new CommandStorage());

        List<String> input = List.of(
                "transfer 12345678 87654321 100"
        );

        List<String> output = mc.start(input);

        assertTrue(output.get(0).toLowerCase().contains("transfer"));
    }

    @Test
    void pass_output_omits_transfer_when_neither_account_exists() {
        MasterControl mc = createPassOutputMasterControl(new Bank());

        List<String> output = mc.start(List.of(
                "transfer 12345678 87654321 50",
                "pass 1"
        ));

        assertTrue(output.isEmpty());
    }

    @Test
    void pass_output_omits_transfer_when_source_checking_has_zero_balance_and_destination_missing() {
        Bank customBank = new Bank();
        customBank.createChecking(12345678, 1.0);
        MasterControl mc = createPassOutputMasterControl(customBank);

        List<String> output = mc.start(List.of(
                "transfer 12345678 87654321 50",
                "pass 1"
        ));

        assertTrue(output.isEmpty());
    }


}
