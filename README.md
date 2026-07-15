# NordVPN-Latency-Optimizer

PowerShell script that automatically finds the best NordVPN servers based on latency, jitter, and server load from your own network connection.

The script dynamically retrieves the current NordVPN server list through the NordVPN API, tests the selected country's servers from your own connection, calculates a quality score, and generates a ranked list of the best available servers.

---

## Features

✅ Dynamic server discovery using NordVPN API  
✅ Supports all NordVPN countries  
✅ No hardcoded server lists  
✅ Measures latency from your own location  
✅ Calculates ping stability (jitter)  
✅ Includes NordVPN server load  
✅ Generates a ranked Top 10 list  
✅ Windows PowerShell 5.1 compatible  
✅ No external dependencies  

---

# How It Works

The optimizer performs the following steps:

```text
Start script
     |
     v
Select country code
     |
     v
Download current NordVPN server list
     |
     v
Filter servers by country
     |
     v
Ping every available server
     |
     v
Calculate latency + jitter + load score
     |
     v
Generate Top 10 server list
```

The result is based on your own network connection, meaning the selected servers are optimized for your actual location and ISP.

---

# Requirements

## Operating System

Supported:

- Windows 10
- Windows 11
- Windows Server

## PowerShell

Required:

```powershell
Windows PowerShell 5.1 or newer
```

- Active NordVPN subscription
- Internet connection

---

# Installation

## Option 1 - Download Script

Open the GitHub repository.

Download:

```
NordVPN-Server-Optimizer.ps1
```

Save it to a folder.

Example:

```
C:\Users\YourName\Downloads\NordVPN-Server-Optimizer.ps1
```

---

## Option 2 - Clone Repository

For users with Git installed:

```bash
git clone https://github.com/YOUR_USERNAME/NordVPN-Server-Optimizer.git
```

Enter the folder:

```bash
cd NordVPN-Server-Optimizer
```

---

# Running the Script

Open PowerShell in the script directory.

Example:

```powershell
cd "$env:USERPROFILE\Downloads"
```

Run:

```powershell
.\NordVPN-Server-Optimizer.ps1
```

---

# First Run - Execution Policy

If Windows blocks script execution, you may see:

```
running scripts is disabled on this system
```

Allow execution only for the current PowerShell session:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

Run the script again:

```powershell
.\NordVPN-Server-Optimizer.ps1
```

This does not permanently change Windows security settings.

---

# Country Selection

When started, the script asks:

```
Enter country code:
```

Enter a two-letter country code.

Examples:

Germany:

```
de
```

Switzerland:

```
ch
```

Austria:

```
at
```

United States:

```
us
```


The script automatically discovers all available servers in that country.

---

# Example Run

Example:

<img width="969" height="1382" alt="image" src="https://github.com/user-attachments/assets/86624433-aa62-4d2a-89a8-32a1361ebef0" />



# Output File

After completion, the script creates:

```
best-server.txt
```

Example:

```
de680.nordvpn.com;Ping=21.33ms;Jitter=1ms;Load=8%;Score=13.04
de678.nordvpn.com;Ping=19.67ms;Jitter=2ms;Load=12%;Score=13.85
```

The file is created in the same folder as the PowerShell script.

---

# Scoring System

The optimizer calculates a score where lower is better.

Formula:

```text
Score =
    Latency 50%
  + Jitter 20%
  + Server Load 30%
```

## Latency

Average ICMP response time.

Lower latency means faster response.

## Jitter

Difference between the fastest and slowest ping response.

Lower jitter means a more stable connection.

## Server Load

Current NordVPN server utilization.

A slightly slower server with lower load can outperform a faster but overloaded server.

---

# Using Results With OpenVPN

NordVPN provides official OpenVPN configuration files:

```
https://downloads.nordcdn.com/configs/archives/servers/ovpn.zip
```

Download and extract the archive.

Example structure:

```
ovpn_udp
 |
 ├── de678.nordvpn.com.udp.ovpn
 ├── de680.nordvpn.com.udp.ovpn
```

Take the hostname from:

```
best-server.txt
```

and use the matching `.ovpn` configuration file.

Example:

Selected server:

```
de680.nordvpn.com
```

OpenVPN configuration:

```
ovpn_udp/de680.nordvpn.com.udp.ovpn
```
