package banking;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.junit.jupiter.api.Assertions.assertFalse;

public class PassCommandTest {

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
    void pass_time_updates_savings_balance_in_summary() {
        input.add("create savings 12345678 0.6");
        input.add("deposit 12345678 1000");
        input.add("pass 1");

        List<String> actual = masterControl.start(input);

        assertTrue(actual.contains("Savings 12345678 1000.50 0.60"));
    }

    @Test
    void pass_time_updates_cd_balance_in_summary() {
        input.add("create cd 23456789 1.2 2000");
        input.add("pass 1");

        List<String> actual = masterControl.start(input);

        assertTrue(actual.contains("Cd 23456789 2002.00 1.20"));
    }

    @Test
    void pass_time_updates_checking_balance_in_summary() {
        input.add("create checking 98765432 1.0");
        input.add("deposit 98765432 1000");
        input.add("pass 1");

        List<String> actual = masterControl.start(input);

        assertTrue(actual.contains("Checking 98765432 1000.83 1.00"));
    }

@Test
void pass_zero_months_is_reported_invalid_for_savings_scenario() {
    input.add("create savings 12345678 0.6");
    input.add("deposit 12345678 1000");
    input.add("pass 0");

    List<String> actual = masterControl.start(input);

    assertTrue(actual.contains("Savings 12345678 1000.00 0.60"));
    assertTrue(actual.contains("pass 0"));
}

@Test
void pass_zero_months_is_reported_invalid_for_cd_scenario() {
    input.add("create cd 23456789 1.2 2000");
    input.add("pass 0");

    List<String> actual = masterControl.start(input);

    assertTrue(actual.contains("Cd 23456789 2000.00 1.20"));
    assertTrue(actual.contains("pass 0"));
}

@Test
void pass_zero_months_is_reported_invalid_for_checking_scenario() {
    input.add("create checking 98765432 1.0");
    input.add("deposit 98765432 1000");
    input.add("pass 0");

    List<String> actual = masterControl.start(input);

    assertTrue(actual.contains("Checking 98765432 1000.00 1.00"));
    assertTrue(actual.contains("pass 0"));
}

    @Test
    void pass_many_months_updates_savings_balance_multiple_times() {
        input.add("create savings 12345678 0.6");
        input.add("deposit 12345678 1000");
        input.add("pass 3");

        List<String> actual = masterControl.start(input);

        assertTrue(actual.contains("Savings 12345678 1001.50 0.60"));
    }

    @Test
    void pass_many_months_updates_cd_balance_multiple_times() {
        input.add("create cd 23456789 1.2 2000");
        input.add("pass 3");

        List<String> actual = masterControl.start(input);

        assertTrue(actual.contains("Cd 23456789 2006.01 1.20"));
    }

    @Test
    void pass_many_months_updates_checking_balance_multiple_times() {
        input.add("create checking 98765432 1.0");
        input.add("deposit 98765432 1000");
        input.add("pass 3");

        List<String> actual = masterControl.start(input);

        assertTrue(actual.contains("Checking 98765432 1002.50 1.00"));
    }

    @Test
    void pass_boundary_one_month_applies_exactly_once_to_savings() {
        input.add("create savings 12345678 0.6");
        input.add("deposit 12345678 1000");
        input.add("pass 1");

        List<String> actual = masterControl.start(input);

        assertFalse(actual.contains("Savings 12345678 1001.00 0.60"));
        assertTrue(actual.contains("Savings 12345678 1000.50 0.60"));
    }

    @Test
    void pass_boundary_one_month_applies_exactly_once_to_checking() {
        input.add("create checking 98765432 1.0");
        input.add("deposit 98765432 1000");
        input.add("pass 1");

        List<String> actual = masterControl.start(input);

        assertFalse(actual.contains("Checking 98765432 1001.67 1.00"));
        assertTrue(actual.contains("Checking 98765432 1000.83 1.00"));
    }

    @Test
    void pass_applies_to_multiple_accounts_in_same_run() {
        input.add("create savings 12345678 0.6");
        input.add("deposit 12345678 1000");
        input.add("create cd 23456789 1.2 2000");
        input.add("pass 1");

        List<String> actual = masterControl.start(input);

        assertTrue(actual.contains("Savings 12345678 1000.50 0.60"));
        assertTrue(actual.contains("Cd 23456789 2002.00 1.20"));
    }

    @Test
    void invalid_pass_command_is_reported() {
        input.add("pass -1");

        List<String> actual = masterControl.start(input);

        assertTrue(actual.contains("pass -1"));
    }

    @Test
    void invalid_pass_command_with_non_numeric_value_is_reported() {
        input.add("pass abc");

        List<String> actual = masterControl.start(input);

        assertTrue(actual.contains("pass abc"));
    }

    @Test
    void pass_with_no_accounts_returns_no_account_summary_lines() {
        input.add("pass 1");

        List<String> actual = masterControl.start(input);

        assertTrue(actual.isEmpty());
    }

    @Test
    void pass_simple_savings_scenario_keeps_apr_formatting_to_two_decimals() {
        input.add("create savings 12345678 0.6");
        input.add("deposit 12345678 1000");
        input.add("pass 1");

        List<String> actual = masterControl.start(input);

        assertTrue(actual.contains("Savings 12345678 1000.50 0.60"));
    }

    @Test
    void pass_command_with_too_few_tokens_is_reported_invalid() {
        input.add("pass");

        List<String> actual = masterControl.start(input);

        assertTrue(actual.contains("pass"));
    }

    @Test
    void pass_command_with_too_many_tokens_is_reported_invalid() {
        input.add("pass 1 extra");

        List<String> actual = masterControl.start(input);

        assertTrue(actual.contains("pass 1 extra"));
    }

    @Test
    void account_with_zero_balance_is_closed_after_pass_time() {
        input.add("create checking 12345678 1.0");
        input.add("pass 1");

        List<String> actual = masterControl.start(input);

        assertTrue(actual.isEmpty());
    }

    @Test
    void account_below_100_balance_is_charged_fee_then_apr() {
        input.add("create savings 12345678 0.6");
        input.add("deposit 12345678 50");
        input.add("pass 1");

        List<String> actual = masterControl.start(input);

        assertTrue(actual.contains("Savings 12345678 25.01 0.60"));
    }

    @Test
    void pass_sixty_months_is_valid() {
        input.add("create savings 12345678 0.6");
        input.add("deposit 12345678 1000");
        input.add("pass 60");

        List<String> actual = masterControl.start(input);

        assertTrue(actual.stream().anyMatch(line -> line.startsWith("Savings 12345678 ")));
    }

    @Test
    void pass_sixty_one_months_is_invalid() {
        input.add("create savings 12345678 0.6");
        input.add("deposit 12345678 1000");
        input.add("pass 61");

        List<String> actual = masterControl.start(input);

        assertTrue(actual.contains("Savings 12345678 1000.00 0.60"));
        assertTrue(actual.contains("pass 61"));
    }

    @Test
    void pass_decimal_months_is_invalid() {
        input.add("create savings 12345678 0.6");
        input.add("deposit 12345678 1000");
        input.add("pass 6.0");

        List<String> actual = masterControl.start(input);

        assertTrue(actual.contains("Savings 12345678 1000.00 0.60"));
        assertTrue(actual.contains("pass 6.0"));
    }
}
