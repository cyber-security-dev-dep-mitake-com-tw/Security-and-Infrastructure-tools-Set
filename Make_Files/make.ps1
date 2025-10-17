# ============================================
# Security Stack PowerShell Commands
# Windows 替代 Makefile 的腳本
# ============================================

param(
    [Parameter(Position=0)]
    [string]$Command = "help",
    
    [Parameter(Position=1)]
    [string]$Target = ""
)

$COMPOSE_DIR = "..\Docker\compose"
$SCRIPT_DIR = $PSScriptRoot

function Show-Help {
    Write-Host "Security Stack Commands:" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Usage: .\make.ps1 <command> [options]" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Commands:" -ForegroundColor Green
    Write-Host "  up              - Start all services"
    Write-Host "  down            - Stop all services"
    Write-Host "  restart         - Restart all services"
    Write-Host "  ps              - View service status"
    Write-Host "  health          - Check health status"
    Write-Host "  logs            - View logs (use -f for follow mode)"
    Write-Host "  scan-nuclei     - Run Nuclei scan (requires -Target)"
    Write-Host "  scan-nmap       - Run Nmap scan (requires -Target)"
    Write-Host "  backup          - Backup databases"
    Write-Host "  clean           - Remove all volumes"
    Write-Host ""
    Write-Host "Examples:" -ForegroundColor Yellow
    Write-Host "  .\make.ps1 up"
    Write-Host "  .\make.ps1 scan-nuclei -Target https://example.com"
    Write-Host "  .\make.ps1 scan-nmap -Target 192.168.1.1"
}

function Invoke-Up {
    Write-Host "Starting all services..." -ForegroundColor Green
    Push-Location $COMPOSE_DIR
    docker-compose up -d
    Write-Host "Waiting for services to be healthy..." -ForegroundColor Yellow
    Start-Sleep -Seconds 10
    docker-compose ps
    Pop-Location
}

function Invoke-Down {
    Write-Host "Stopping all services..." -ForegroundColor Yellow
    Push-Location $COMPOSE_DIR
    docker-compose down
    Pop-Location
}

function Invoke-Restart {
    Write-Host "Restarting all services..." -ForegroundColor Yellow
    Push-Location $COMPOSE_DIR
    docker-compose restart
    Pop-Location
}

function Invoke-Ps {
    Push-Location $COMPOSE_DIR
    docker-compose ps
    Pop-Location
}

function Invoke-Health {
    Write-Host "Checking service health..." -ForegroundColor Cyan
    Push-Location $COMPOSE_DIR
    docker-compose ps --format "table {{.Service}}`t{{.Status}}"
    Pop-Location
}

function Invoke-Logs {
    Push-Location $COMPOSE_DIR
    docker-compose logs -f
    Pop-Location
}

function Invoke-ScanNuclei {
    if (-not $Target) {
        Write-Host "Error: TARGET is required" -ForegroundColor Red
        Write-Host "Usage: .\make.ps1 scan-nuclei -Target https://example.com"
        exit 1
    }
    
    $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    Write-Host "Running Nuclei scan on $Target..." -ForegroundColor Green
    
    Push-Location $COMPOSE_DIR
    docker-compose run --rm scanner-nuclei nuclei -u $Target -o "/results/nuclei-$timestamp.json"
    Pop-Location
}

function Invoke-ScanNmap {
    if (-not $Target) {
        Write-Host "Error: TARGET is required" -ForegroundColor Red
        Write-Host "Usage: .\make.ps1 scan-nmap -Target 192.168.1.1"
        exit 1
    }
    
    $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    Write-Host "Running Nmap scan on $Target..." -ForegroundColor Green
    
    Push-Location $COMPOSE_DIR
    docker-compose run --rm nmap nmap $Target -oX "/results/nmap-$timestamp.xml"
    Pop-Location
}

function Invoke-Backup {
    $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $backupDir = "..\backups"
    
    if (-not (Test-Path $backupDir)) {
        New-Item -ItemType Directory -Path $backupDir | Out-Null
    }
    
    Write-Host "Creating backup..." -ForegroundColor Green
    Push-Location $COMPOSE_DIR
    docker-compose exec -T postgres pg_dump -U sectools security > "$backupDir\db-$timestamp.sql"
    Pop-Location
    
    Write-Host "Backup created in backups\" -ForegroundColor Green
}

function Invoke-Clean {
    Write-Host "WARNING: This will remove all volumes and data!" -ForegroundColor Red
    $confirmation = Read-Host "Are you sure? (y/N)"
    
    if ($confirmation -eq 'y' -or $confirmation -eq 'Y') {
        Push-Location $COMPOSE_DIR
        docker-compose down -v
        Write-Host "All volumes removed" -ForegroundColor Yellow
        Pop-Location
    } else {
        Write-Host "Cancelled" -ForegroundColor Green
    }
}

# Main execution
switch ($Command.ToLower()) {
    "help" { Show-Help }
    "up" { Invoke-Up }
    "down" { Invoke-Down }
    "restart" { Invoke-Restart }
    "ps" { Invoke-Ps }
    "health" { Invoke-Health }
    "logs" { Invoke-Logs }
    "scan-nuclei" { Invoke-ScanNuclei }
    "scan-nmap" { Invoke-ScanNmap }
    "backup" { Invoke-Backup }
    "clean" { Invoke-Clean }
    default {
        Write-Host "Unknown command: $Command" -ForegroundColor Red
        Write-Host ""
        Show-Help
        exit 1
    }
}

