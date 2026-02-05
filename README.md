# Homebrew Tap for [Lolcat++](https://github.com/lolcatpp/lolcatpp)

This is the official Homebrew Tap for **Lolcat++**,
a BLAZINGLY FAST C++ reimplementation of the classic `lolcat` rainbow coloring tool.

## Installation

You can install `lolcat++` by adding this tap and running the install command:

```bash
brew tap lolcatpp/tap
brew install lolcatpp
```

> [!NOTE]
> This will install `lolcat++` as `lolcat`, and is thus a conflict of the [original lolcat](https://github.com/busyloop/lolcat)
> This is by design, as it should be compatible with the original.

## Conflict

If you've already got the original lolcat script installed, then you'll need to tell homebrew to use
this implementation instead. Here's a oneliner that does this for you:

```bash
brew unlink lolcat && brew link lolcatpp
```

## Uninstall

If you want to uninstall the tap and the package, then run the following:

```bash
brew uninstall lolcatpp && brew untap lolcatpp/tap
```
