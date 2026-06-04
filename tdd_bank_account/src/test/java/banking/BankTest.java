package banking;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

public class BankTest {

    private Bank bank;

    @BeforeEach
    public void setUp() {
        bank = new Bank();
    }

    @Test
    public void when_a_bank_is_created_it_has_no_accounts() {
        assertEquals(0, bank.getNumberOfAccounts());
    }

    @Test
    public void when_an_account_is_added_to_the_bank_the_bank_has_1_account_in_it() {
        bank.addAccount(new Checking(12345678, 1.0));
        assertEquals(1, bank.getNumberOfAccounts());
    }

    @Test
    public void when_2_accounts_are_added_to_the_bank_the_bank_has_2_accounts_in_it() {
        bank.addAccount(new Checking(12345678, 1.0));
        bank.addAccount(new Savings(87654321, 2.0));
        assertEquals(2, bank.getNumberOfAccounts());
    }

    @Test
    public void when_retrieving_1_account_from_the_bank_the_correct_account_is_retrieved() {
        Account expected = new Checking(12345678, 1.0);
        bank.addAccount(expected);

        Account actual = bank.getAccount(12345678);

        assertEquals(12345678, actual.getAccountNumber());
        assertEquals(1.0, actual.getApr());
        assertEquals(0.0, actual.getBalance());
    }

    @Test
    public void when_depositing_money_by_id_through_the_bank_the_correct_account_gets_the_money() {
        bank.addAccount(new Checking(12345678, 1.0));
        bank.addAccount(new Savings(87654321, 2.0));

        bank.deposit(87654321, 50.0);

        assertEquals(0.0, bank.getAccount(12345678).getBalance());
        assertEquals(50.0, bank.getAccount(87654321).getBalance());
    }

    @Test
    public void when_withdrawing_money_by_id_through_the_bank_the_correct_account_loses_the_money() {
        bank.addAccount(new Checking(12345678, 1.0));
        bank.addAccount(new Savings(87654321, 2.0));

        bank.deposit(12345678, 100.0);
        bank.withdraw(12345678, 40.0);

        assertEquals(60.0, bank.getAccount(12345678).getBalance());
        assertEquals(0.0, bank.getAccount(87654321).getBalance());
    }

    @Test
    public void depositing_twice_through_the_bank_works_as_expected() {
        bank.addAccount(new Checking(12345678, 1.0));

        bank.deposit(12345678, 25.0);
        bank.deposit(12345678, 10.0);

        assertEquals(35.0, bank.getAccount(12345678).getBalance());
    }

    @Test
    public void withdrawing_twice_through_the_bank_works_as_expected() {
        bank.addAccount(new Checking(12345678, 1.0));

        bank.deposit(12345678, 100.0);
        bank.withdraw(12345678, 30.0);
        bank.withdraw(12345678, 20.0);

        assertEquals(50.0, bank.getAccount(12345678).getBalance());
    }

    @Test
    public void bank_can_store_and_retrieve_a_cd_account() {
        bank.addAccount(new CD(11112222, 3.5, 1000.0));

        assertEquals(1, bank.getNumberOfAccounts());
        assertEquals(1000.0, bank.getAccount(11112222).getBalance());
        assertEquals(3.5, bank.getAccount(11112222).getApr());
    }

    @Test
    public void transferring_money_removes_money_from_source_and_adds_to_destination() {
        bank.addAccount(new Checking(12345678, 1.0));
        bank.addAccount(new Savings(87654321, 2.0));

        bank.deposit(12345678, 100.0);
        bank.transfer(12345678, 87654321, 40.0);

        assertEquals(60.0, bank.getAccount(12345678).getBalance());
        assertEquals(40.0, bank.getAccount(87654321).getBalance());
    }

    @Test
    public void transferring_money_adds_money_to_the_destination_account() {
        bank.addAccount(new Checking(12345678, 1.0));
        bank.addAccount(new Savings(87654321, 2.0));

        bank.deposit(12345678, 100.0);
        bank.transfer(12345678, 87654321, 40.0);

        assertEquals(40.0, bank.getAccount(87654321).getBalance());
    }

