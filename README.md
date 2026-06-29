<p align="center">
    <a href="https://github.com/hannibal-lee/InputSourcePro" target="_blank">
        <img height="200" src="https://inputsource.pro/img/app-icon.png" alt="Input Source Pro 10.15 Logo">
    </a>
</p>

<h1 align="center">Input Source Pro 10.15</h1>

<p align="center">A macOS 10.15 Catalina compatible build based on Input Source Pro</p>

<p align="center">
    <a href="https://github.com/hannibal-lee/InputSourcePro" target="_blank">Fork Repository</a> ·
    <a href="https://github.com/runjuu/InputSourcePro" target="_blank">Upstream Project</a>
</p>

> **Input Source Pro 10.15** is a Catalina-compatible fork of **Input Source Pro**, a free and open-source macOS utility for multilingual users who frequently switch input sources. It keeps the core app and input-source indicator workflow usable on macOS 10.15 Catalina.

## Compatibility Scope

This fork/build is maintained for **macOS 10.15 Catalina** compatibility.

- Target system: **macOS 10.15.x Catalina**.
- Tested locally on macOS 10.15.8.
- This fork is not validated for non-Catalina macOS releases.
- If you need support outside macOS 10.15.x, prefer the [upstream project](https://github.com/runjuu/InputSourcePro).
- This fork focuses on Catalina compatibility fixes, not on tracking every upstream feature.

<table>
    <tr>
        <td>
            <img src="./imgs/switch-keyboard-base-on-app.gif"  alt="Switch Keyboard Based on App" width="100%">
        </td>
        <td>
            <img src="./imgs/switch-keyboard-base-on-browser.gif"  alt="Switch Keyboard Based on Browser" width="100%">
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

### Additional Notes

Some upstream features may not be present or fully validated in this Catalina-focused fork.


## Installation

### Do Not Use Homebrew for This Fork

Do not install this fork with `brew install --cask input-source-pro`.

The Homebrew cask installs the upstream release and may overwrite this Catalina-compatible build.

### Fork Release or Local Build

Use this fork's release artifacts if available, or build from source and copy the built app to `/Applications`.

## Building from Source

Clone this fork and build it with Xcode:

```bash
git clone git@github.com:hannibal-lee/InputSourcePro.git
```

Then open `Input Source Pro.xcodeproj` in Xcode and build `Input Source Pro 10.15`.

For Catalina-compatible development, use a macOS 10.15 compatible toolchain such as Xcode 12.x. Other Xcode/macOS combinations are not the validation target for this fork.

Automatic updates from the upstream appcast are disabled in this fork. Release updates should be installed from this fork's own release artifacts when available.

## Contributing

Contributions to this fork should stay focused on macOS 10.15 compatibility and Catalina bug fixes.

- For fork-specific Catalina issues, use this fork's GitHub issues.
- For non-Catalina support, new feature requests, and upstream behavior, use the [upstream project](https://github.com/runjuu/InputSourcePro).
- For setup and code guidelines, read [Contributing Guidelines](CONTRIBUTING.md).
- This fork follows the [Code of Conduct](CODE_OF_CONDUCT.md).

## Upstream Project

This fork is based on [runjuu/InputSourcePro](https://github.com/runjuu/InputSourcePro). The upstream project remains the best source for official releases, documentation, discussions, and support outside this Catalina-compatible fork.

## License
Input Source Pro is licensed under the [GPL-3.0 License](LICENSE).
