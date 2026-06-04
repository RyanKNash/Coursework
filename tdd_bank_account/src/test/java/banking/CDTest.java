package banking;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;

public class CDTest {

    private CD cd;
    private CreateCommandValidator createValidator;

    @BeforeEach
    public void setUp() {
        Bank bank = new Bank();
        cd = new CD(12345678, 4.2, 1000.0);
        createValidator = new CreateCommandValidator(bank);
    }

    @Test
    public void cd_account_created_with_supplied_balance() {
        assertEquals(1000.0, cd.getBalance());
    }

    @Test
    public void cd_account_created_with_apr_value() {
        assertEquals(4.2, cd.getApr());
    }

    @Test
    void cd_account_requires_five_tokens() {
        String[] tokens = {"create", "cd", "12345678", "1.0"};
        assertFalse(createValidator.validate(tokens));
    }

    @Test
    public void depositing_into_cd_does_not_change_balance() {
        cd.deposit(500.0);
        assertEquals(1000.0, cd.getBalance());
    }

    @Test
    public void withdrawing_from_cd_before_maturity_does_not_change_balance() {
        cd.withdraw(500.0);
        assertEquals(1000.0, cd.getBalance());
    }

    @Test
    public void withdrawing_less_than_balance_after_maturity_is_invalid() {
        cd.passTime(12);

        cd.withdraw(500.0);

        assertEquals(1000.0, cd.getBalance());
    }

    @Test
    public void withdrawing_full_balance_after_maturity_sets_balance_to_zero() {
        cd.passTime(12);

        cd.withdraw(1000.0);

        assertEquals(0.0, cd.getBalance());
    }

    @Test
    public void depositing_zero_into_cd_does_not_change_balance() {
        cd.deposit(0.0);
        assertEquals(1000.0, cd.getBalance());
    }

    @Test
    public void withdrawing_zero_from_cd_does_not_change_balance() {
        cd.withdraw(0.0);
        assertEquals(1000.0, cd.getBalance());
    }

    @Test
    public void cd_balance_remains_same_when_multiple_invalid_withdrawals_attempted() {
        cd.withdraw(100.0);
        cd.withdraw(200.0);
        assertEquals(1000.0, cd.getBalance());
    }

    @Test
    public void cd_balance_unchanged_after_multiple_invalid_deposits() {
        cd.deposit(10.0);
        cd.deposit(20.0);
        assertEquals(1000.0, cd.getBalance());
    }

    @Test
    public void withdrawing_more_than_balance_after_maturity_sets_balance_to_zero() {
        cd.passTime(12);

        cd.withdraw(1500.0);

        assertEquals(0.0, cd.getBalance());
    }

    @Test
    public void withdrawing_zero_after_maturity_is_invalid_and_does_not_change_balance() {
        cd.passTime(12);

        cd.withdraw(0.0);

        assertEquals(1000.0, cd.getBalance());
    }

    @Test
    public void cd_withdraw_after_11_months_is_invalid() {
        cd.passTime(11);

        cd.withdraw(1000);

        assertEquals(1000.0, cd.getBalance());
    }
}
