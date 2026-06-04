package banking;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;

public class AccountTest {

    @Test
    public void withdrawing_exact_infinite_balance_sets_balance_to_zero() {
        Account account = new Account(12345678, 1.0, Double.POSITIVE_INFINITY) {
        };

        account.withdraw(Double.POSITIVE_INFINITY);

        assertFalse(Double.isNaN(account.getBalance()));
        assertEquals(0.0, account.getBalance());
    }
}
