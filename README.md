# Windows System Health Check

A simple Windows tool to collect basic system health information.

This repository includes:
- A batch file that runs by double-click
- A PowerShell script that gathers system data
- A text report saved locally

---

## How to run (double-click)
1. Download the files
2. Double-click `run-health-check.bat`
3. A window opens and stays open
4. A report is saved to your Desktop

---

## How to run (PowerShell)
```powershell
.\system-health-check.ps1

If scripts are blocked, run once:

Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned

What it collects

    Windows version and uptime

    CPU and memory info

    Disk usage

    IPv4 network addresses

Output

system-health-report_<COMPUTERNAME>_<TIMESTAMP>.txt
Saved to Desktop or Temp folder.

