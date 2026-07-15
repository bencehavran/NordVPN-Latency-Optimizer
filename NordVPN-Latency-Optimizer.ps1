<#
.SYNOPSIS
    NordVPN Server Optimizer

.DESCRIPTION
    Finds the best NordVPN servers based on latency, jitter and server load.

    Uses NordVPN API to retrieve the current server list.
    Compatible with Windows PowerShell 5.1+

.VERSION
    2.1
#>


# Configuration

$scriptFolder = Split-Path -Parent $MyInvocation.MyCommand.Path

if ([string]::IsNullOrWhiteSpace($scriptFolder)) {
    $scriptFolder = Get-Location
}

$outputFile = Join-Path $scriptFolder "best-server.txt"

$pingCount = 3


# Header

Write-Host ""
Write-Host "=====================================" -ForegroundColor Green
Write-Host "      NordVPN Server Optimizer       " -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Green
Write-Host ""


# Country selection

$country = Read-Host "Enter country code (example: de, ch, at, us)"

$country = $country.ToLower()


# Download server list

Write-Host ""
Write-Host "Downloading NordVPN server list..." -ForegroundColor Yellow


try {

    $servers = Invoke-RestMethod `
        -Uri "https://api.nordvpn.com/v1/servers?limit=10000" `
        -ErrorAction Stop

}
catch {

    Write-Host "Cannot download NordVPN server list." -ForegroundColor Red
    exit

}



# Filter country servers

$countryServers = $servers |
    Where-Object {
        $_.locations.country.code.ToLower() -eq $country
    }



if ($countryServers.Count -eq 0) {

    Write-Host ""
    Write-Host "No servers found for country: $country" -ForegroundColor Red
    exit

}



Write-Host ""
Write-Host "Found $($countryServers.Count) servers" -ForegroundColor Green
Write-Host ""


# Table header

Write-Host ("{0,-35} {1,-10} {2}" -f "Server", "Load", "Latency")
Write-Host ("-" * 65)


$results = @()

$count = 0



foreach ($server in $countryServers) {


    $count++

    $hostname = $server.hostname
    $load = $server.load


    Write-Progress `
        -Activity "Testing NordVPN servers" `
        -Status "$hostname ($count/$($countryServers.Count))" `
        -PercentComplete (($count / $countryServers.Count) * 100)



    try {


        $pings = Test-Connection `
            -ComputerName $hostname `
            -Count $pingCount `
            -ErrorAction Stop



        $times = $pings.ResponseTime


        $avg = ($times | Measure-Object -Average).Average

        $min = ($times | Measure-Object -Minimum).Minimum

        $max = ($times | Measure-Object -Maximum).Maximum


        $jitter = $max - $min



        # Score calculation
        #
        # Latency 50%
        # Jitter 20%
        # Server Load 30%

        $score = [math]::Round(
            ($avg * 0.5) +
            ($jitter * 0.2) +
            ($load * 0.3),
            2
        )



        $results += [PSCustomObject]@{

            Server = $hostname

            Load = $load

            Ping = [math]::Round($avg,2)

            Jitter = [math]::Round($jitter,2)

            Score = $score

        }



        Write-Host (
            "{0,-35} Load: {1,3}%   Ping: {2,7} ms" -f `
            $hostname,
            $load,
            [math]::Round($avg,2)
        ) -ForegroundColor Cyan



    }

    catch {

        # unreachable servers ignored

    }

}



Write-Progress `
    -Activity "Finished" `
    -Completed



# Top 10

$best = $results |
    Sort-Object Score |
    Select-Object -First 10



Write-Host ""
Write-Host "=====================================" -ForegroundColor Green
Write-Host "          TOP 10 SERVERS             " -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Green
Write-Host ""


$best |
    Select-Object Server, Load, Ping, Jitter, Score |
    Format-Table -AutoSize



# Save result

if ($best.Count -gt 0) {


    $best |
        ForEach-Object {

            "$($_.Server);Load=$($_.Load)%;Ping=$($_.Ping)ms;Jitter=$($_.Jitter)ms;Score=$($_.Score)"

        } |
        Set-Content `
            -Path $outputFile `
            -Encoding UTF8 `
            -Force



    Write-Host ""
    Write-Host "Saved:"
    Write-Host $outputFile `
        -ForegroundColor Green

}
else {

    Write-Host ""
    Write-Host "No reachable servers found." `
        -ForegroundColor Red

}