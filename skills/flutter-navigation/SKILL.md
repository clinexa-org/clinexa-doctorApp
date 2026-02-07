---
name: "Flutter Navigation & Routing"
description: "Master navigation in Flutter including routing packages (GoRouter), deep linking, nested navigation, and type-safe arguments."
---

# Flutter Navigation & Routing

## Purpose
Implement robust, scalable navigation systems in Flutter. Handle deep links, web URLs, authentication guards, and complex nested navigation flows seamlessly.

## When to Use
- Setting up navigation for a new app.
- Migrating from Navigator 1.0 to Router API (Navigator 2.0).
- Implementing deep linking or push notification navigation.
- Adding complex flows like bottom nav with nested stacks.
- Securing routes with authentication guards (redirects).

## Inputs You Need from Me
- App screen hierarchy / sitemap.
- Deep linking requirements (custom schemes, universal links).
- Authentication flow (login, protected routes).
- Library preference (GoRouter, AutoRoute, or native Navigator).
- Argument passing requirements.

## Step-by-Step Process
1. **Choose Strategy**: GoRouter (recommended), AutoRoute, or vanilla Router API.
2. **Define Routes**: Map URLs/paths to Screens/Widgets.
3. **Handle Params**: Define path parameters and query parameters.
4. **Setup Deep Links**: Configure AndroidManifest and Info.plist for schemes/domains.
5. **Implement Guards**: Add redirection logic (e.g., if not logged in -> login page).
6. **Nested Navigation**: Configure ShellRoute (GoRouter) for BottomNavigationBar persistence.
7. **Type Safety**: Use typed routes or code generation for arguments.
8. **Test Navigation**: Write tests verifying route transitions and guards.

## Deliverables
- **Router Configuration**: Code defining the route tree.
- **Deep Link Setup**: Platform specific configuration files.
- **Guard Logic**: Auth redirection implementation.
- **Navigation Tests**: Automated tests for navigation flows.

## Quality Checklist
- [ ] Deep links open the correct screen with correct state.
- [ ] Back button works as expected (especially on Android).
- [ ] Web URLs reflect the current app state.
- [ ] Auth guards prevent unauthorized access reliably.
- [ ] Nested navigation preserves state of inactive tabs.
- [ ] Navigation code is decoupled from UI logic.

## Pitfalls
- **Context Issues**: Using context across async gaps for navigation.
- **Broken Back Stack**: Poor management of the history stack leading to loops or exit.
- **Deep Link Loops**: Infinite redirects when handling links.
- **State Loss**: Rebuilding entire stacks on simple navigation changes.
- **Hardcoded Strings**: Using string literals for route names (prone to typos).

## Example Prompts
1. `@flutter-navigation Help me set up GoRouter with a BottomNavigationBar and nested routes.`
2. `@flutter-navigation Configure deep linking for my app to handle 'myapp://product/:id'.`
3. `@flutter-navigation Implement an auth guard that redirects unauthenticated users to Login.`
4. `@flutter-navigation How do I pass a complex object as an argument between screens using GoRouter?`
5. `@flutter-navigation Migrate my app from Navigator.push to GoRouter.`
