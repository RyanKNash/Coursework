package banking;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;

public class CheckingTest {

    private Checking checking;
    private CreateCommandValidator createValidator;

    @BeforeEach
    public void setUp() {
        Bank bank = new Bank();
        checking = new Checking(12345678, 4.2);
        createValidator = new CreateCommandValidator(bank);
    }

    @Test
    public void checking_account_created_with_zero_balance() {
        assertEquals(0.0, checking.getBalance());
    }

    @Test
    public void checking_account_created_with_apr_value() {
        assertEquals(4.2, checking.getApr());
    }

    @Test
    public void depositing_money_increases_balance() {
        checking.deposit(50.0);
        assertEquals(50.0, checking.getBalance());
    }

    @Test
    public void depositing_decimal_money_increases_balance() {
        checking.deposit(100.54);
        assertEquals(100.54, checking.getBalance());
    }

    @Test
    public void withdrawing_money_decreases_balance() {
        checking.deposit(100.0);
        checking.withdraw(40.0);
        assertEquals(60.0, checking.getBalance());
    }

    @Test
    public void withdrawing_decimal_money_decreases_balance() {
        checking.deposit(100.75);
        checking.withdraw(0.50);
        assertEquals(100.25, checking.getBalance());
    }

    @Test
    public void withdrawing_more_than_balance_sets_balance_to_zero() {
        checking.deposit(100.0);
        checking.withdraw(200.0);
        assertEquals(0.0, checking.getBalance());
    }

    @Test
    public void depositing_twice_works_as_expected() {
        checking.deposit(25.0);
        checking.deposit(10.0);
        assertEquals(35.0, checking.getBalance());
    }

    @Test
    public void withdrawing_twice_works_as_expected() {
        checking.deposit(100.0);
        checking.withdraw(30.0);
        checking.withdraw(20.0);
        assertEquals(50.0, checking.getBalance());
    }

    @Test
    void checking_account_rejects_extra_tokens() {
        String[] tokens = {"create", "checking", "12345678", "1.0", "999"};
        assertFalse(createValidator.validate(tokens));
    }

    @Test
    public void checking_deposit_above_limit_is_rejected() {
        checking.deposit(1500.0);

        assertEquals(0.0, checking.getBalance());
    }

    @Test
    public void checking_withdraw_above_limit_is_rejected() {
        checking.deposit(1000.0);

        checking.withdraw(500.0);

        assertEquals(1000.0, checking.getBalance());
    }

    @Test
    public void withdrawing_zero_does_not_change_balance() {
        checking.deposit(100.0);

        checking.withdraw(0.0);

        assertEquals(100.0, checking.getBalance());
    }

    @Test
    public void deposit_of_one_dollar_updates_balance() {
        checking.deposit(1.0);
        assertEquals(1.0, checking.getBalance());
    }

    @Test
    public void withdraw_of_one_dollar_updates_balance() {
        checking.deposit(10.0);
        checking.withdraw(1.0);
        assertEquals(9.0, checking.getBalance());
    }

    @Test
    public void deposit_exact_limit_is_allowed() {
        checking.deposit(1000.0);
        assertEquals(1000.0, checking.getBalance());
    }

    @Test
    public void withdraw_exact_limit_is_allowed() {
        checking.deposit(1000.0);
        checking.withdraw(400.0);
        assertEquals(600.0, checking.getBalance());
    }

    @Test
    public void withdraw_above_limit_is_rejected() {
        checking.deposit(1000.0);
        checking.withdraw(401.0);
        assertEquals(1000.0, checking.getBalance());
    }

    @Test
    public void withdrawing_exact_balance_sets_balance_to_zero() {
        Checking account = new Checking(12345678, 1.0);

        account.deposit(100.0);
        account.withdraw(100.0);

        assertEquals(0.0, account.getBalance());
    }
}