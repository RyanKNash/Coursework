package banking;

public interface CommandRule {
    boolean validate(String[] tokens);
}