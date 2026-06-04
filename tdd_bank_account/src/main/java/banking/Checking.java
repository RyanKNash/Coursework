package banking;

public class Checking extends Account {
    private static final double MAX_DEPOSIT_AMOUNT = 1000.0;
    private static final double MAX_WITHDRAW_AMOUNT = 400.0;

    public Checking(int accountNumber, double apr) {
        super(accountNumber, apr, 0.0);
    }

    @Override
    public void deposit(double amount) {
        if (amount > MAX_DEPOSIT_AMOUNT) {
            return;
        }

        super.deposit(amount);
    }

    @Override
    public void withdraw(double amount) {
        if (amount > MAX_WITHDRAW_AMOUNT) {
            return;
        }

        super.withdraw(amount);
    }
}
