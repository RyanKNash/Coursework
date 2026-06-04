package banking;

public class CreateCommandValidator implements CommandRule {
    private static final int CHECKING_OR_SAVINGS_TOKEN_COUNT = 4;
    private static final int CD_TOKEN_COUNT = 5;
    private static final int ACCOUNT_ID_LENGTH = 8;
    private static final double MIN_APR = 0.0;
    private static final double MAX_APR = 10.0;
    private static final double MIN_CD_INITIAL_BALANCE = 1000.0;
    private static final double MAX_CD_INITIAL_BALANCE = 10000.0;
    private static final String CREATE_COMMAND = "create";
    private static final String CHECKING_ACCOUNT = "checking";
    private static final String SAVINGS_ACCOUNT = "savings";
    private static final String CD_ACCOUNT = "cd";
    private final Bank bank;

    public CreateCommandValidator(Bank bank) {
        this.bank = bank;
    }

    @Override
    public boolean validate(String[] tokens) {
        if (!hasMinimumTokenCount(tokens) || !hasValidVerb(tokens)) {
            return false;
        }

        String accountType = getNormalizedAccountType(tokens);
        return hasValidAccountType(accountType)
                && hasValidTokenCount(tokens, accountType)
                && hasValidIdFormat(tokens)
                && idIsUnique(tokens)
                && hasValidApr(tokens)
                && cdHasValidInitialAmount(tokens, accountType);
    }

    private boolean hasMinimumTokenCount(String[] tokens) {
        return tokens.length >= CHECKING_OR_SAVINGS_TOKEN_COUNT;
    }

    private boolean hasValidVerb(String[] tokens) {
        return CREATE_COMMAND.equals(tokens[0].toLowerCase());
    }

    private boolean hasValidAccountType(String accountType) {
        return CHECKING_ACCOUNT.equals(accountType)
                || SAVINGS_ACCOUNT.equals(accountType)
                || CD_ACCOUNT.equals(accountType);
    }

    private boolean hasValidTokenCount(String[] tokens, String accountType) {
        if (CD_ACCOUNT.equals(accountType)) {
            return tokens.length == CD_TOKEN_COUNT;
        }
        return tokens.length == CHECKING_OR_SAVINGS_TOKEN_COUNT;
    }

    private boolean hasValidIdFormat(String[] tokens) {
        return tokens[2].length() == ACCOUNT_ID_LENGTH && isInteger(tokens[2]);
    }

    private boolean idIsUnique(String[] tokens) {
        return !bank.accountExists(Integer.parseInt(tokens[2]));
    }

    private boolean hasValidApr(String[] tokens) {
        if (!isDouble(tokens[3])) {
            return false;
        }

        double apr = Double.parseDouble(tokens[3]);
        return apr >= MIN_APR && apr <= MAX_APR;
    }

    private boolean cdHasValidInitialAmount(String[] tokens, String accountType) {
        if (!CD_ACCOUNT.equals(accountType)) {
            return true;
        }

        if (!isDouble(tokens[4])) {
            return false;
        }

        double initialBalance = Double.parseDouble(tokens[4]);
        return initialBalance >= MIN_CD_INITIAL_BALANCE && initialBalance <= MAX_CD_INITIAL_BALANCE;
    }

    private String getNormalizedAccountType(String[] tokens) {
        String typeToken = tokens[1];
        int lastDot = typeToken.lastIndexOf('.');
        if (lastDot != -1) {
            typeToken = typeToken.substring(lastDot + 1);
        }
        return typeToken.toLowerCase();
    }

    private boolean isInteger(String s) {
        try {
            Integer.parseInt(s);
            return true;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    private boolean isDouble(String s) {
        try {
            Double.parseDouble(s);
            return true;
        } catch (NumberFormatException e) {
            return false;
        }
    }
}
