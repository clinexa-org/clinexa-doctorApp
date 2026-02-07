---
name: "Monitoring & Observability for Flutter"
description: "Implement logging, crash reporting, performance traces, and user journey tracking in Flutter apps for production visibility."
---

# Monitoring & Observability for Flutter

## Purpose
Gain visibility into Flutter app behavior in production. Detect crashes, performance issues, and user experience problems before they become critical.

## When to Use
- Setting up a new app for production.
- Investigating production crashes or ANRs.
- Optimizing app performance (startup time, frame rate).
- Understanding user behavior and drop-off points.
- Meeting compliance requirements for audit logging.

## Inputs You Need from Me
- Current monitoring tools (if any).
- Key user journeys to track.
- Performance SLOs (e.g., startup < 2s, 60fps).
- Privacy/compliance requirements.
- Budget for monitoring services.

## Step-by-Step Process
1. **Define observability goals**: What do you need to see? (crashes, performance, behavior)
2. **Select tools**: Choose crash reporting (Firebase Crashlytics, Sentry), analytics, APM.
3. **Implement structured logging**: Define log levels, formats, and breadcrumbs.
4. **Add crash reporting**: Integrate and test crash capture.
5. **Add performance traces**: Instrument startup, navigation, and key operations.
6. **Define key events**: List events that indicate success/failure in user journeys.
7. **Create dashboards**: Set up dashboards for key metrics.
8. **Set up alerts**: Define thresholds for crash rates, errors, performance.

## Deliverables
- **Observability plan**: What to monitor and why.
- **Logging conventions**: Log levels, structured data, PII handling.
- **Dashboards/events list**: Key metrics and events to track.
- **Integration checklist**: Steps to integrate each tool.

## Quality Checklist
- [ ] Crashes are captured with stack traces and breadcrumbs.
- [ ] Logs are structured (JSON) and don't contain PII.
- [ ] Performance traces cover startup and key screens.
- [ ] Critical errors trigger alerts.
- [ ] Dashboards show app health at a glance.
- [ ] Observability doesn't impact app performance.

## Pitfalls
- **Log spam**: Too many logs making it hard to find issues.
- **PII leaks**: Logging sensitive user data.
- **Missing context**: Crashes without breadcrumbs or user state.
- **Alert fatigue**: Too many alerts that get ignored.
- **Performance overhead**: Monitoring slowing down the app.

## Example Prompts
1. `@monitoring-observability Help me set up Firebase Crashlytics in my Flutter app with breadcrumbs and custom keys.`
2. `@monitoring-observability I need to track app startup performance and identify slow frames. Show me how to implement traces.`
3. `@monitoring-observability Design a logging strategy for my app with log levels, structured data, and log rotation.`
4. `@monitoring-observability What key events and metrics should I track for an e-commerce Flutter app?`
5. `@monitoring-observability My crash reports lack context. Help me add breadcrumbs for user actions before crashes.`
