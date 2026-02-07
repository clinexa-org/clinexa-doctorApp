---
name: "Flutter State Management"
description: "Master Riverpod, Provider, and other state management solutions for Flutter apps, choosing the right tool for the job."
---

# Flutter State Management

## Purpose
Guide the selection and implementation of state management solutions in Flutter beyond BLoC. Focuses on Riverpod, Provider, and understanding when to use each for efficient, maintainable apps.

## When to Use
- Determining the best state management approach for a new project or feature.
- implementing global vs ephemeral state.
- Migrating from one state management solution to another (e.g., Provider to Riverpod).
- Optimizing rebuilds and performance related to state changes.
- Handling dependency injection and asynchronous state.

## Inputs You Need from Me
- Project scale and complexity.
- Team familiarity with specific libraries.
- Specific use case (e.g., auth state, shopping cart, theme switching).
- Requirement for dependency injection.

## Step-by-Step Process
1. **Analyze State Scope**: Is it global (user session) or local (widget specific)?
2. **Select Library**: Choose Riverpod (modern, compile-safe), Provider (simple, legacy), or GetX (if preferred).
3. **Setup Logic**: Define Notifiers, Providers, or Controllers.
4. **Define State Model**: Create immutable state classes (recommended).
5. **Inject/Access State**: Use `Consumer`, `Provider.of`, or hooks to access state in UI.
6. **Handle Async**: Implement loading/error/data states for async operations (e.g., `AsyncValue` in Riverpod).
7. **Optimize Rebuilds**: Use `select`, `watch`, or distinct checks to minimize Widget rebuilds.
8. **Test**: Write unit tests for state logic independent of UI.

## Deliverables
- **State Architecture**: Diagram or description of where state lives.
- **Implementation Code**: Providers/Notifiers and consuming Widgets.
- **Optimized UI**: Strategies to prevent unnecessary rebuilds.
- **Test Suite**: Unit tests for state logic.

## Quality Checklist
- [ ] State is immutable where possible.
- [ ] Business logic is separated from UI code.
- [ ] Rebuilds are optimized (only affected widgets rebuild).
- [ ] Dependency injection is handled cleanly.
- [ ] Async states (loading, error) are handled explicitly.
- [ ] Logic is testable without UI.

## Pitfalls
- **Global State Abuse**: Making everything global when it should be local.
- **Context Hell**: Difficulty accessing providers without proper context (Provider specific).
- **Mutable State Bugs**: Unexpected side effects from mutating state directly.
- **Over-Optimization**: Prematurely optimizing rebuilds adding complexity.
- **Library Lock-in**: Tightly coupling logic to a specific library's implementation details.

## Example Prompts
1. `@flutter-state-management Help me set up Riverpod 2.0 with code generation for a user profile feature.`
2. `@flutter-state-management Migrate this Provider-based counter app to use Riverpod.`
3. `@flutter-state-management What is the best way to handle global authentication state in Flutter?`
4. `@flutter-state-management Optimize this widget to only rebuild when the 'userName' field changes, not the whole user object.`
5. `@flutter-state-management Explain the difference between Riverpod's Provider, StateProvider, and StateNotifierProvider.`
