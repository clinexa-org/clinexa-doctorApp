---
name: "Dart Async Patterns"
description: "Master asynchronous programming in Dart including Futures, Streams, async/await, generators, and error handling."
---

# Dart Async Patterns

## Purpose
Handle concurrency and asynchronous operations correctly in Dart. Build responsive apps that manage network calls, user input streams, and background tasks efficiently.

## When to Use
- Implementing network requests, file I/O, or database operations.
- Handling real-time data flow (WebSockets, sensor data).
- Debugging race conditions or unhandled async errors.
- Implementing complex transformations on data streams (RxDart style).
- managing backpressure or throttling user input.

## Inputs You Need from Me
- nature of the async task (one-off vs continuous stream).
- Data sources involved.
- Error handling requirements.
- Cancellation needs.

## Step-by-Step Process
1. **Choose Primitive**: `Future` for single value, `Stream` for multiple.
2. **Implement Logic**: Use `async`/`await` for linear readability.
3. **Handle Errors**: Use `try/catch` for Futures, `.handleError` or `onError` for Streams.
4. **Resource Management**: Properly close sinks, cancel subscriptions.
5. **Transform Data**: Use `.map`, `.asyncMap`, `.where` to process data in flight.
6. **Concurrency**: Use `Future.wait` for parallel, `StreamGroup` for merging.
7. **Generators**: Use `async*` and `yield` for generating streams declaratively.

## Deliverables
- **Async Logic**: robust code handling success, error, and loading states.
- **Stream Transformers**: Custom logic for stream manipulation.
- **Error Handling Strategy**: Code ensuring async errors don't crash the app.
- **Resource Cleanup**: Correct disposal logic.

## Quality Checklist
- [ ] `await` is not used in loops sequentially if parallel is possible (use `Future.wait`).
- [ ] StreamSubscriptions are cancelled to prevent leaks.
- [ ] Async errors are caught and handled.
- [ ] UI is updated on main thread (Dart handles this, but logic can block).
- [ ] Asynchronous gaps are handled correctly in Flutter context.
- [ ] Generators are used for complex stream creation.

## Pitfalls
- **Unawaited Futures**: Starting work that might fail silently or complete after context is gone.
- **Stream Leaks**: Listening without cancelling in StatefulWidgets.
- **Swallowing Errors**: Empty catch blocks hiding critical failures.
- **Callback Hell**: Using `.then` chains instead of `async/await`.
- **Blocking Main Thread**: Doing heavy compute in async function vs Isolate.

## Example Prompts
1. `@dart-async-patterns Help me implement a search bar that debounces input using Streams.`
2. `@dart-async-patterns I need to execute 3 API calls in parallel and wait for all to finish.`
3. `@dart-async-patterns Refactor this .then() callback chain to use async/await.`
4. `@dart-async-patterns Create a Stream generator that yields a countdown timer.`
5. `@dart-async-patterns Handle errors in this stream so the UI shows an error message instead of crashing.`
