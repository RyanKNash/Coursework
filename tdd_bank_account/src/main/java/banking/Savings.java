package banking;

public class Savings extends Account {
    private static final double LOW_BALANCE_THRESHOLD = 100.0;
    private static final double LOW_BALANCE_FEE = 25.0;
    private static final double MAX_DEPOSIT_AMOUNT = 2500.0;
    private static final double MAX_WITHDRAW_AMOUNT = 1000.0;

    public Savings(int accountNumber, double apr) {
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

    @Override
    public void applyMonthlyApr() {
        if (balance < LOW_BALANCE_THRESHOLD) {
            withdraw(LOW_BALANCE_FEE);
        }

        super.applyMonthlyApr();
        balance = Math.floor(balance * 100.0) / 100.0;
    }
}
