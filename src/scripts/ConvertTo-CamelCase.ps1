#!/usr/bin/env pwsh
# Converts a string to lower camel case

param (
    [Parameter(Mandatory)][string] $value,
    [object[]] $autoReplace = @(
        @{ replace = 'meatatwork'; with = 'meat-at-work' }
        @{ replace = 'reporthub'; with = 'report-hub' }
    )
)

$ErrorActionPreference = 'Stop'

# replace any outlier strings with sane versions
$autoReplace | ForEach-Object {
    $value = $value -replace $_.replace, $_.with
} | Out-Null

# make sure the first character is lower case
$value = $value -replace '^([A-Z])', { $_.Groups[1].Value.ToLower() }

# make sure the first character of each group is upper case
$value = $value -replace '[_\-]([a-z])', { $_.Groups[1].Value.ToUpper() }

Write-Host -NoNewline $value
