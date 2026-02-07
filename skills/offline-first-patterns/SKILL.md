---
name: "Offline-First Patterns for Flutter"
description: "Build Flutter apps that work offline with local caching, sync strategies, conflict resolution, and graceful degradation."
---

# Offline-First Patterns for Flutter

## Purpose
Design Flutter apps that provide a seamless experience regardless of network conditions. Cache data locally, sync intelligently, and handle conflicts gracefully.

## When to Use
- Users may have intermittent or no connectivity.
- Data needs to be available immediately without network wait.
- Actions should queue and sync when back online.
- Preventing data loss from network failures.
- Building apps for regions with poor connectivity.

## Inputs You Need from Me
- Key data types that need offline support.
- Sync frequency requirements.
- Conflict resolution strategy preference (last-write-wins, manual merge, etc.).
- Local storage preference (Hive, SQLite, Isar, Drift).
- Read/write patterns (read-heavy, write-heavy, mixed).

## Step-by-Step Process
1. **Identify offline data**: List data that must be available offline.
2. **Choose local storage**: Select Hive (simple), SQLite/Drift (relational), or Isar (fast).
3. **Design cache layers**: Define cache-first, network-first, or stale-while-revalidate.
4. **Implement repository pattern**: Repositories abstract cache vs. network decisions.
5. **Create sync queue**: Queue offline writes for later sync.
6. **Define conflict resolution**: Choose and implement merge strategy.
7. **Build connectivity awareness**: Detect and react to network changes.
8. **Handle error states in UI**: Show appropriate offline indicators.
9. **Test offline scenarios**: Simulate offline, slow, and intermittent networks.

## Deliverables
- **Offline data flow diagram**: Visual of how data moves between cache, network, and UI.
- **Repository/cache design**: Class structure for offline-first data access.
- **Sync algorithm steps**: Detailed sync logic with conflict handling.
- **Error states UI guidance**: What to show users in offline/sync states.

## Quality Checklist
- [ ] App is usable without network.
- [ ] Data syncs automatically when network returns.
- [ ] Conflicts are resolved consistently.
- [ ] User is informed of offline/sync status.
- [ ] No data loss on network failures.
- [ ] Offline mode is tested in CI.

## Pitfalls
- **Stale data**: Showing outdated cached data without indication.
- **Sync storms**: Syncing too aggressively when network returns.
- **Silent failures**: Writes failing without user knowledge.
- **Storage bloat**: Cache growing unbounded.
- **Conflict chaos**: Inconsistent merge results.

## Example Prompts
1. `@offline-first-patterns Help me design an offline-first architecture for a notes app using Hive for local storage.`
2. `@offline-first-patterns My app needs to queue API calls when offline and retry when online. Show me a sync queue implementation.`
3. `@offline-first-patterns How do I implement stale-while-revalidate for my product catalog in Flutter?`
4. `@offline-first-patterns Design a conflict resolution strategy for a collaborative document editing app.`
5. `@offline-first-patterns What UI patterns should I use to indicate offline status and sync progress to users?`
