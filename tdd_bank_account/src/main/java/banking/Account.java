package banking;

public abstract class Account {
    protected final int accountNumber;
    protected double balance;
    protected final double apr;

    protected Account(int accountNumber, double apr, double initialBalance) {
        this.accountNumber = accountNumber;
        this.apr = apr;
        this.balance = initialBalance;
    }

    public int getAccountNumber() {
        return accountNumber;
    }

    public double getBalance() {
        return balance;
    }

    public double getApr() {
        return apr;
    }

    public void deposit(double amount) {
        balance += amount;
    }

    public void withdraw(double amount) {
        if (amount >= balance) {
            balance = 0.0;
        } else {
            balance -= amount;
        }
    }

    public void applyMonthlyApr() {
        balance += balance * (apr / 100.0 / 12.0);
    }
}
