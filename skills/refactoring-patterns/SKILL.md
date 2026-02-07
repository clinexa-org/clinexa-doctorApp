---
name: "Refactoring Patterns for Flutter"
description: "Safely refactor Flutter code with widget extraction, state hoisting, layer separation, and incremental improvement strategies."
---

# Refactoring Patterns for Flutter

## Purpose
Improve Flutter code quality incrementally without breaking functionality. Apply safe refactoring techniques with proper testing to reduce technical debt.

## When to Use
- Code has grown complex and hard to maintain.
- Widgets are too large (100+ lines).
- State management is tangled with UI.
- Adding features requires touching unrelated code.
- Preparing code for a major feature or migration.

## Inputs You Need from Me
- Code or module to refactor.
- Specific pain points (performance, readability, testability).
- Test coverage status.
- Time/scope constraints.
- Breaking change tolerance.

## Step-by-Step Process
1. **Analyze current state**: Identify code smells and problem areas.
2. **Define goals**: What should be better after refactoring?
3. **Ensure test coverage**: Add tests before refactoring if missing.
4. **Plan incremental changes**: Break refactor into small, testable steps.
5. **Extract widgets**: Pull out reusable or complex widget pieces.
6. **Hoist state**: Move state up or down to appropriate levels.
7. **Separate layers**: Extract business logic from UI.
8. **Rename for clarity**: Use meaningful names for classes, methods, variables.
9. **Commit incrementally**: One logical change per commit.
10. **Verify after each step**: Run tests and check functionality.

## Deliverables
- **Refactor plan**: Ordered list of refactoring steps.
- **Risk assessment**: What could break and how to mitigate.
- **Incremental commits checklist**: Each commit with description and verification.
- **Before/after structure**: Visual comparison of code organization.

## Quality Checklist
- [ ] All tests pass after each refactoring step.
- [ ] No new functionality added during refactor.
- [ ] Each commit is atomic and revertible.
- [ ] Code is more readable/maintainable than before.
- [ ] Performance is equal or better.
- [ ] Refactoring rationale is documented.

## Pitfalls
- **Big bang refactors**: Changing too much at once.
- **Refactoring without tests**: No safety net for regressions.
- **Mixing refactor with features**: Harder to debug issues.
- **Premature abstraction**: Creating abstractions before patterns emerge.
- **Losing context**: Commits that don't explain why changes were made.

## Example Prompts
1. `@refactoring-patterns This 400-line widget is hard to maintain. Help me extract smaller widgets while preserving state.`
2. `@refactoring-patterns I have business logic in my UI widgets. Help me refactor to a clean architecture structure.`
3. `@refactoring-patterns My app has performance issues from unnecessary rebuilds. Show me how to refactor for optimal rebuilds.`
4. `@refactoring-patterns Plan a safe refactor to migrate from Provider to Riverpod in my existing app.`
5. `@refactoring-patterns Help me create a refactoring checklist for renaming my core models and updating all references.`
