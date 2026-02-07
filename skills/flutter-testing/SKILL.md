---
name: "Flutter Testing Strategies"
description: "Implement comprehensive testing strategies for Flutter apps including Unit, Widget, and Integration tests to ensure high quality."
---

# Flutter Testing Strategies

## Purpose
Ensure Flutter application reliability and quality through a robust testing pyramid. Validate logic, UI behavior, and end-to-end flows automatedly.

## When to Use
- Starting a new feature to ensure requirements are met (TDD).
- Refactoring legacy code to prevent regressions.
- Validating bug fixes.
- Setting up CI/CD pipelines.
- Ensuring UI components render and behave correctly across devices.

## Inputs You Need from Me
- Code or feature to be tested.
- Business rules and acceptance criteria.
- Current test coverage and setup.
- Dependencies that need mocking (API, DB, Device).

## Step-by-Step Process
1. **Define Test Scope**: Logic (Unit), Component (Widget), or Flow (Integration).
2. **Setup Environment**: Configure mockito, mocktail, or integration_test.
3. **Write Unit Tests**: Test models, repositories, and BLoCs/Notifiers in isolation.
4. **Write Widget Tests**: Verify UI rendering, user interactions (taps, text entry), and visual outputs.
5. **Write Integration Tests**: Simulate complete user journeys on emulators/devices.
6. **Mock Dependencies**: Replace network/database calls with mocks/fakes.
7. **Run & Debug**: Execute tests, refine assertions, and fix identified bugs.
8. **Check Coverage**: Analyze coverage reports to identify missing scenarios.

## Deliverables
- **Test Plan**: Strategy for what to test and how.
- **Test Code**: Files implementing unit, widget, and integration tests.
- **Mock Objects**: Mocks/Fakes for external dependencies.
- **Coverage Report**: verification of code paths tested.

## Quality Checklist
- [ ] Testing pyramid is respected (more unit, fewer integration).
- [ ] Tests are deterministic (no relying on network/randomness).
- [ ] Mocks are used appropriately to isolate the unit under test.
- [ ] Widget tests verify accessibility and responsiveness.
- [ ] Changes to logic/UI break corresponding tests (tests are valid).
- [ ] Tests run efficiently in CI.

## Pitfalls
- **Brittle Tests**: Tests that break with minor internal code changes (testing implementation vs behavior).
- **Slow Tests**: Over-reliance on integration tests for logic verification.
- **Flaky Tests**: Tests that pass/fail randomly due to timing/race conditions.
- **Ignoring Golden Tests**: Missing visual regression checks.
- **Not Mocking**: Making real network calls during tests.

## Example Prompts
1. `@flutter-testing Write unit tests for this UserValidator class covering valid and invalid emails.`
2. `@flutter-testing Create a widget test to verify that a loading spinner appears while data is fetching.`
3. `@flutter-testing I need an integration test for the full login flow.`
4. `@flutter-testing How do I mock a Dio client using mockito for my repository tests?`
5. `@flutter-testing Explain how to set up Golden tests to prevent visual regressions in my UI library.`
