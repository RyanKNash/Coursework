package banking;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class CommandProcessorTest {
    private Bank bank;
    private CommandProcessor processor;

    @BeforeEach
    void setUp() {
        bank = new Bank();
        processor = new CommandProcessor(bank);
    }

    @Test
    void create_checking_creates_account_in_bank() {
        processor.process("create checking 12345678 1.0");

        assertTrue(bank.accountExists(12345678));
        assertEquals(1.0, bank.getAccount(12345678).getApr());
    }

    @Test
    void create_with_qualified_type_name_creates_account_in_bank() {
        processor.process("create banking.Checking 12345678 1.0");

        assertTrue(bank.accountExists(12345678));
        assertEquals(1.0, bank.getAccount(12345678).getApr());
    }

    @Test
    void deposit_adds_money_to_existing_account() {
        bank.createChecking(12345678, 1.0);

        String result = processor.process("deposit 12345678 100");

        assertEquals("Deposit 12345678 100", result);
        assertEquals(100.0, bank.getAccount(12345678).getBalance());
    }

    @Test
    void transfer_command_moves_money_between_accounts() {
        bank.createChecking(12345678, 1.0);
        bank.createSavings(87654321, 2.0);
        bank.deposit(12345678, 100.0);

        String result = processor.process("transfer 12345678 87654321 40");

        assertEquals("Transfer 12345678 87654321 40", result);
        assertEquals(60.0, bank.getAccount(12345678).getBalance());
        assertEquals(40.0, bank.getAccount(87654321).getBalance());
    }

    @Test
    void pass_command_returns_null() {
        bank.createSavings(12345678, 0.6);
        bank.deposit(12345678, 1000.0);

        String result = processor.process("pass 1");

        assertNull(result);
    }

    @Test
    void pass_command_applies_time_to_accounts() {
        bank.createSavings(12345678, 0.6);
        bank.deposit(12345678, 1000.0);

        processor.process("pass 1");

        assertEquals(1000.50, bank.getAccount(12345678).getBalance(), 0.001);
    }

    @Test
    void unknown_command_returns_null() {
        String result = processor.process("unknown 123");

        assertNull(result);
    }

    @Test
    void deposit_to_nonexistent_account_returns_null() {
        String result = processor.process("deposit 12345678 100");

        assertNull(result);
    }

    @Test
    void transfer_more_than_balance_only_moves_available_amount() {
        bank.createChecking(12345678, 1.0);
        bank.createSavings(87654321, 2.0);
        bank.deposit(12345678, 50.0);

        processor.process("transfer 12345678 87654321 100");

        assertEquals(0.0, bank.getAccount(12345678).getBalance());
        assertEquals(50.0, bank.getAccount(87654321).getBalance());
    }

    @Test
    void commands_are_case_insensitive() {
        processor.process("CrEaTe checking 12345678 1.0");

        assertTrue(bank.accountExists(12345678));
    }

    @Test
    void transfer_to_nonexistent_account_returns_null() {
        bank.createChecking(12345678, 1.0);
        bank.deposit(12345678, 100.0);

        String result = processor.process("transfer 12345678 87654321 40");

        assertNull(result);
    }
}
