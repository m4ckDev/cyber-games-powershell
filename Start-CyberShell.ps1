# CyberShell: Terminal Ops
# Main launcher script

. (Join-Path $PSScriptRoot "engine/UI.ps1")
. (Join-Path $PSScriptRoot "engine/PlayerSystem.ps1")
. (Join-Path $PSScriptRoot "engine/SaveSystem.ps1")
. (Join-Path $PSScriptRoot "engine/MissionSystem.ps1")
. (Join-Path $PSScriptRoot "engine/LeaderboardSystem.ps1")
. (Join-Path $PSScriptRoot "engine/CommandTrainingSystem.ps1")

$Host.UI.RawUI.WindowTitle = "CyberShell: Terminal Ops"

function Initialize-Game {
    Show-StartupSequence

    $saveLoaded = Load-Player

    if ($saveLoaded -eq $false) {
        Write-Host ""
        Write-Host "No operator profile found." -ForegroundColor Yellow
        Pause-Game
        New-Player
    }
    else {
        Write-Host ""
        Write-Host "Operator profile loaded: $($Global:Player.Name)" -ForegroundColor Green
        Start-Sleep -Milliseconds 600
    }
}

function Show-MainMenu {
    while ($true) {
        Show-Banner
        Show-MiniStatusBar

        Show-MenuTitle "MAIN MENU"

        Show-MenuOption "1" "Start Missions"
        Show-MenuOption "2" "Operator Profile"
        Show-MenuOption "3" "Leaderboard"
        Show-MenuOption "4" "CLI Training Grounds"
        Show-MenuOption "5" "Save Game"
        Show-MenuOption "6" "Reset Save"
        Show-MenuOption "7" "Reset Leaderboard"
        Show-MenuOption "8" "Exit"

        Show-MenuFooter

        $choice = Read-Host "Select an option"

        switch ($choice) {
            "1" {
                Show-MissionMenu
            }

            "2" {
                Show-PlayerProfile
            }

            "3" {
                Show-Leaderboard
            }

            "4" {
                Show-CLITrainingMenu
            }

            "5" {
                Save-Player

                if (Get-Command Submit-LeaderboardScore -ErrorAction SilentlyContinue) {
                    Submit-LeaderboardScore
                }

                Pause-Game
            }

            "6" {
                $confirm = Read-Host "Type RESET to delete your save"

                if ($confirm -eq "RESET") {
                    Reset-Save
                    Pause-Game
                    Initialize-Game
                }
                else {
                    Write-Host "Reset cancelled." -ForegroundColor Yellow
                    Pause-Game
                }
            }

            "7" {
                $confirm = Read-Host "Type RESETBOARD to delete leaderboard scores"

                if ($confirm -eq "RESETBOARD") {
                    Reset-Leaderboard
                    Pause-Game
                }
                else {
                    Write-Host "Leaderboard reset cancelled." -ForegroundColor Yellow
                    Pause-Game
                }
            }

            "8" {
                Save-Player

                if (Get-Command Submit-LeaderboardScore -ErrorAction SilentlyContinue) {
                    Submit-LeaderboardScore
                }

                Write-Host ""
                Write-Host "Disconnecting from CyberShell..." -ForegroundColor DarkGray
                Start-Sleep -Milliseconds 700
                Clear-Host
                exit
            }

            default {
                Write-Host ""
                Write-Host "Invalid option. The machine weeps quietly." -ForegroundColor Red
                Pause-Game
            }
        }
    }
}

Initialize-Game
Show-MainMenu