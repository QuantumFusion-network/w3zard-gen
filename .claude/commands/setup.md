# Setup Command - Generate dApp Features

Read and execute the instructions in SETUP_PROMPT.md to generate your dApp features.

## Pre-Generation Validation

Before starting code generation, run validation checks:

1. **Validate configuration file exists:**
   ```
   bash .claude/scripts/validate-wizard-config.sh
   ```

2. **Validate WebSocket connection:**
   ```
   bash .claude/scripts/validate-wss-connection.sh wss://test.qfnetwork.xyz
   ```

3. **Validate PAPI setup:**
   ```
   bash .claude/scripts/validate-papi-setup.sh
   ```

If any pre-generation validation fails, STOP and report the error to the user.

## Execute Setup Prompt

If all validations pass, read and execute SETUP_PROMPT.md:
- The prompt will specify which skill(s) to invoke
- Follow the instructions exactly as written
- Skills will generate code following CLAUDE.md conventions

## Post-Generation Validation

After code generation completes:

1. **Required: TypeScript validation**
   ```
   bash .claude/scripts/validate-typescript.sh
   ```

2. **Optional: Additional validation (only if issues found)**
   ```
   bash .claude/scripts/validate-lint.sh
   bash .claude/scripts/validate-build.sh
   ```

If validation fails, report errors and suggest fixes.

## Success Reporting

When setup completes successfully:

1. Report file counts (X new files, Y modified)
2. Confirm validation passed
3. Provide next steps:
   ```bash
   pnpm dev
   ```

## Error Handling

If errors occur:
- Pre-generation: Report validation failure with remediation steps
- Code generation: Report skill error with details
- Post-generation: Show errors and offer to fix

Follow ALL conventions in CLAUDE.md strictly.
