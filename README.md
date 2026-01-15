# Windows System Health Check

A simple tool to collect basic system health information on Windows.

This repository contains:
- A batch file you can double-click to run the tool
- A PowerShell script that gathers system information
- A text report saved locally

## How to run
1. Download the repository files
2. Double-click:
   run-health-check.bat
3. A window will open and stay open
4. A report will be saved to your Desktop

## What it collects
- Windows version and build
- System uptime
- CPU information
- Memory usage
- Disk usage
- IPv4 network addresses

## Output
The report is saved as:

system-health-report_<COMPUTERNAME>_<TIMESTAMP>.txt

If the Desktop path is unavailable, the report is saved to the system Temp folder.
