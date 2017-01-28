# Count LOC
(dir -include *.cs -recurse | select-string .).Count

# Skrypt stopujący wybrane procesy wystartowane z podkatalogów:
Get-Process WCFServer*,BreWorkplace* | Where-Object {$_.Path -like "$PSScriptRoot\*"} | Stop-Process #-WhatIf

# Wersja PS:
$PSVersionTable

# jakie DLL-ki załadowane:
[System.AppDomain]::CurrentDomain.GetAssemblies() | Where {$_.location} | ForEach { Split-Path -Leaf $_.location } | Sort

# Parsowanie logów-a (% == ForEach)
Get-Content .\20160422.BrefixRapid-r27.log | Select-String -pattern "rapid main loop (\d+)" | % {$_.Matches} | % {$_.Groups[1].Value } | % Set-Content r27.csv

# jakie własności ma obiekt - przydatne!:
New-Object Net.Webclient | Get-Member -MemberType Property

$range = 1..10
$range | Get-Member    # własności int-a!
Get-Member -InputObject $range      # własności tablicy!

# z użyciem GUI
New-Object Net.Webclient | Get-Member | Out-GridView

# Tworzenie obiektów
[PSCustomObject] @{ Name="Marcin"; Age=38 } | Format-List
New-Object PSObject -Property @{ Name="Marcin"; Age=38 } | Format-List

# Add-Memeber - dodawanie własności
$s = "Hello World" | Add-Member -PassThru ScriptProperty Reverse {$this[$this.Length..0] -join ""}

# Add-Type - dodanie typ (kompiluje kod)
Add-Type -TypeDefinition @"
public class MyMathClass {
    public int Add(int n1, int n2) {
        return n1 + n2;
    }
}
"@

# dodanie "referencji" / "using"
Add-Type -Path C:\Temp\MyMathClass.dll

# Set-Alias - aliasy np. % == ForEach, ? == Where
1..10 | ? {$_ % 2 -eq 0} | % {$_*2}
1..10 | Where {$_ % 2 -eq 0} | ForEach {$_*2}

Set-Alias vs "C:\Program Files\Microsoft Visual Studio 10.0\Common7\ide\devenv.exe"

# moduły
# ładowanie
. C:\Scripts\MyCountScript.ps1
Import-Module C:\Scripts\MyCountScript.psm1

# grep = Select-String
dir *.cs | Select-String $regex | ...

# wbudowane obsłua xml
([xml](Get-Content .\Properties.xml)).properties.property | ForEach { ... }

# long vs short form (PS v3+)
Where {$_.Name -like "My*"} == Where Name -like "My*"
