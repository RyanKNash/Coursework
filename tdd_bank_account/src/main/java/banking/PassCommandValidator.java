package banking;

public class PassCommandValidator implements CommandRule {

    @Override
    public boolean validate(String[] tokens) {
        if (tokens.length != 2) return false;
        if (!isInteger(tokens[1])) return false;

        int months = Integer.parseInt(tokens[1]);
        return months > 0 && months <= 60;
    }

    private boolean isInteger(String s) {
        try {
            Integer.parseInt(s);
            return true;
        } catch (NumberFormatException e) {
            return false;
        }
    }
}
