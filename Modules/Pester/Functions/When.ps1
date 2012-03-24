function When($name, [ScriptBlock] $test) 
{
    $results = Get-GlobalTestResults
    $margin = " " * $results.TestDepth
    $error_margin = $margin * 2
    $results.TestCount += 1

    $output = " $margin$name"

    $start_line_position = $test.StartPosition.StartLine
    $test_file = $test.File

    Setup-TestFunction
    . $TestDrive\temp.ps1

    Start-PesterConsoleTranscript
    try{
        temp
        "[+] $output " | Write-Host -ForegroundColor green;
    } catch {
        $failure_message = $_.toString() -replace "Exception calling", "Assert failed on"
        $temp_line_number =  $_.InvocationInfo.ScriptLineNumber - 2
        $failure_line_number = $start_line_position + $temp_line_number

        $results.FailedTests += $name
        "[-] $output" | Write-Host -ForegroundColor red

        Write-Host -ForegroundColor red $error_margin$failure_message
        Write-Host -ForegroundColor red $error_margin$error_margin"at line: $failure_line_number in  $test_file"
    }

    Stop-PesterConsoleTranscript
}
