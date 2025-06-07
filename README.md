# Git-For-Idiots (solo)

Many people are overwhelmed by Git's complexity. I am not here to judge that.

However, having online backups and version control is still a major nice-to-have, especially when working with CLI AI agents like Claude Code or conducting "vibe coding".

That's why this repository breaks down the whole Git functionality to **four basic commands** which allow full Git use including rollbacks and version management.

Please be aware that this is **for solo projects only** on macOS, and please also be aware that **every experienced coder will disrespect you for using this**. 
However, I still love to make things as simple as they can be, and this repository achieves exactly that.



## Install
Run this in your terminal:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/AlexSchardin/Git-For-Idiots-solo/main/install.sh)"
```
Then, close and reopen your terminal.



[![Watch the video](https://img.youtube.com/vi/Elf3-Zhw_c0/0.jpg)](https://youtu.be/Elf3-Zhw_c0)


## Basic Commands
| Command | Description |
|---------|-------------|
| `create "name"` | Creates a private GitHub repo for this folder, pushing files as v1. |
| `push "message"` | Saves current changes to GitHub as a new version (v2, v3, etc.). |
| `rollback v[#]` | Rolls back the project to the state of a previous version. |
| `versions` | Lists all available versions of your project. |

## Extra Commands
| Command | Description |
|---------|-------------|
| `mirror "url"` | Creates your own private GitHub mirror of any repo you can access. |
| `remove-git` | Deletes all Git history from the folder (files are safe). |
| `all` | Shows this list of all available commands. |
