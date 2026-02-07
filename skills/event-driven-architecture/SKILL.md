---
name: "Event-Driven Architecture for Mobile"
description: "Design and implement event-driven patterns in Flutter apps using event buses, streams, and domain events for decoupled, testable modules."
---

# Event-Driven Architecture for Mobile

## Purpose
Enable loosely coupled communication between modules in Flutter apps. Decouple features so they can evolve independently while maintaining predictable event flows.

## When to Use
- Multiple features need to react to the same action (e.g., user login).
- You want to decouple modules without direct dependencies.
- Implementing undo/redo, analytics, or audit logging.
- Building reactive UIs that respond to domain events.
- Coordinating background tasks with UI updates.

## Inputs You Need from Me
- Modules or features that need to communicate.
- Types of events (UI events, domain events, system events).
- Current state management approach.
- Whether events need persistence or just in-memory.
- Latency and ordering requirements.

## Step-by-Step Process
1. **Identify event sources**: List all places where significant actions occur.
2. **Define event taxonomy**: Create a hierarchy of event types (domain, UI, system).
3. **Design event contracts**: Define event classes with required data.
4. **Choose delivery mechanism**: Streams, EventBus package, or custom solution.
5. **Implement event bus/dispatcher**: Create a central or distributed event system.
6. **Subscribe listeners**: Connect modules to relevant events.
7. **Handle errors**: Define what happens when a listener fails.
8. **Test event flows**: Write integration tests for event chains.

## Deliverables
- **Event taxonomy**: Categorized list of events in the app.
- **Event contracts**: Dart classes for each event with typed payloads.
- **Sample stream/event handling code**: Working example of publishing and subscribing.
- **Testing guide**: How to test event flows in isolation.

## Quality Checklist
- [ ] Events are immutable and carry only necessary data.
- [ ] Event names clearly describe what happened (past tense).
- [ ] Listeners are single-responsibility and testable.
- [ ] No circular event chains.
- [ ] Errors in one listener don't break others.
- [ ] Events can be logged/traced for debugging.

## Pitfalls
- **Event spaghetti**: Too many events making flow hard to trace.
- **Tight coupling via events**: Events that expose implementation details.
- **Missing events**: Critical actions that don't emit events.
- **Ordering assumptions**: Code that assumes event order without guarantees.
- **Memory leaks**: Listeners not disposed properly.

## Example Prompts
1. `@event-driven-architecture Help me design an event system for my e-commerce app where cart, notifications, and analytics all react to AddToCart events.`
2. `@event-driven-architecture Show me how to implement a simple event bus in Dart using streams.`
3. `@event-driven-architecture I need domain events for my Order module (OrderCreated, OrderShipped, etc.). Help me define the contracts and handlers.`
4. `@event-driven-architecture How do I test that my UserLoggedIn event triggers the correct downstream actions?`
5. `@event-driven-architecture My app has event listeners causing memory leaks. Help me implement proper disposal patterns.`
