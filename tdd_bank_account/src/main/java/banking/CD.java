package banking;

public class CD extends Account {
    private int monthsPassed = 0;

    protected CD(int accountNumber, double apr, double initialBalance) {
        super(accountNumber, apr, initialBalance);
    }

    @Override
    public void deposit(double amount) {
    }

    @Override
    public void withdraw(double amount) {
        if (monthsPassed < 12) {
            return;
        }

        if (amount >= balance) {
            balance = 0.0;
        }
    }

    public void passTime(int months) {
        monthsPassed += months;
    }
}
