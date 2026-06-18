<p align="center">
    <a href="https://inputsource.pro" target="_blank">
        <img height="200" src="https://inputsource.pro/img/app-icon.png" alt="Input Source Pro Logo">
    </a>
</p>

<h1 align="center">Input Source Pro - Catalina Compatible Fork</h1>

<p align="center">A macOS 10.15 Catalina compatible build of Input Source Pro</p>

<p align="center">
    <a href="https://github.com/hannibal-lee/InputSourcePro" target="_blank">Fork Repository</a> ·
    <a href="https://github.com/runjuu/InputSourcePro" target="_blank">Upstream Project</a> ·
    <a href="https://inputsource.pro" target="_blank">Upstream Website</a>
</p>

> This repository is a Catalina-compatible fork of **Input Source Pro**, a free and open-source macOS utility for multilingual users who frequently switch input sources. It keeps the core app and input-source indicator workflow usable on older macOS versions.

## Compatibility Scope

This fork/build is maintained for **macOS 10.15 Catalina** compatibility.

- Target system: **macOS 10.15.x Catalina**.
- Tested locally on macOS 10.15.8.
- Newer macOS versions have not been tested with this fork.
- If you use a newer macOS release, prefer the [upstream project](https://github.com/runjuu/InputSourcePro) or test this build carefully before relying on it.
- This fork focuses on compatibility fixes for older macOS, not on tracking every upstream feature.

<table>
    <tr>
        <td>
            <a href="https://inputsource.pro">
                <img src="./imgs/switch-keyboard-base-on-app.gif"  alt="Switch Keyboard Based on App" width="100%">
            </a>
        </td>
        <td>
            <a href="https://inputsource.pro">
                <img src="./imgs/switch-keyboard-base-on-browser.gif"  alt="Switch Keyboard Based on Browser" width="100%">
            </a>
        </td>
    </tr>
</table>

## Features

### 🥷 Automatic Context-Aware Switching
- Set a default input source per **application**.
- Set input sources per **website** when using browsers (Safari, Chrome, Arc, Edge, Vivaldi, Opera, Brave, Firefox, Zen, Dia, and more).
- Switch automatically as you move between apps/websites.

### 🐈‍⬛ Elegant Input Source Indicator
- Shows your current input source with a clean on-screen indicator.
- Customizable and designed to stay out of your way.

### ✍️ App-Aware Punctuation Modes
Keep punctuation consistent across different languages by enabling **Force English Punctuation** for specific apps.
- Automatically types standard symbols (`` ` ~ - _ $ ^ , . ; ' " [ ] ``) even when your current input source would normally produce localized or full-width characters.
- Enable it only for the apps where you need it, such as code editors or terminal windows.

### 🎛️ App-Based Function Key Switching
Automatically switch your macOS function key mode per app.
- Choose whether an app should use **F1 ~ F12** as:
    - **Standard Function Keys**: Acts as standard F1 ~ F12 keys. Ideal for IDEs (e.g., VSCode) and games.
    - **Media Keys**: Triggers special features printed on the keys (e.g., brightness, volume, playback). Ideal for general daily use.
- Falls back to your system-wide/default setting when an app has no override.

### ⌨️ Custom Shortcuts
Switch input sources via either:
- **Keyboard Shortcuts**: Use standard key combinations.
- **Modifier Shortcuts**: Use single or combined modifier keys (e.g., Shift, Command, or Shift + Command), triggered by pressing once or double-tapping.

### 😎 And Much More...

<a href="https://inputsource.pro">
    <img width="892" alt="image" src="https://github.com/user-attachments/assets/351e2ac9-27d8-402e-8739-21c3f604a3c1" />
</a>


## Installation

### Homebrew

```bash
brew install --cask input-source-pro
```

The Homebrew cask installs the upstream release, not this Catalina-compatible fork.

### Manual Download

Use this fork's releases if available, or build from source.

## Building from Source

Clone this fork and build it with Xcode:

```bash
git clone git@github.com:hannibal-lee/InputSourcePro.git
```

Then open `Input Source Pro.xcodeproj` in Xcode and build the app.

For Catalina-compatible development, use a macOS 10.15 compatible toolchain such as Xcode 12.x. Newer Xcode/macOS combinations are not the validation target for this fork.

Automatic updates from the upstream appcast are disabled in this fork. Release updates should be installed from this fork's own release artifacts when available.

## Contributing

Contributions to this fork should stay focused on macOS 10.15 compatibility and bug fixes for older macOS environments.

- For fork-specific Catalina issues, use this fork's GitHub issues.
- For latest macOS support, new feature requests, and upstream behavior, use the [upstream project](https://github.com/runjuu/InputSourcePro).
- For setup and code guidelines, read [Contributing Guidelines](CONTRIBUTING.md).
- This fork follows the [Code of Conduct](CODE_OF_CONDUCT.md).

## Upstream Project

This fork is based on [runjuu/InputSourcePro](https://github.com/runjuu/InputSourcePro). The upstream project remains the best source for current releases, official documentation, discussions, and support for newer macOS versions.

## Upstream Star History

<a href="https://www.star-history.com/#runjuu/InputSourcePro&type=date&legend=bottom-right">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=runjuu/InputSourcePro&type=date&theme=dark&legend=bottom-right" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=runjuu/InputSourcePro&type=date&legend=bottom-right" />
   <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=runjuu/InputSourcePro&type=date&legend=bottom-right" />
 </picture>
</a>

## License
Input Source Pro is licensed under the [GPL-3.0 License](LICENSE).
