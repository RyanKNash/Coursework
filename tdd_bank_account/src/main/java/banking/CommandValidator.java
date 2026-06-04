package banking;

import java.util.HashMap;
import java.util.Map;

public class CommandValidator {

    private final Map<String, CommandRule> rules;

    public CommandValidator(Bank bank) {
        rules = new HashMap<>();
        rules.put("create", new CreateCommandValidator(bank));
        rules.put("deposit", new DepositCommandValidator(bank));
        rules.put("transfer", new TransferCommandValidator(bank));
        rules.put("pass", new PassCommandValidator());
    }

    public boolean validate(String command) {
        boolean valid = command != null;
        String normalizedCommand = "";

        if (valid) {
            normalizedCommand = command.trim();
            valid = !normalizedCommand.isEmpty() && !normalizedCommand.contains("  ");
        }

        if (valid) {
            String[] tokens = normalizedCommand.split("\\s+");
            String action = tokens[0].toLowerCase();
            CommandRule rule = rules.get(action);
            valid = rule != null && rule.validate(tokens);
        }

        return valid;
    }
}
