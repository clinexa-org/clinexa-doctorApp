---
name: "Design Patterns for Flutter"
description: "Apply common design patterns (Factory, Strategy, Adapter, Repository, State, Observer) in Flutter/Dart apps following clean architecture principles."
---

# Design Patterns for Flutter

## Purpose
Guide the selection and implementation of proven design patterns in Flutter applications. Helps structure code for maintainability, testability, and scalability without overengineering.

## When to Use
- Designing a new feature that requires flexible, extensible code.
- Refactoring existing code to reduce coupling or improve testability.
- Choosing between multiple ways to structure a component.
- Implementing clean architecture layers (data, domain, presentation).

## Inputs You Need from Me
- Feature or module being designed.
- Current architecture (if any).
- Complexity level (simple, medium, complex).
- Specific pain points or goals (testability, extensibility, etc.).
- State management approach in use (BLoC, Riverpod, Provider, etc.).

## Step-by-Step Process
1. **Analyze the problem**: Identify what varies, what changes frequently, and what should remain stable.
2. **Select candidate patterns**: Match the problem to 1-3 patterns that address it.
3. **Evaluate trade-offs**: Consider complexity, team familiarity, and integration with existing code.
4. **Define contracts**: Create abstract classes or interfaces for the pattern.
5. **Implement skeleton**: Write minimal code to demonstrate the pattern structure.
6. **Integrate with architecture**: Place the pattern in the correct layer (data, domain, or presentation).
7. **Add tests**: Write unit tests for the pattern's behavior.
8. **Document decision**: Record why this pattern was chosen (ADR-style).

## Deliverables
- **Pattern selection rationale**: A brief explanation of why the chosen pattern fits.
- **File/folder plan**: Where each class/file goes in the project structure.
- **Minimal code skeleton**: Abstract classes, interfaces, and one concrete implementation.
- **Test example**: At least one unit test demonstrating the pattern.

## Quality Checklist
- [ ] Pattern solves a real problem, not added for its own sake.
- [ ] Code is simpler or equally simple compared to alternatives.
- [ ] Pattern is placed in the correct architectural layer.
- [ ] Interfaces are minimal and focused.
- [ ] Unit tests cover the pattern's core behavior.
- [ ] Team can understand and extend the pattern.

## Pitfalls
- **Overengineering**: Adding patterns for problems that don't exist yet.
- **Wrong layer**: Putting domain logic in presentation or vice versa.
- **Leaky abstractions**: Exposing implementation details through interfaces.
- **Pattern worship**: Forcing a pattern when a simple function would suffice.
- **Untested patterns**: Assuming the pattern works without verification.

## Example Prompts
1. `@design-patterns I need to fetch data from multiple sources (API, cache, local DB) for a Product. Help me implement a Repository pattern with clear fallbacks.`
2. `@design-patterns My app has 5 different payment methods. Which pattern should I use to add new methods without modifying existing code?`
3. `@design-patterns I have a complex form with validation rules that change based on user type. Recommend a pattern to manage this.`
4. `@design-patterns Help me refactor this 500-line widget by extracting reusable patterns.`
5. `@design-patterns Show me how to implement the Observer pattern for a notification system in Flutter using streams.`
