package banking;

public class DepositCommandValidator extends AbstractTransactionValidator {
    private static final int DEPOSIT_TOKEN_COUNT = 3;
    private static final double CHECKING_DEPOSIT_LIMIT = 1000.0;
    private static final double SAVINGS_DEPOSIT_LIMIT = 2500.0;

    public DepositCommandValidator(Bank bank) {
        super(bank);
    }

    @Override
    public boolean validate(String[] tokens) {
        return hasCorrectTokenCount(tokens, DEPOSIT_TOKEN_COUNT)
                && hasNumericAccountId(tokens)
                && hasValidAccountIdFormat(tokens[1])
                && amountIsParsable(tokens[2])
                && amountIsValid(tokens[2])
                && accountAcceptsDeposit(tokens)
                && amountWithinDepositLimit(tokens);
    }

    private boolean hasNumericAccountId(String[] tokens) {
        return isInteger(tokens[1]);
    }

    private boolean accountAcceptsDeposit(String[] tokens) {
        Account account = getAccount(tokens);
        return !(account instanceof CD);
    }

    private boolean amountWithinDepositLimit(String[] tokens) {
        Account account = getAccount(tokens);
        double amount = getAmount(tokens);

        if (account instanceof Checking) {
            return amount <= CHECKING_DEPOSIT_LIMIT;
        }

        if (account instanceof Savings) {
            return amount <= SAVINGS_DEPOSIT_LIMIT;
        }

        return true;
    }

    private Account getAccount(String[] tokens) {
        return bank.getAccount(Integer.parseInt(tokens[1]));
    }

    private double getAmount(String[] tokens) {
        return Double.parseDouble(tokens[2]);
    }
}
