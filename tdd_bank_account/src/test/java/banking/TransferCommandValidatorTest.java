package banking;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

public class TransferCommandValidatorTest {

    private Bank bank;
    private TransferCommandValidator validator;

    @BeforeEach
    void setUp() {
        bank = new Bank();
        bank.createChecking(12345678, 1.0);
        bank.createSavings(87654321, 0.6);
        validator = new TransferCommandValidator(bank);
    }

    private TransferCommandValidator createValidatorWithBank(Bank customBank) {
        return new TransferCommandValidator(customBank);
    }

    private Bank createBankWithCheckingAndSavings() {
        Bank customBank = new Bank();
        customBank.createChecking(12345678, 1.0);
        customBank.createSavings(87654321, 1.0);
        return customBank;
    }

    @Test
    void transfer_command_with_four_tokens_is_valid() {
        String[] tokens = {"transfer", "12345678", "87654321", "50"};
        assertTrue(validator.validate(tokens));
    }

    @Test
    void transfer_command_with_too_few_tokens_is_invalid() {
        String[] tokens = {"transfer", "12345678", "87654321"};
        assertFalse(validator.validate(tokens));
    }

    @Test
    void transfer_command_with_too_many_tokens_is_invalid() {
        String[] tokens = {"transfer", "12345678", "87654321", "50", "extra"};
        assertFalse(validator.validate(tokens));
    }

    @Test
    void transfer_command_with_non_numeric_from_id_is_invalid() {
        String[] tokens = {"transfer", "abc", "87654321", "50"};
        assertFalse(validator.validate(tokens));
    }

    @Test
    void transfer_command_with_non_numeric_to_id_is_invalid() {
        String[] tokens = {"transfer", "12345678", "xyz", "50"};
        assertFalse(validator.validate(tokens));
    }

    @Test
    void transfer_command_with_non_numeric_amount_is_invalid() {
        String[] tokens = {"transfer", "12345678", "87654321", "amount"};
        assertFalse(validator.validate(tokens));
    }

    @Test
    void transfer_command_with_zero_amount_is_invalid() {
        String[] tokens = {"transfer", "12345678", "87654321", "0"};
        assertFalse(validator.validate(tokens));
    }

    @Test
    void transfer_command_with_negative_amount_is_invalid() {
        String[] tokens = {"transfer", "12345678", "87654321", "-5"};
        assertFalse(validator.validate(tokens));
    }

    @Test
    void transfer_command_is_invalid_when_source_account_does_not_exist() {
        String[] tokens = {"transfer", "11111111", "87654321", "50"};
        assertFalse(validator.validate(tokens));
    }

    @Test
    void transfer_command_is_invalid_when_destination_account_does_not_exist() {
        String[] tokens = {"transfer", "12345678", "22222222", "50"};
        assertFalse(validator.validate(tokens));
    }

    @Test
    void transfer_command_invalid_when_same_account() {
        String[] tokens = {"transfer", "12345678", "12345678", "50"};
        assertFalse(validator.validate(tokens));
    }

    @Test
    void transfer_from_cd_account_is_invalid() {
        bank.createCd(11112222, 1.2, 2000);

        String[] tokens = {"transfer", "11112222", "87654321", "50"};

        assertFalse(validator.validate(tokens));
    }

    @Test
    void transfer_to_cd_account_is_invalid() {
        bank.createCd(11112222, 1.2, 2000);

        String[] tokens = {"transfer", "12345678", "11112222", "50"};

        assertFalse(validator.validate(tokens));
    }

    @Test
    public void transfer_with_non_integer_source_id_is_invalid() {
        TransferCommandValidator validator = createValidatorWithBank(createBankWithCheckingAndSavings());
        String[] tokens = {"transfer", "abc12345", "87654321", "100"};

        assertFalse(validator.validate(tokens));
    }

    @Test
    public void transfer_with_non_integer_destination_id_is_invalid() {
        TransferCommandValidator validator = createValidatorWithBank(createBankWithCheckingAndSavings());
        String[] tokens = {"transfer", "12345678", "xyz54321", "100"};

        assertFalse(validator.validate(tokens));
    }

    @Test
    public void transfer_command_invalid_when_ids_not_8_digits() {
        TransferCommandValidator validator = createValidatorWithBank(createBankWithCheckingAndSavings());
        String[] tokens = {"transfer", "1234", "87654321", "100"};

        assertFalse(validator.validate(tokens));
    }

    @Test
    public void transfer_command_invalid_when_destination_id_not_8_digits() {
        TransferCommandValidator validator = createValidatorWithBank(createBankWithCheckingAndSavings());
        String[] tokens = {"transfer", "12345678", "8765", "100"};

        assertFalse(validator.validate(tokens));
    }

    @Test
    public void transfer_command_invalid_when_existing_accounts_do_not_have_8_digit_ids() {
        Bank customBank = new Bank();
        customBank.createChecking(1234567, 1.0);
        customBank.createSavings(2345678, 1.0);
        TransferCommandValidator validator = createValidatorWithBank(customBank);
        String[] tokens = {"transfer", "1234567", "2345678", "100"};

        assertFalse(validator.validate(tokens));
    }

    @Test
    void transfer_command_with_decimal_amount_is_invalid() {
        String[] tokens = {"transfer", "12345678", "87654321", "10.5"};
        assertFalse(validator.validate(tokens));
    }

    @Test
    void transfer_command_with_large_amount_is_valid() {
        String[] tokens = {"transfer", "12345678", "87654321", "999999"};
        assertTrue(validator.validate(tokens));
    }
}
