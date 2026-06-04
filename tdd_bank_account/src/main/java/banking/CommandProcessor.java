package banking;

public class CommandProcessor {
    private static final String CREATE_COMMAND = "create";
    private static final String DEPOSIT_COMMAND = "deposit";
    private static final String TRANSFER_COMMAND = "transfer";
    private static final String PASS_COMMAND = "pass";
    private static final String CHECKING_ACCOUNT = "checking";
    private static final String SAVINGS_ACCOUNT = "savings";
    private static final String CD_ACCOUNT = "cd";

    private final Bank bank;

    public CommandProcessor(Bank bank) {
        this.bank = bank;
    }

    public Bank getBank() {
        return bank;
    }

    public String process(String command) {
        String[] tokens = command.trim().split("\\s+");
        String verb = getNormalizedVerb(tokens);
        String result = null;

        if (CREATE_COMMAND.equals(verb)) {
            result = processCreate(tokens);
        } else if (DEPOSIT_COMMAND.equals(verb)) {
            result = processDeposit(tokens);
        } else if (TRANSFER_COMMAND.equals(verb)) {
            result = processTransfer(tokens);
        } else if (PASS_COMMAND.equals(verb)) {
            result = processPass(tokens);
        }

        return result;
    }

    private String processCreate(String[] tokens) {
        String accountType = getNormalizedAccountType(tokens[1]);
        int id = Integer.parseInt(tokens[2]);
        double apr = Double.parseDouble(tokens[3]);

        if (CHECKING_ACCOUNT.equals(accountType)) {
            bank.createChecking(id, apr);
        } else if (SAVINGS_ACCOUNT.equals(accountType)) {
            bank.createSavings(id, apr);
        } else if (CD_ACCOUNT.equals(accountType)) {
            double initialDeposit = Double.parseDouble(tokens[4]);
            bank.createCertificateOfDeposit(id, apr, initialDeposit);
        }

        return null;
    }

    private String processDeposit(String[] tokens) {
        int id = Integer.parseInt(tokens[1]);
        String result = null;

        if (bank.accountExists(id)) {
            double amount = Double.parseDouble(tokens[2]);
            bank.deposit(id, amount);
            result = "Deposit " + tokens[1] + " " + tokens[2];
        }

        return result;
    }

    private String processTransfer(String[] tokens) {
        int fromId = Integer.parseInt(tokens[1]);
        int toId = Integer.parseInt(tokens[2]);
        if (!bank.accountExists(fromId) || !bank.accountExists(toId)) {
            return null;
        }
        double amount = Double.parseDouble(tokens[3]);
        bank.transfer(fromId, toId, amount);
        return "Transfer " + tokens[1] + " " + tokens[2] + " " + tokens[3];
    }

    private String processPass(String[] tokens) {
        int months = Integer.parseInt(tokens[1]);
        bank.passTime(months);
        return null;
    }

    private String getNormalizedVerb(String[] tokens) {
        return tokens[0].toLowerCase();
    }

    private String getNormalizedAccountType(String typeToken) {
        int lastDot = typeToken.lastIndexOf('.');
        if (lastDot != -1) {
            typeToken = typeToken.substring(lastDot + 1);
        }
        return typeToken.toLowerCase();
    }
}
