---
name: "Versioning Strategies for Flutter"
description: "Implement semantic versioning, build numbers, release channels, flavors, and changelog discipline for Flutter app releases."
---

# Versioning Strategies for Flutter

## Purpose
Manage app versions systematically for predictable releases. Coordinate version numbers, build numbers, changelogs, and release channels across dev, staging, and production.

## When to Use
- Setting up versioning for a new app.
- Preparing for app store submissions.
- Managing multiple release channels (dev, beta, prod).
- Implementing CI/CD with automated version bumping.
- Communicating changes to users via changelogs.

## Inputs You Need from Me
- Current versioning approach (if any).
- Release cadence (weekly, biweekly, on-demand).
- Release channels needed (dev, staging, beta, prod).
- CI/CD platform in use.
- Changelog requirements.

## Step-by-Step Process
1. **Define versioning scheme**: Choose semantic versioning (MAJOR.MINOR.PATCH).
2. **Map build numbers**: Decide build number strategy (incrementing, date-based).
3. **Configure pubspec.yaml**: Set version and build number patterns.
4. **Set up flavors**: Configure Android/iOS flavors for different environments.
5. **Create version bump rules**: Define when to bump major, minor, patch.
6. **Implement changelog discipline**: Maintain CHANGELOG.md with each release.
7. **Integrate with CI**: Automate version bumping and tagging in pipelines.
8. **Tag releases**: Create git tags for each release.
9. **Document migration notes**: Note breaking changes and upgrade steps.

## Deliverables
- **Versioning policy**: Document defining version number meanings and rules.
- **CI-friendly steps**: Scripts or CI jobs for automated version bumping.
- **Release checklist**: Steps to follow for each release.
- **Example version bump rules**: When to bump which version component.

## Quality Checklist
- [ ] Version numbers follow semantic versioning.
- [ ] Build numbers are unique and incrementing.
- [ ] CHANGELOG is updated with every release.
- [ ] Git tags match released versions.
- [ ] Breaking changes are documented in migration notes.
- [ ] CI automates version bumping correctly.

## Pitfalls
- **Manual version bumping**: Error-prone and often forgotten.
- **Inconsistent build numbers**: Causing store rejection or confusion.
- **Empty changelogs**: Users don't know what changed.
- **Missing tags**: Hard to trace deployed versions to code.
- **Version conflicts**: Multiple releases with same version number.

## Example Prompts
1. `@versioning-strategies Help me set up semantic versioning for my Flutter app with automated build number incrementing in CI.`
2. `@versioning-strategies I need to manage dev, staging, and production builds with different version suffixes. Design the flavor/version structure.`
3. `@versioning-strategies Create a GitHub Actions workflow that bumps version, updates CHANGELOG, and creates a git tag on release.`
4. `@versioning-strategies What's the best practice for build numbers to satisfy both Google Play and App Store requirements?`
5. `@versioning-strategies Help me create a release checklist template for my Flutter app that includes version bumping, testing, and store submission.`
