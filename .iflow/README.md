# iFlow TDD Configuration

This directory contains the Test-Driven Development (TDD) configuration for the Tutly project.

## Overview

The TDD setup ensures that:
1. Every code change must have corresponding tests
2. All tests must pass before committing
3. Tests are automatically validated before each commit

## Directory Structure

```
.iflow/
├── config.json              # iFlow configuration
├── scripts/
│   ├── validate-tests.ps1   # Validates tests exist and pass
│   └── create-test-template.ps1  # Creates test file templates
└── README.md                # This file
```

## Configuration Files

### `.iflow/config.json`
Main configuration file that defines:
- TDD settings (enabled, enforcement rules)
- Test directories and patterns
- Git hooks configuration
- Validation scripts

### `.iflowignore`
Files and patterns excluded from TDD validation:
- Generated files (*.g.dart, *.freezed.dart, etc.)
- Build artifacts (build/, .dart_tool/)
- Platform-specific files (android/, ios/, etc.)
- Configuration files

## Git Hooks

### Pre-commit Hook
Located at `.git/hooks/pre-commit.ps1`

Automatically runs before each commit to:
1. Check that all modified Dart files have corresponding tests
2. Run all Flutter tests
3. Block commit if tests are missing or failing

**To bypass (not recommended):**
```bash
git commit --no-verify
```

## Available Scripts

### Validate Tests
```powershell
powershell -ExecutionPolicy Bypass -File .iflow/scripts/validate-tests.ps1
```

Validates that:
- All modified lib files have corresponding tests
- All tests pass

### Create Test Template
```powershell
powershell -ExecutionPolicy Bypass -File .iflow/scripts/create-test-template.ps1 -SourceFile "lib/your_file.dart"
```

Creates a test file template based on the source file structure.

## Test Directory Structure

```
test/
├── unit/           # Unit tests for business logic
├── widget/         # Widget tests for UI components
└── integration/    # Integration tests for complete flows
```

## Workflow

1. **Before Writing Code:**
   - Create a test file for the feature you want to implement
   - Write failing tests that describe the expected behavior

2. **Write Code:**
   - Implement the minimum code to make tests pass
   - Run tests frequently

3. **Before Committing:**
   - Ensure all tests pass
   - Pre-commit hook will automatically validate

4. **Commit:**
   - If tests pass, commit succeeds
   - If tests fail or are missing, commit is blocked

## Lint Rules

Additional lint rules in `analysis_options.yaml`:
- `prefer_single_quotes` - Use single quotes for strings
- `avoid_print` - Avoid print statements
- `prefer_const_constructors` - Use const constructors
- `unawaited_futures` - Avoid unawaited futures

## Testing Commands

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget/my_widget_test.dart

# Run tests with coverage
flutter test --coverage

# Run only widget tests
flutter test test/widget/

# Run only unit tests
flutter test test/unit/
```

## Troubleshooting

### Pre-commit hook not running
Ensure Git hooks are enabled:
```bash
git config core.hooksPath .git/hooks
```

### Test validation fails
1. Check if test file exists in the correct location
2. Ensure test file follows naming convention: `*_test.dart`
3. Run tests manually to see detailed error messages

### Generated files causing issues
Files matching patterns in `.iflowignore` are automatically excluded.

## Configuration

To modify TDD behavior, edit `.iflow/config.json`:

```json
{
  "tdd": {
    "enabled": true,
    "enforceOnCommit": true,
    "requireTestsForNewCode": true,
    "failOnMissingTests": true,
    "failOnTestFailure": true
  }
}
```

## Best Practices

1. **Write tests first** - Follow TDD: Red, Green, Refactor
2. **Test one thing** - Each test should verify a single behavior
3. **Use descriptive names** - Test names should describe what they test
4. **Keep tests fast** - Unit tests should run quickly
5. **Test edge cases** - Don't forget error conditions and edge cases

## Support

For issues or questions about the TDD setup, check:
- Flutter testing documentation: https://docs.flutter.dev/testing
- iFlow CLI documentation: https://iflow.dev/docs