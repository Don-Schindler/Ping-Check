$Now = Get-Date -format yyyyMMdd_hhmmsstt
$CurrentPath = "C:\Users\DSchin\Desktop\PowerShell - Ping\"

$WhereIsList = $CurrentPath + "Ping_List.txt"
$ListOfServers = Get-Content -Path $WhereIsList
$CSVFile = $CurrentPath + "Ping-Report-$($Now).csv"

$Results = foreach ($ServerName in $ListOfServers) {
    $ServerName.TrimStart()
    If ($ServerName.SubString(1,1) -eq "#") {
    # Comment Line in List of Servers, ignore.
    } Else { 
        $Result = Test-Connection -ComputerName $ServerName -Quiet -Count 4
        If ($Result) {
            # Success
            $SysLine = @{
                ComputerName   = $ServerName
                Status         = 'Online'
                }
            # This will get returned out of the loop and forwarded into $Results
            New-Object -TypeName PSObject -Property $SysLine
        } Else {
            # Failure
            $SysLine = @{
                ComputerName   = $ServerName
                Status         = 'Offline'
                }
            # This will get returned out of the loop and forwarded into $Results
            New-Object -TypeName PSObject -Property $SysLine
        }
    }
}

# First, write out CSV file
$Results | select ComputerName, Status | Export-CSV -Path $CSVFile
# Now, display the results
$Results | select ComputerName, Status

