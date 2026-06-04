# TDD Bank Account

Java banking command processor developed with a test-driven workflow. The project models multiple account types, validates text commands, processes deposits/transfers/time passage, and reports final account state.

## What It Does

- Supports `Checking`, `Savings`, and `CD` accounts.
- Creates accounts with account numbers and APR values.
- Processes deposits and transfers.
- Applies monthly APR behavior through `pass` commands.
- Validates command syntax and banking rules before processing.
- Preserves invalid commands for final output.
- Uses a `MasterControl` coordinator to connect validation, processing, storage, and reporting.

## Key Files

| Path | Purpose |
| --- | --- |
| `src/main/java/banking/` | Main banking domain and command-processing classes. |
| `src/test/java/banking/` | JUnit test suite. |
| `build.gradle` | Gradle build, test, JaCoCo, and PIT configuration. |
| `.gitlab-ci.yml` | CI configuration artifact. |

## Build And Test

Use the Gradle wrapper from this folder:

```bash
./gradlew test
```

Generate coverage:

```bash
./gradlew test jacocoTestReport
```

Run mutation testing:

```bash
./gradlew pitest
```

On Windows PowerShell, use an installed Gradle if `gradlew.bat` is not present:

```powershell
gradle test
gradle test jacocoTestReport
gradle pitest
```

## Concepts Demonstrated

- Test-driven development
- JUnit 5 testing
- Gradle project structure
- Command validation and command processing
- Domain modeling with inheritance
- Account state management
- CI and coverage tooling
- Mutation testing with PIT

## Design Notes

The implementation separates validation from command execution. `CommandValidator` and its specialized validators decide whether a command is valid, while `CommandProcessor` mutates bank state. `MasterControl` coordinates the full command stream and assembles user-facing output.
