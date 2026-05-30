# CyberShell Academy

CyberShell Academy is a terminal-based cyber training RPG that teaches Windows and Linux command-line fundamentals through missions, XP, ranks, daily challenges, boss trials, badges, and anonymous operator profiles.

## Features

- Anonymous local operator profiles
- Saved progress
- Windows Light Path
- Linux Shadow Path
- XP and rank progression
- Locked missions
- Real answer checking
- Placement test
- Boss trials
- Badges
- Daily challenge
- Local leaderboard
- Terminal cyber-style UI

## Install on Ubuntu or Linux

Run these commands:

    git clone https://github.com/m4ckDev/cyber-games-powershell.git
    cd cyber-games-powershell
    chmod +x install.sh
    ./install.sh

Then run the game:

    cybergame

## Manual Run

    pwsh -NoProfile -ExecutionPolicy Bypass -File ./Start-CyberShell.ps1

## Local Save Data

Player data is stored locally and ignored by Git:

    data/profiles.json
    data/leaderboard.json
    data/daily-state.json

## Purpose

This project is designed for safe, beginner-friendly command-line training. It focuses on system administration, Linux fundamentals, Windows fundamentals, and defensive cyber awareness.
