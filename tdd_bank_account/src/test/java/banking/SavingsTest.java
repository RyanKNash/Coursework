package banking;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

public class SavingsTest {

    private Savings savings;

    @BeforeEach
    public void setUp() {
        savings = new Savings(12345678, 4.2);
    }

    @Test
    public void savings_account_created_with_zero_balance() {
        assertEquals(0.0, savings.getBalance());
    }

    @Test
    public void savings_account_created_with_apr_value() {
        assertEquals(4.2, savings.getApr());
    }

    @Test
    public void depositing_money_increases_balance() {
        savings.deposit(50.0);
        assertEquals(50.0, savings.getBalance());
    }

    @Test
    public void depositing_decimal_money_increases_balance() {
        savings.deposit(2005.54);
        assertEquals(2005.54, savings.getBalance());
    }

    @Test
    public void withdrawing_money_decreases_balance() {
        savings.deposit(100.0);
        savings.withdraw(40.0);
        assertEquals(60.0, savings.getBalance());
    }

    @Test
    public void withdrawing_decimal_money_decreases_balance() {
        savings.deposit(100.75);
        savings.withdraw(0.50);
        assertEquals(100.25, savings.getBalance());
    }

    @Test
    public void withdrawing_more_than_balance_sets_balance_to_zero() {
        savings.deposit(100.0);
        savings.withdraw(200.0);
        assertEquals(0.0, savings.getBalance());
    }

    @Test
    public void depositing_twice_works_as_expected() {
        savings.deposit(25.0);
        savings.deposit(10.0);
        assertEquals(35.0, savings.getBalance());
    }

    @Test
    public void withdrawing_twice_works_as_expected() {
        savings.deposit(100.0);
        savings.withdraw(30.0);
        savings.withdraw(20.0);
        assertEquals(50.0, savings.getBalance());
    }

    @Test
    public void withdrawing_exact_balance_sets_savings_balance_to_zero() {
        savings.deposit(100.0);
        savings.withdraw(100.0);
        assertEquals(0.0, savings.getBalance());
    }

    @Test
    public void savings_deposit_above_limit_is_rejected() {
        savings.deposit(3000.0);

        assertEquals(0.0, savings.getBalance());
    }

    @Test
    public void savings_withdraw_above_limit_is_rejected() {
        savings.deposit(2000.0);

        savings.withdraw(1500.0);

        assertEquals(2000.0, savings.getBalance());
    }

    @Test
    public void deposit_exact_limit_is_allowed() {
        savings.deposit(2500.0);
        assertEquals(2500.0, savings.getBalance());
    }

    @Test
    public void deposit_above_limit_is_rejected() {
        savings.deposit(2501.0);
        assertEquals(0.0, savings.getBalance());
    }

    @Test
    public void withdraw_exact_limit_is_allowed() {
        savings.deposit(2000.0);
        savings.withdraw(1000.0);
        assertEquals(1000.0, savings.getBalance());
    }

    @Test
    public void withdraw_above_limit_is_rejected() {
        savings.deposit(2000.0);
        savings.withdraw(1001.0);
        assertEquals(2000.0, savings.getBalance());
    }

    @Test
    public void deposit_one_dollar_updates_balance() {
        savings.deposit(1.0);
        assertEquals(1.0, savings.getBalance());
    }

    @Test
    public void withdraw_one_dollar_updates_balance() {
        savings.deposit(10.0);
        savings.withdraw(1.0);
        assertEquals(9.0, savings.getBalance());
    }

    @Test
    public void savings_balance_exactly_100_applies_apr_not_fee() {
        Savings savings = new Savings(12345678, 1.2);

        savings.deposit(100.0);
        savings.applyMonthlyApr();

        assertEquals(100.10, savings.getBalance());
    }

    @Test
    public void savings_balance_below_100_applies_fee_then_apr() {
        Savings savings = new Savings(12345678, 1.2);

        savings.deposit(50);
        savings.applyMonthlyApr();

        assertEquals(25.02, savings.getBalance());
    }
}