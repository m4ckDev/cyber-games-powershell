# LeaderboardSystem.ps1
# Handles local leaderboard scores

$Global:LeaderboardPath = Join-Path $PSScriptRoot "../data/leaderboard.json"

function Get-PlayerScore {
    $score = 0

    $score += [int]$Global:Player.Credits
    $score += ([int]$Global:Player.Level * 100)
    $score += ([int]$Global:Player.Reputation * 10)
    $score += ([int]$Global:Player.MissionsCompleted.Count * 50)

    return $score
}

function Load-Leaderboard {
    if (-not (Test-Path $Global:LeaderboardPath)) {
        @() | ConvertTo-Json | Set-Content -Path $Global:LeaderboardPath -Encoding UTF8
        return @()
    }

    $content = Get-Content -Path $Global:LeaderboardPath -Raw

    if ([string]::IsNullOrWhiteSpace($content)) {
        return @()
    }

    try {
        $loaded = $content | ConvertFrom-Json

        if ($null -eq $loaded) {
            return @()
        }

        return @($loaded)
    }
    catch {
        return @()
    }
}

function Save-Leaderboard {
    param (
        [array]$Leaderboard
    )

    $Leaderboard |
        ConvertTo-Json -Depth 10 |
        Set-Content -Path $Global:LeaderboardPath -Encoding UTF8
}

function Submit-LeaderboardScore {
    if ([string]::IsNullOrWhiteSpace($Global:Player.Name)) {
        return
    }

    $leaderboard = Load-Leaderboard
    $currentScore = Get-PlayerScore

    $entry = [ordered]@{
        Name              = $Global:Player.Name
        Rank              = $Global:Player.Rank
        Level             = $Global:Player.Level
        Score             = $currentScore
        XP                = $Global:Player.XP
        Credits           = $Global:Player.Credits
        Reputation        = $Global:Player.Reputation
        MissionsCompleted = $Global:Player.MissionsCompleted.Count
        Date              = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    }

    $leaderboard += [pscustomobject]$entry

    $leaderboard = $leaderboard |
        Sort-Object Score -Descending |
        Select-Object -First 10

    Save-Leaderboard -Leaderboard $leaderboard
}

function Show-Leaderboard {
    Show-SectionHeader "Local Leaderboard"

    $leaderboard = Load-Leaderboard

    if ($leaderboard.Count -eq 0) {
        Write-Host "No leaderboard scores yet." -ForegroundColor Yellow
        Write-Host ""
        Write-Host "Complete a mission first. Apparently glory requires effort." -ForegroundColor DarkGray
        Pause-Game
        return
    }

    Write-Host "Top Operators" -ForegroundColor Cyan
    Write-Host ""

    $rankNumber = 1

    foreach ($entry in $leaderboard) {
        Write-Host "[$rankNumber] $($entry.Name)" -ForegroundColor Green
        Write-Host "    Rank:        $($entry.Rank)" -ForegroundColor White
        Write-Host "    Level:       $($entry.Level)" -ForegroundColor White
        Write-Host "    Score:       $($entry.Score)" -ForegroundColor Yellow
        Write-Host "    Reputation:  $($entry.Reputation)" -ForegroundColor Cyan
        Write-Host "    Missions:    $($entry.MissionsCompleted)" -ForegroundColor Gray
        Write-Host "    Date:        $($entry.Date)" -ForegroundColor DarkGray
        Write-Host ""

        $rankNumber++
    }

    Pause-Game
}

function Reset-Leaderboard {
    @() | ConvertTo-Json | Set-Content -Path $Global:LeaderboardPath -Encoding UTF8

    Write-Host ""
    Write-Host "Leaderboard reset." -ForegroundColor Yellow
}