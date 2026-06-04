package banking;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class CommandValidatorTest {
    private Bank bank;
    private CommandValidator commandValidator;
    private CreateCommandValidator createValidator;

    @BeforeEach
    void setUp() {
        bank = new Bank();
        commandValidator = new CommandValidator(bank);
        createValidator = new CreateCommandValidator(bank);
    }

    private CreateCommandValidator createCreateValidator() {
        return new CreateCommandValidator(new Bank());
    }

    private DepositCommandValidator createDepositValidator() {
        return new DepositCommandValidator(new Bank());
    }

    private DepositCommandValidator createDepositValidatorWithChecking() {
        Bank customBank = new Bank();
        customBank.createChecking(12345678, 1.0);
        return new DepositCommandValidator(customBank);
    }

    private DepositCommandValidator createDepositValidatorWithSavings() {
        Bank customBank = new Bank();
        customBank.createSavings(12345678, 1.0);
        return new DepositCommandValidator(customBank);
    }

    private DepositCommandValidator createDepositValidatorWithCd() {
        Bank customBank = new Bank();
        customBank.createCd(12345678, 1.2, 2000);
        return new DepositCommandValidator(customBank);
    }

    @Test
    void invalid_null_command() {
        assertFalse(commandValidator.validate(null));
    }

    @Test
    void create_missing_args_is_invalid() {
        assertFalse(commandValidator.validate("create checking"));
        assertFalse(commandValidator.validate("create savings"));
        assertFalse(commandValidator.validate("create cd"));
    }

    @Test
    void create_valid_checking_command() {
        assertTrue(commandValidator.validate("create checking 12345678 1.0"));
    }

    @Test
    void create_valid_savings_command() {
        assertTrue(commandValidator.validate("create savings 87654321 2.5"));
    }

    @Test
    void create_valid_cd_command() {
        assertTrue(commandValidator.validate("create cd 11223344 1.5 1000"));
    }

    @Test
    void create_invalid_wrong_verb() {
        assertFalse(commandValidator.validate("make savings"));
        assertFalse(commandValidator.validate("new savings"));
    }

    @Test
    void create_invalid_missing_account_type() {
        assertFalse(commandValidator.validate("create"));
        assertFalse(commandValidator.validate("create "));
    }

    @Test
    void create_invalid_unknown_account_type() {
        assertFalse(commandValidator.validate("create brokerage"));
        assertFalse(commandValidator.validate("create savingss"));
    }

    @Test
    void create_invalid_extra_tokens() {
        assertFalse(commandValidator.validate("create savings extra"));
        assertFalse(commandValidator.validate("create checking 123"));
    }

    @Test
    void create_case_insensitive_if_required() {
        assertTrue(commandValidator.validate("CREATE SAVINGS 13547895 1"));
        assertTrue(commandValidator.validate("Create banking.Savings 13547895 1"));
    }

    @Test
    void deposit_valid_basic_command() {
        assertTrue(commandValidator.validate("deposit 12345678 10"));
        assertTrue(commandValidator.validate("deposit 87654321 500"));
    }

    @Test
    void deposit_invalid_missing_account_number_or_amount() {
        assertFalse(commandValidator.validate("deposit"));
        assertFalse(commandValidator.validate("deposit 12345678"));
    }

    @Test
    void deposit_invalid_non_numeric_account_number() {
        assertFalse(commandValidator.validate("deposit abc 10"));
        assertFalse(commandValidator.validate("deposit 12ab 10"));
    }

    @Test
    void deposit_invalid_non_numeric_amount() {
        assertFalse(commandValidator.validate("deposit 12345678 ten"));
        assertFalse(commandValidator.validate("deposit 12345678 10.5.2"));
    }

    @Test
    void deposit_invalid_negative_or_zero_amount() {
        assertFalse(commandValidator.validate("deposit 12345678 -10"));
        assertFalse(commandValidator.validate("deposit 12345678 0"));
    }

    @Test
    void deposit_invalid_extra_tokens() {
        assertFalse(commandValidator.validate("deposit 12345678 10 extra"));
    }

    @Test
    void deposit_with_leading_and_trailing_spaces_still_works() {
        assertTrue(commandValidator.validate("  deposit 12345678 10  "));
    }

    @Test
    void invalid_non_supported_command_should_be_false() {
        assertFalse(commandValidator.validate("withdraw 12345678 10"));
        assertFalse(commandValidator.validate("transfer 12345678 87654321 10"));
    }

    @Test
    void pass_valid_basic_command() {
        assertTrue(commandValidator.validate("pass 1"));
    }

    @Test
    void commandValidator_returns_false_for_empty_or_whitespace() {
        assertFalse(commandValidator.validate(""));
        assertFalse(commandValidator.validate("   "));
    }

    @Test
    void create_validator_returns_false_for_wrong_verb() {
        String[] tokens = {"deposit", "checking", "12345678", "0.6"};
        assertFalse(createValidator.validate(tokens));
    }

    @Test
    void unknown_account_type_is_rejected() {
        String[] tokens = {"create", "moneyMarket", "12345678", "1.0"};
        assertFalse(createValidator.validate(tokens));
    }

    @Test
    void non_numeric_fields_throw_number_format_and_return_false() {
        String[] tokens = {"create", "checking", "notANumber", "1.0"};
        assertFalse(createValidator.validate(tokens));
    }

    @Test
    void create_invalid_id_not_8_digits() {
        assertFalse(commandValidator.validate("create checking 123 1.0"));
        assertFalse(commandValidator.validate("create checking 123456789 1.0"));
    }

    @Test
    void create_invalid_apr_out_of_range() {
        assertFalse(commandValidator.validate("create checking 12345678 -1"));
        assertFalse(commandValidator.validate("create checking 12345678 11"));
    }

    @Test
    void create_cd_invalid_below_minimum_balance() {
        assertFalse(commandValidator.validate("create cd 12345678 1.2 500"));
    }

    @Test
    void create_cd_invalid_above_maximum_balance() {
        assertFalse(commandValidator.validate("create cd 12345678 1.2 20000"));
    }
    
    @Test
    void command_with_extra_internal_spaces_is_invalid() {
        assertFalse(commandValidator.validate("create  checking 12345678 1.0"));
    }

    @Test
    void command_with_trailing_spaces_is_valid() {
        assertTrue(commandValidator.validate("create checking 12345678 1.0   "));
    }

    @Test
    public void create_command_with_apr_equal_to_zero_is_valid() {
        CreateCommandValidator validator = createCreateValidator();
        String[] tokens = {"create", "savings", "12345678", "0"};

        assertTrue(validator.validate(tokens));
    }

    @Test
    public void create_command_with_apr_equal_to_ten_is_valid() {
        CreateCommandValidator validator = createCreateValidator();
        String[] tokens = {"create", "checking", "12345678", "10"};

        assertTrue(validator.validate(tokens));
    }

    @Test
    public void create_cd_with_initial_balance_equal_to_one_thousand_is_valid() {
        CreateCommandValidator validator = createCreateValidator();
        String[] tokens = {"create", "cd", "12345678", "1.2", "1000"};

        assertTrue(validator.validate(tokens));
    }

    @Test
    public void create_cd_with_initial_balance_equal_to_ten_thousand_is_valid() {
        CreateCommandValidator validator = createCreateValidator();
        String[] tokens = {"create", "cd", "12345678", "1.2", "10000"};

        assertTrue(validator.validate(tokens));
    }

    @Test
    public void deposit_with_id_not_8_digits_is_invalid() {
        DepositCommandValidator validator = createDepositValidator();
        String[] tokens = {"deposit", "1234567", "100"};

        assertFalse(validator.validate(tokens));
    }

    @Test
    public void deposit_to_cd_account_is_invalid() {
        DepositCommandValidator validator = createDepositValidatorWithCd();
        String[] tokens = {"deposit", "12345678", "100"};

        assertFalse(validator.validate(tokens));
    }

    @Test
    public void deposit_to_checking_above_limit_is_invalid() {
        DepositCommandValidator validator = createDepositValidatorWithChecking();
        String[] tokens = {"deposit", "12345678", "1001"};

        assertFalse(validator.validate(tokens));
    }

    @Test
    public void deposit_to_checking_at_limit_is_valid() {
        DepositCommandValidator validator = createDepositValidatorWithChecking();
        String[] tokens = {"deposit", "12345678", "1000"};

        assertTrue(validator.validate(tokens));
    }

    @Test
    public void deposit_to_savings_above_limit_is_invalid() {
        DepositCommandValidator validator = createDepositValidatorWithSavings();
        String[] tokens = {"deposit", "12345678", "2501"};

        assertFalse(validator.validate(tokens));
    }

    @Test
    public void deposit_to_savings_at_limit_is_valid() {
        DepositCommandValidator validator = createDepositValidatorWithSavings();
        String[] tokens = {"deposit", "12345678", "2500"};

        assertTrue(validator.validate(tokens));
    }

    @Test
    public void deposit_with_non_integer_id_is_invalid() {
        DepositCommandValidator validator = createDepositValidator();
        String[] tokens = {"deposit", "abcd1234", "100"};

        assertFalse(validator.validate(tokens));
    }

    @Test
    public void deposit_with_non_double_amount_is_invalid() {
        DepositCommandValidator validator = createDepositValidator();
        String[] tokens = {"deposit", "12345678", "abc"};

        assertFalse(validator.validate(tokens));
    }

    @Test
    public void deposit_with_zero_amount_is_invalid() {
        DepositCommandValidator validator = createDepositValidator();
        String[] tokens = {"deposit", "12345678", "0"};

        assertFalse(validator.validate(tokens));
    }

    @Test
    public void create_invalid_apr_not_a_number_returns_false() {
        CreateCommandValidator validator = createCreateValidator();
        String[] tokens = {"create", "checking", "12345678", "abc"};

        assertFalse(validator.validate(tokens));
    }

    @Test
    public void create_cd_invalid_initial_amount_not_number_returns_false() {
        CreateCommandValidator validator = createCreateValidator();
        String[] tokens = {"create", "cd", "12345678", "1.0", "notnumber"};

        assertFalse(validator.validate(tokens));
    }

    @Test
    public void create_invalid_id_not_integer_returns_false() {
        CreateCommandValidator validator = createCreateValidator();
        String[] tokens = {"create", "checking", "abcdefgh", "1.0"};

        assertFalse(validator.validate(tokens));
    }

    @Test
    public void create_cd_invalid_initial_balance_with_letters_returns_false() {
        CreateCommandValidator validator = createCreateValidator();
        String[] tokens = {"create", "cd", "12345678", "1.0", "abc123"};

        assertFalse(validator.validate(tokens));
    }
}
