---
name: "Flutter BLoC Patterns"
description: "Implement scalable state management using the BLoC (Business Logic Component) pattern in Flutter with clean architecture."
---

# Flutter BLoC Patterns

## Purpose
Structure Flutter applications using the BLoC pattern to separate business logic from presentation code. Ensure predictable state changes, testability, and scalability.

## When to Use
- Building complex applications with significant state management needs.
- Team is familiar with or wants to adopt the BLoC pattern.
- Requiring strict separation of concerns (UI vs Logic).
- Implementing features that need to be highly testable.
- Applications with event-driven data flows.

## Inputs You Need from Me
- Feature or screen being implemented.
- Events that trigger state changes (e.g., LoadData, UpdateProfile).
- States the UI needs to render (e.g., Loading, Loaded, Error).
- Dependencies (Repositories, Use Cases).
- Preferences for `flutter_bloc` package usage (e.g., HookWidget, BlocConsumer).

## Step-by-Step Process
1. **Identify Events**: List all user interactions and system events for the feature.
2. **Define States**: Determine all possible states the UI can be in.
3. **Create Event/State Classes**: Use `freezed` or `equatable` for value equality.
4. **Implement BLoC**: Write the BLoC class handling events and emitting states.
5. **Connect Repository**: Inject data sources/repositories into the BLoC.
6. **Build UI**: Use `BlocBuilder`, `BlocListener`, or `BlocConsumer` in widgets.
7. **Handle Errors**: Ensure error states allow for retry or user feedback.
8. **Write Tests**: Unit test the BLoC by asserting state emissions for given events.

## Deliverables
- **Event/State definitions**: Clear contracts for inputs and outputs.
- **BLoC implementation**: The core logic class.
- **UI Integration**: Widget code showing how to consume the BLoC.
- **Unit Tests**: comprehensive tests for logic coverage.

## Quality Checklist
- [ ] Events and States are immutable.
- [ ] BLoC does not depend on UI (BuildContext, Widgets).
- [ ] All possible states are handled in the UI.
- [ ] Logic relies on abstract repositories, not concrete implementations.
- [ ] Tests cover happy paths, error cases, and edge cases.

## Pitfalls
- **God BLoC**: Putting too much logic into a single BLoC.
- **Logic in UI**: Performing business logic inside widgets instead of dispatching events.
- **Mutable State**: Modifying state objects directly.
- **Ignoring Errors**: Not having a robust error state handling strategy.
- **Lack of Testing**: Skipping tests for complex BLoC logic.

## Example Prompts
1. `@flutter-bloc-patterns Help me design the BLoC for a Login screen with email/password validation and loading states.`
2. `@flutter-bloc-patterns I need to implement an infinite scroll list using BLoC. Define the events and states.`
3. `@flutter-bloc-patterns Refactor this StatefulWidget logic into a clean BLoC architecture.`
4. `@flutter-bloc-patterns Show me how to test a BLoC that depends on a repository throwing an exception.`
5. `@flutter-bloc-patterns How do I communicate between two BLoCs effectively?`
