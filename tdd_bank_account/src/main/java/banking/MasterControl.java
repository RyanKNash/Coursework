package banking;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

public class MasterControl {
    private static class ProcessedCommand {
        private final String command;
        private final String result;
        private final boolean valid;

        private ProcessedCommand(String command, String result, boolean valid) {
            this.command = command;
            this.result = result;
            this.valid = valid;
        }
    }

    private final CommandValidator validator;
    private final CommandProcessor processor;
    private final CommandStorage storage;
    private final Bank bank;

    public MasterControl(CommandValidator validator, CommandProcessor processor, CommandStorage storage) {
        this.validator = validator;
        this.processor = processor;
        this.storage = storage;
        this.bank = processor.getBank();
    }

    public List<String> start(List<String> input) {
        List<ProcessedCommand> processedCommands = new ArrayList<>();
        List<String> transactionalOutput = new ArrayList<>();
        List<String> invalidCommands = new ArrayList<>();
        boolean passCommandProcessed = handleCommands(input, processedCommands, transactionalOutput, invalidCommands);
        if (passCommandProcessed) {
            return buildPassOutput(processedCommands);
        }

        if (transactionalOutput.isEmpty()) {
            appendAccountSummaries(transactionalOutput);
        }

        appendInvalidCommands(transactionalOutput, invalidCommands);
        return transactionalOutput;
    }

    private List<String> buildPassOutput(List<ProcessedCommand> processedCommands) {
        List<String> output = new ArrayList<>();
        List<String> invalidCommands = new ArrayList<>();

        for (ProcessedCommand processedCommand : processedCommands) {
            if (!processedCommand.valid) {
                invalidCommands.add(normalizeCommand(processedCommand.command));
                continue;
            }

            appendPassCommandOutput(output, processedCommand);
        }

        appendInvalidCommands(output, invalidCommands);
        return output;
    }

    private boolean handleCommands(
            List<String> input,
            List<ProcessedCommand> processedCommands,
            List<String> transactionalOutput,
            List<String> invalidCommands
    ) {
        boolean passCommandProcessed = false;

        for (String command : input) {
            passCommandProcessed = isPassCommand(command) || passCommandProcessed;

            if (validator.validate(command)) {
                processValidCommand(command, processedCommands, transactionalOutput);
            } else {
                addInvalidCommand(command, processedCommands, invalidCommands);
            }
        }

        return passCommandProcessed;
    }

    private boolean processValidCommand(
            String command,
            List<ProcessedCommand> processedCommands,
            List<String> transactionalOutput
    ) {
        String result = processor.process(command);
        processedCommands.add(new ProcessedCommand(command, result, true));
        if (result != null) {
            transactionalOutput.add(result);
        }
        return isPassCommand(command);
    }

    private void addInvalidCommand(
            String command,
            List<ProcessedCommand> processedCommands,
            List<String> invalidCommands
    ) {
        storage.addInvalidCommand(command);
        processedCommands.add(new ProcessedCommand(command, null, false));
        invalidCommands.add(command);
    }

    private void appendPassCommandOutput(List<String> output, ProcessedCommand processedCommand) {
        String[] tokens = tokenize(processedCommand.command);
        String verb = tokens[0].toLowerCase(Locale.US);

        if ("create".equals(verb)) {
            appendCreatedAccountSummary(output, tokens);
            return;
        }

        if ("deposit".equals(verb)) {
            appendDepositOutput(output, processedCommand, tokens);
            return;
        }

        if ("transfer".equals(verb)) {
            appendTransferOutput(output, processedCommand, tokens);
        }
    }

    private void appendCreatedAccountSummary(List<String> output, String[] tokens) {
        Account account = bank.getAccount(Integer.parseInt(tokens[2]));
        if (account != null && shouldOutputSummary(account)) {
            output.add(formatAccountSummary(account));
        }
    }

    private void appendDepositOutput(List<String> output, ProcessedCommand processedCommand, String[] tokens) {
        Account account = bank.getAccount(Integer.parseInt(tokens[1]));
        if (account != null && shouldOutputSummary(account)) {
            output.add(processedCommand.result);
        }
    }

    private void appendTransferOutput(List<String> output, ProcessedCommand processedCommand, String[] tokens) {
        Account fromAccount = bank.getAccount(Integer.parseInt(tokens[1]));
        Account toAccount = bank.getAccount(Integer.parseInt(tokens[2]));
        boolean includeTransfer = (fromAccount != null && shouldOutputSummary(fromAccount))
                || (toAccount != null && shouldOutputSummary(toAccount));
        if (includeTransfer) {
            output.add(processedCommand.result);
        }
    }

    private void appendAccountSummaries(List<String> output) {
        for (Account account : bank.getAccounts()) {
            if (shouldOutputSummary(account)) {
                output.add(formatAccountSummary(account));
            }
        }
    }

    private void appendInvalidCommands(List<String> output, List<String> invalidCommands) {
        output.addAll(invalidCommands);
    }

    private boolean isPassCommand(String command) {
        if (command == null) {
            return false;
        }
        return tokenize(command)[0].equalsIgnoreCase("pass");
    }

    private String[] tokenize(String command) {
        return command.trim().split("\\s+");
    }

    private boolean shouldOutputSummary(Account account) {
        return !(account instanceof Checking && account.getBalance() == 0.0);
    }

    private String normalizeCommand(String command) {
        return command.trim().replaceAll("\\s+", " ");
    }

    private String formatAccountSummary(Account account) {
        String className = account.getClass().getSimpleName().toLowerCase(Locale.US);
        String accountType = className.substring(0, 1).toUpperCase(Locale.US) + className.substring(1);
        return String.format(
                Locale.US,
                "%s %d %.2f %.2f",
                accountType,
                account.getAccountNumber(),
                account.getBalance(),
                account.getApr()
        );
    }
}
