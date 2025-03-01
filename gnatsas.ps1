param ([string[]]$action = 'setup')

$proj = "-q -P gnatsas.gpr"

$reportsdir = Join-Path $PSScriptRoot "\verification\gnatsas\report_output"
$analysisdir = Join-Path $PSScriptRoot "\verification\gnatsas\analyze_output"

if ($action -eq "setup") {
    if (-not (Test-Path $reportsdir)) {New-Item -Path $reportsdir -Force -ItemType Directory | Out-Null}
    if (-not (Test-Path $analysisdir)) {New-Item -Path $analysisdir -Force -ItemType Directory | Out-Null}
} elseif ($action -eq "clean") {
    Get-ChildItem -Include obj -Recurse | Remove-Item -Recurse
} elseif ($action -eq "sloc") {
    Start-Process gnatmetric -ArgumentList "$($proj)" -NoNewWindow -Wait
} elseif ($action -eq "standards") {
    Start-Process gnatcheck -ArgumentList "$($proj)" -NoNewWindow -Wait
} elseif ($action -eq "desktop") {
    Start-Process gnatsas -ArgumentList "analyze --mode=fast $($proj)" -NoNewWindow -Wait
    if (Test-Path "$($analysisdir)\gnatsas.fast.sam") {
        Start-Process gnatsas -ArgumentList "report text $($proj)" -NoNewWindow -Wait
    }
} elseif ($action -eq "server") {
    Start-Process gnatsas -ArgumentList "analyze -j0 --mode=deep $($proj)" -NoNewWindow -Wait
    if (Test-Path "$($analysisdir)\gnatsas.deep.sam") {
        Start-Process gnatsas -ArgumentList "report gnathub $($proj)" -NoNewWindow -Wait
        Start-Process gnatsas -ArgumentList "report csv $($proj)" -NoNewWindow -Wait
        Start-Process gnatsas -ArgumentList "report sarif $($proj)" -NoNewWindow -Wait
        Start-Process gnatsas -ArgumentList "report security $($proj)" -NoNewWindow -Wait
    }
}
