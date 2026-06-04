package banking;

import java.util.ArrayList;
import java.util.List;

public class Bank {
    private static final String ACCOUNT_DOES_NOT_EXIST_MESSAGE = "banking.Account does not exist: ";
    private static final String ACCOUNT_ALREADY_EXISTS_MESSAGE = "banking.Account already exists: ";
    private final List<Account> accounts = new ArrayList<>();

    public int getNumberOfAccounts() {
        return accounts.size();
    }

    public List<Account> getAccounts() {
        return new ArrayList<>(accounts);
    }

    public void addAccount(Account account) {
        accounts.add(account);
    }

    public Account getAccount(int id) {
        for (Account a : accounts) {
            if (a.getAccountNumber() == id) return a;
        }
        return null;
    }

    public void deposit(int id, double amount) {
        requireAccount(id).deposit(amount);
    }

    public void withdraw(int id, double amount) {
        requireAccount(id).withdraw(amount);
    }

    public boolean accountExists(int id) {
        return getAccount(id) != null;
    }

    public void createSavings(int accountNumber, double apr) {
        createAndStoreAccount(accountNumber, new Savings(accountNumber, apr));
    }

    public void createChecking(int accountNumber, double apr) {
        createAndStoreAccount(accountNumber, new Checking(accountNumber, apr));
    }

    public void transfer(int fromId, int toId, double amount) {
        Account fromAccount = requireAccount(fromId);
        Account toAccount = requireAccount(toId);

        double transferredAmount = Math.min(amount, fromAccount.getBalance());
        fromAccount.withdraw(transferredAmount);
        toAccount.deposit(transferredAmount);
    }

    public void passTime(int months) {
        for (int month = 0; month < months; month++) {
            for (Account account : accounts) {
                account.applyMonthlyApr();
            }
        }
    }

    public void createCertificateOfDeposit(int accountNumber, double apr, double initialDeposit) {
        createAndStoreAccount(accountNumber, new CD(accountNumber, apr, initialDeposit));
    }

    public void createCd(int accountNumber, double apr, double initialDeposit) {
        createCertificateOfDeposit(accountNumber, apr, initialDeposit);
    }

    private Account requireAccount(int id) {
        Account account = getAccount(id);
        if (account == null) {
            throw new IllegalArgumentException(ACCOUNT_DOES_NOT_EXIST_MESSAGE + id);
        }
        return account;
    }

    private void ensureAccountDoesNotExist(int id) {
        if (accountExists(id)) {
            throw new IllegalArgumentException(ACCOUNT_ALREADY_EXISTS_MESSAGE + id);
        }
    }

    private void createAndStoreAccount(int accountNumber, Account account) {
        ensureAccountDoesNotExist(accountNumber);
        accounts.add(account);
    }
}
