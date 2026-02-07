---
name: "Flutter Performance Optimization"
description: "Profile and optimize Flutter apps for 60/120 FPS, efficient memory usage, and fast startup times."
---

# Flutter Performance Optimization

## Purpose
Identify bottlenecks and optimize Flutter applications to ensure smooth rendering, low battery consumption, and responsiveness. Deliver a high-quality user experience.

## When to Use
- App feels "janky" or drops frames during animations/scrolling.
- App startup time is slow.
- High memory usage causes crashes or background terminations.
- Battery drain is noticeable.
- Preparing for release to ensure optimal performance.

## Inputs You Need from Me
- Specific performance symptom (jank, crash, slow load).
- Target devices (low-end Android, specific iOS).
- Codebase access or snippets of problematic areas.
- Profile mode traces (if available).

## Step-by-Step Process
1. **Reproduce & Profile**: Run in **Profile Mode** to measure performance (DevTools).
2. **Identify Bottlenecks**: Look for long raster threads, heavy build methods, or expensive computations.
3. **Optimize Build**: Use `const` widgets, extract widgets to prevent full tree rebuilds.
4. **Optimize Rendering**: Use `RepaintBoundary`, avoid expensive clips/opacity without layers.
5. **Optimize Lists**: Ensure `ListView.builder` is used, implement proper caching.
6. **Async/Isolates**: Move heavy sorting/parsing/computation to Isolates (compute).
7. **Image Optimization**: Cache images, resize to display size, use appropriate formats.
8. **Memory Leaks**: Check for undisposed controllers/streams using Memory view.
9. **Verify**: Re-profile to confirm improvements.

## Deliverables
- **Profiling Analysis**: Report on what is causing the issue.
- **Optimized Code**: Refactored widgets/logic.
- **Best Practices**: Guidelines to avoid regression.
- **Verification**: Before/After metrics.

## Quality Checklist
- [ ] App runs consistently at 60fps (or native refresh rate).
- [ ] Heavy computations do not block the UI thread.
- [ ] Lists scroll smoothly without stutter.
- [ ] Memory usage is stable and leaks are resolved.
- [ ] Oversized images are not loaded into memory.
- [ ] `const` constructors are used wherever possible.

## Pitfalls
- **Profiling in Debug Mode**: Performance metrics are invalid in Debug mode.
- **Premature Optimization**: optimizing code that isn't a bottleneck.
- **Overusing RepaintBoundary**: Can use too much memory if applied everywhere.
- **Ignoring Low-End Devices**: Testing only on flagship phones hiding real issues.
- **Blocking UI Thread**: Performing JSON parsing or DB ops on the main thread.

## Example Prompts
1. `@flutter-performance My ListView is lagging when scrolling. Help me optimize it.`
2. `@flutter-performance Analyze this build method and suggest optimizations to reduce rebuilds.`
3. `@flutter-performance How do I run heavy JSON parsing in a background isolate?`
4. `@flutter-performance I have a memory leak in my navigation stack. Help me debug it.`
5. `@flutter-performance Tips for improving app startup time.`
