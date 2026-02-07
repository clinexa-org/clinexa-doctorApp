---
name: "Dart Language Patterns"
description: "Write idiomatic, effective Dart code using modern language features, effective dart guidelines, and clean code principles."
---

# Dart Language Patterns

## Purpose
Leverage the full power of the Dart language. Write concise, readable, and performant code by using modern features like patterns, records, sealed classes, and extensions.

## When to Use
- Writing or refactoring any Dart code.
- Adopting new Dart versions (e.g., Dart 3+).
- Modeling data structures/domain entities.
- simplifying functional logic.
- Enforcing strong typing and null safety best practices.

## Inputs You Need from Me
- Dart SDK version target (e.g., 3.0+).
- Code snippet or logic to implement/refactor.
- Domain model requirements.

## Step-by-Step Process
1. **Analyze Requirements**: What data/logic needs to be modeled?
2. **Choose Features**: Records for multi-return, Sealed classes for exhaustive switch, Extensions for utility.
3. **Apply Null Safety**: Design with non-nullable types by default, use `late` or `?` carefully.
4. **Functional Style**: Use collection operators (map, where, spread) over loops where readable.
5. **Pattern Matching**: Use Dart 3 patterns for destructuring and control flow.
6. **Linting**: Ensure code passes `flutter_lints` or `very_good_analysis`.
7. **Refactor**: Simplify verbose code into idiomatic expressions.

## Deliverables
- **Idiomatic Code**: Solutions using best practices.
- **Refactoring Suggestions**: Improving existing code.
- **Data Models**: Using Records, Enums, and Classes effectively.
- **Extension Methods**: Adding functionality cleanly.

## Quality Checklist
- [ ] Code is null-safe and robust.
- [ ] Modern features (Patterns, Records) are used where appropriate.
- [ ] Collection processing is concise and readable.
- [ ] Switch statements on enums/sealed classes are exhaustive.
- [ ] Code follows Effective Dart style guide.
- [ ] Avoids unnecessary `dynamic` types.

## Pitfalls
- **Overusing dynamic**: Defeating the type system.
- **Ignoring Lints**: Accumulating technical debt.
- **Complex One-liners**: Sacrificing readability for brevity in functional chains.
- **Misusing `late`**: Causing runtime errors to avoid compilation errors.
- **Legacy Style**: Writing Java-style code in Dart.

## Example Prompts
1. `@dart-patterns Refactor this class hierarchy to use Dart 3 sealed classes for exhaustive matching.`
2. `@dart-patterns Convert this function returning a custom class to use a Record instead.`
3. `@dart-patterns Simplify this nested for-loop using collection operators and spreads.`
4. `@dart-patterns Create an extension method on String to validate email format.`
5. `@dart-patterns Explain how to use pattern matching for JSON parsing in Dart.`