    @Test
    public void transferring_money_updates_both_accounts_correctly() {
        bank.addAccount(new Checking(12345678, 1.0));
        bank.addAccount(new Savings(87654321, 2.0));

        bank.deposit(12345678, 100.0);
        bank.deposit(87654321, 10.0);

        bank.transfer(12345678, 87654321, 40.0);

        assertEquals(60.0, bank.getAccount(12345678).getBalance());
        assertEquals(50.0, bank.getAccount(87654321).getBalance());
    }

    @Test
    public void transferring_zero_dollars_does_not_change_either_account_balance() {
        bank.addAccount(new Checking(12345678, 1.0));
        bank.addAccount(new Savings(87654321, 2.0));

        bank.deposit(12345678, 100.0);
        bank.deposit(87654321, 50.0);

        bank.transfer(12345678, 87654321, 0.0);

        assertEquals(100.0, bank.getAccount(12345678).getBalance());
        assertEquals(50.0, bank.getAccount(87654321).getBalance());
    }

    @Test
    public void transferring_the_entire_balance_leaves_the_source_account_at_zero() {
        bank.addAccount(new Checking(12345678, 1.0));
        bank.addAccount(new Savings(87654321, 2.0));

        bank.deposit(12345678, 100.0);
        bank.transfer(12345678, 87654321, 100.0);

        assertEquals(0.0, bank.getAccount(12345678).getBalance());
        assertEquals(100.0, bank.getAccount(87654321).getBalance());
    }

    @Test
    public void transferring_from_empty_account_does_not_change_destination() {
        bank.addAccount(new Checking(12345678, 1.0));
        bank.addAccount(new Savings(87654321, 2.0));

        bank.transfer(12345678, 87654321, 100.0);

        assertEquals(0.0, bank.getAccount(12345678).getBalance());
        assertEquals(0.0, bank.getAccount(87654321).getBalance());
    }

    @Test
    public void transferring_more_than_balance_only_transfers_available_amount() {
        bank.addAccount(new Checking(1, 1.0));
        bank.addAccount(new Savings(2, 1.0));

        bank.deposit(1, 50.0);
        bank.transfer(1, 2, 100.0);

        assertEquals(0.0, bank.getAccount(1).getBalance());
        assertEquals(50.0, bank.getAccount(2).getBalance());
    }

    @Test
    public void transferring_to_self_does_not_change_balance() {
        bank.addAccount(new Checking(1, 1.0));

        bank.deposit(1, 100.0);
        bank.transfer(1, 1, 50.0);

        assertEquals(100.0, bank.getAccount(1).getBalance());
    }

    @Test
    public void depositing_zero_does_not_change_balance() {
        bank.addAccount(new Checking(1, 1.0));

        bank.deposit(1, 0.0);

        assertEquals(0.0, bank.getAccount(1).getBalance());
    }

    @Test
    public void withdrawing_zero_does_not_change_balance() {
        bank.addAccount(new Checking(1, 1.0));

        bank.deposit(1, 100.0);
        bank.withdraw(1, 0.0);

        assertEquals(100.0, bank.getAccount(1).getBalance());
    }

    @Test
    public void createCD_adds_a_cd_account_to_the_bank() {
        bank.createCd(12345678, 1.2, 2000.0);

        assertEquals(1, bank.getNumberOfAccounts());
        assertEquals(2000.0, bank.getAccount(12345678).getBalance());
        assertEquals(1.2, bank.getAccount(12345678).getApr());
    }

    @Test
    public void creating_account_with_existing_id_throws_exception() {
        Bank bank = new Bank();

        bank.createChecking(12345678, 1.0);

        assertThrows(IllegalArgumentException.class, () ->
                bank.createSavings(12345678, 1.0)
        );
    }

    @Test
    public void creating_cd_with_existing_id_throws_exception() {
        Bank bank = new Bank();

        bank.createChecking(12345678, 1.0);

        assertThrows(IllegalArgumentException.class, () ->
                bank.createCd(12345678, 1.0, 2000)
        );
    }

    @Test
    public void transferring_twice_updates_balances_correctly() {
        bank.addAccount(new Checking(1, 1.0));
        bank.addAccount(new Savings(2, 1.0));

        bank.deposit(1, 100.0);

        bank.transfer(1, 2, 30.0);
        bank.transfer(1, 2, 20.0);

        assertEquals(50.0, bank.getAccount(1).getBalance());
        assertEquals(50.0, bank.getAccount(2).getBalance());
    }
}
