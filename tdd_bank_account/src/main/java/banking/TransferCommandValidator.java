package banking;

public class TransferCommandValidator extends AbstractTransactionValidator {
    private static final int TRANSFER_TOKEN_COUNT = 4;

    public TransferCommandValidator(Bank bank) {
        super(bank);
    }

    @Override
    public boolean validate(String[] tokens) {
        return hasCorrectTokenCount(tokens, TRANSFER_TOKEN_COUNT)
                && hasNumericIds(tokens)
                && hasValidIdFormat(tokens)
                && isInteger(tokens[3])
                && amountIsValid(tokens[3])
                && accountsAreDifferent(tokens)
                && accountsExist(tokens)
                && accountsAreNotCd(tokens);
    }

    private boolean hasNumericIds(String[] tokens) {
        return isInteger(tokens[1]) && isInteger(tokens[2]);
    }

    private boolean hasValidIdFormat(String[] tokens) {
        return hasValidAccountIdFormat(tokens[1]) && hasValidAccountIdFormat(tokens[2]);
    }

    private boolean accountsAreDifferent(String[] tokens) {
        return getFromId(tokens) != getToId(tokens);
    }

    private boolean accountsExist(String[] tokens) {
        return getFromAccount(tokens) != null && getToAccount(tokens) != null;
    }

    private boolean accountsAreNotCd(String[] tokens) {
        Account fromAccount = getFromAccount(tokens);
        Account toAccount = getToAccount(tokens);
        return !(fromAccount instanceof CD) && !(toAccount instanceof CD);
    }

    private int getFromId(String[] tokens) {
        return Integer.parseInt(tokens[1]);
    }

    private int getToId(String[] tokens) {
        return Integer.parseInt(tokens[2]);
    }

    private Account getFromAccount(String[] tokens) {
        return bank.getAccount(getFromId(tokens));
    }

    private Account getToAccount(String[] tokens) {
        return bank.getAccount(getToId(tokens));
    }
}
