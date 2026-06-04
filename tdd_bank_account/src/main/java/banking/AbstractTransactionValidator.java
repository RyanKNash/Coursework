package banking;

public abstract class AbstractTransactionValidator implements CommandRule {
    protected static final int ACCOUNT_ID_LENGTH = 8;
    protected final Bank bank;

    protected AbstractTransactionValidator(Bank bank) {
        this.bank = bank;
    }

    protected boolean hasCorrectTokenCount(String[] tokens, int expectedCount) {
        return tokens.length == expectedCount;
    }

    protected boolean hasValidAccountIdFormat(String token) {
        return token.length() == ACCOUNT_ID_LENGTH;
    }

    protected boolean amountIsParsable(String amountToken) {
        return isDouble(amountToken);
    }

    protected boolean amountIsValid(String amountToken) {
        return Double.parseDouble(amountToken) > 0;
    }

    protected boolean isInteger(String value) {
        try {
            Integer.parseInt(value);
            return true;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    protected boolean isDouble(String value) {
        try {
            Double.parseDouble(value);
            return true;
        } catch (NumberFormatException e) {
            return false;
        }
    }
}
