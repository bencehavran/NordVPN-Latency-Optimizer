# NordVPN-Latency-Optimizer
PowerShell script to find the fastest NordVPN Germany servers based on:


- ICMP latency
- jitter
- stability

The script automatically tests NordVPN German servers and generates a ranked list of the best servers.

## Features

✅ Windows PowerShell 5.1 compatible  
✅ No external dependencies  
✅ Tests hundreds of NordVPN servers  
✅ Calculates latency and jitter  
✅ Generates Top 10 server list  
✅ Overwrites result file automatically  


## Requirements

- Windows 10 / Windows 11
- PowerShell 5.1 or newer
- Active NordVPN subscription


## Usage

Download:

git clone https://github.com/YOURNAME/NordVPN-Latency-Optimizer.git

.\NordVPN-Latency-Optimizer.ps1

The result will be created:


best-server.txt



Example:


de850.nordvpn.com;Ping=9.4ms;Jitter=1ms;Score=9.72
de912.nordvpn.com;Ping=10.1ms;Jitter=0.8ms;Score=10.24



## OpenVPN configuration files

NordVPN provides official OpenVPN configuration files:

https://downloads.nordcdn.com/configs/archives/servers/ovpn.zip

Download and extract:


ovpn_udp
ovpn_tcp


folders.

Example:


ovpn_udp/de850.nordvpn.com.udp.ovpn


Use the matching server from `best-server.txt`.


## How scoring works

The script calculates:


Score = latency × 80% + jitter × 20%


Lower score means better server.


Example:

| Server | Ping | Jitter | Score |
|---|---:|---:|---:|
| de850 | 9.4ms | 1ms | 9.72 |
| de912 | 10.1ms | 0.8ms | 10.24 |


## Limitations

- ICMP latency does not always equal VPN throughput
- Server load is not included
- Some NordVPN servers may not respond to ping


## License

MIT License
