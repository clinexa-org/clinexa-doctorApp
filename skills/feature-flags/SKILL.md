---
name: "Feature Flags for Flutter"
description: "Implement feature flags, remote config, kill switches, and gradual rollouts in Flutter apps with safe defaults and caching."
---

# Feature Flags for Flutter

## Purpose
Control feature availability dynamically without app updates. Enable gradual rollouts, A/B testing, kill switches, and environment-specific configurations.

## When to Use
- Launching a new feature to a subset of users.
- Enabling quick rollback of problematic features.
- Running A/B tests on UI or behavior.
- Differentiating features between dev, staging, and production.
- Hiding incomplete features in production builds.

## Inputs You Need from Me
- Features to flag (new, risky, experimental).
- Targeting criteria (user %, user groups, device types).
- Flag source (Firebase Remote Config, custom backend, local).
- Fallback requirements (what happens if flag fetch fails).
- Caching and refresh strategy.

## Step-by-Step Process
1. **Inventory features**: List all features that need flags.
2. **Define flag model**: Create a typed flag class (name, type, default value).
3. **Choose flag provider**: Select Firebase Remote Config, LaunchDarkly, or custom.
4. **Implement flag service**: Create a service that fetches, caches, and evaluates flags.
5. **Set safe defaults**: Define defaults that work if remote config fails.
6. **Add evaluation points**: Integrate flag checks at feature entry points.
7. **Implement caching**: Cache flags locally with TTL.
8. **Plan rollout**: Define percentage/targeting rules.
9. **Add analytics**: Track flag exposure for A/B analysis.

## Deliverables
- **Flag model**: Dart class representing flags with types and defaults.
- **Evaluation rules**: How flags are evaluated (user targeting, percentages).
- **Rollout plan**: Phased rollout schedule with rollback triggers.
- **Example integration**: Code showing flag checks in UI and business logic.

## Quality Checklist
- [ ] All flags have safe, tested defaults.
- [ ] Flag fetch failures don't crash the app.
- [ ] Flags are cached with appropriate TTL.
- [ ] Flag changes can be force-refreshed.
- [ ] A/B exposures are logged for analysis.
- [ ] Flags are documented in a central registry.

## Pitfalls
- **No defaults**: App breaks when remote config is unavailable.
- **Flag sprawl**: Too many flags making code hard to maintain.
- **Stale flags**: Flags that are never cleaned up after rollout.
- **Testing gaps**: Features tested only with flags on or off, not both.
- **Slow fetches**: Blocking app startup on remote config.

## Example Prompts
1. `@feature-flags Help me set up Firebase Remote Config in my Flutter app with safe defaults and caching.`
2. `@feature-flags I need to roll out a new checkout flow to 10% of users and increase gradually. Design the flag and rollout plan.`
3. `@feature-flags Show me how to implement a kill switch that instantly disables a feature if it causes crashes.`
4. `@feature-flags How do I structure feature flags for A/B testing button colors and track conversion?`
5. `@feature-flags My app has 30 feature flags and it's hard to manage. Help me create a flag registry and cleanup strategy.`
