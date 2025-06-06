# Git-For-Idiots (solo)

Stop fighting with Git. Start coding.

This is a dead-simple command-line tool that replaces complex Git commands with a few plain-English words. It's designed for solo developers, designers, writers, and anyone who wants to save versions of their work without the headache.

> **This tool is perfect for:**
> *   **Vibe Coding:** Stay in your creative flow without getting bogged down by technical friction.
> *   **AI-Powered Development:** Give your CLI coding agent (like Claude, ChatGPT, etc.) a simple, reliable toolkit to manage your project files.

## The One-Command Installation

Open your terminal (on macOS or Linux) and paste this one line. It handles everything for you.

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/AlexSchardin/Git-For-Idiots-solo/main/install.sh)"
```

After the installer finishes, it will give you one final, simple instruction: **Close the terminal window and open a new one.** That's it!

## How It Works

### For Humans: Achieve "Vibe Coding"

Git is powerful, but its complexity can kill your creative momentum. You have an idea, you build it, and then you hit a wall of `git add`, `git commit`, `git push origin main --tags`...

`Git-For-Idiots` lets you stay in the zone.

*   Made some changes? `push "added a cool new header"`
*   Want to go back? `rollback v5`

It's that simple. It manages versions, commit messages, and tags automatically so you can focus on what actually matters: your project.

### For AI Agents: A Superpower for your CLI Bot

If you use an AI assistant like Claude to write code in your terminal, you know it can struggle with complex, multi-step Git commands.

`Git-For-Idiots` gives your AI a simple API to work with.

**Instead of this complex prompt:**
> "Please stage all the new files, then create a Git commit with the message 'feat: implement user dashboard', then create a new Git tag called v4, and finally push the commit and the tags to the main branch on the remote repository."

**You can just say this:**
> "Run the command: `push "feat: implement user dashboard"`"

The AI can reliably execute this one command, making your development process smoother and faster.

## The Only Commands You Need

Type `all` in your terminal at any time to see this list.

| Command | Description |
| :--- | :--- |
| `create "name"` | Creates a private GitHub project for the current folder. |
| `push "message"` | Saves your current changes to GitHub as a new version. |
| `rollback v[#]` | Reverts your project back to a previous version's state. |
| `versions` | Shows you a list of all your saved versions. |
| `mirror "url"` | Makes a private copy of someone else's public project. |
| `remove-git` | Deletes all version history (but keeps your files safe). |
