$ErrorActionPreference = "SilentlyContinue"

function Write-Section($Title) {
    $line = "=" * 60
    $script:Report += "`n$line`n$Title`n$line`n"
}

function Add-Line($Text) {
    $script:Report += "$Text`n"
}

$script:Report = ""
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$computerName = $env:COMPUTERNAME

$desktop = [Environment]::GetFolderPath("Desktop")
$reportPath = Join-Path $desktop "system-health-report_$computerName`_$timestamp.txt"

Write-Section "System Health Check"
Add-Line "Computer Name: $computerName"
Add-Line "User: $env:USERNAME"
Add-Line "Date: $(Get-Date)"

Write-Section "Operating System"
$os = Get-CimInstance Win32_OperatingSystem
if ($os) {
    Add-Line "OS: $($os.Caption)"
    Add-Line "Version: $($os.Version)"
    Add-Line "Build: $($os.BuildNumber)"
    $uptime = (Get-Date) - $os.LastBootUpTime
    Add-Line ("Uptime: {0} days {1} hours {2} minutes" -f $uptime.Days, $uptime.Hours, $uptime.Minutes)
}

Write-Section "CPU"
$cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
if ($cpu) {
    Add-Line "CPU: $($cpu.Name)"
    Add-Line "Cores: $($cpu.NumberOfCores)"
    Add-Line "Logical Processors: $($cpu.NumberOfLogicalProcessors)"
}

Write-Section "Memory"
$cs = Get-CimInstance Win32_ComputerSystem
if ($cs -and $cs.TotalPhysicalMemory) {
    $totalGb = [Math]::Round($cs.TotalPhysicalMemory / 1GB, 2)
    Add-Line "Total Physical Memory: $totalGb GB"
}
if ($os) {
    $totalMem = [Math]::Round($os.TotalVisibleMemorySize / 1MB, 2)
    $freeMem  = [Math]::Round($os.FreePhysicalMemory / 1MB, 2)
    $usedMem  = [Math]::Round($totalMem - $freeMem, 2)
    Add-Line "Memory In Use: $usedMem GB / $totalMem GB"
}

Write-Section "Disk Usage"
$disks = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3"
foreach ($d in $disks) {
    if ($d.Size -gt 0) {
        $total = [Math]::Round($d.Size / 1GB, 2)
        $free  = [Math]::Round($d.FreeSpace / 1GB, 2)
        $used  = [Math]::Round($total - $free, 2)
        $pct   = [Math]::Round(($used / $total) * 100, 1)
        Add-Line "$($d.DeviceID)  Used: $used GB ($pct%)  Free: $free GB  Total: $total GB"
    }
}

Write-Section "Network (IPv4)"
if (Get-Command Get-NetIPAddress -ErrorAction SilentlyContinue) {
    Get-NetIPAddress -AddressFamily IPv4 |
        Where-Object { $_.IPAddress -and $_.IPAddress -notlike "169.*" -and $_.IPAddress -ne "127.0.0.1" } |
        ForEach-Object {
            Add-Line "$($_.InterfaceAlias): $($_.IPAddress)"
        }
}

try {
    $script:Report | Out-File -FilePath $reportPath -Encoding UTF8
} catch {
    $fallback = Join-Path $env:TEMP "system-health-report_$computerName`_$timestamp.txt"
    $script:Report | Out-File -FilePath $fallback -Encoding UTF8
    $reportPath = $fallback
}

Write-Host "Report saved to: $reportPath"
exit 0
