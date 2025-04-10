param (
    [string[]]$ports
)

if($null -eq $ports){
    Write-Output "Needs to specify at least one port."
    Write-Output "Example:"
    Write-Output "      kports 8080 4840"
    
} else {
    foreach($port in $ports){
        $portstr = '0:' + $port + ' '
        $_pid = netstat -ano | Select-String $portstr | ForEach-Object {($_ -split "\s+")[5]}
    
        if($null -eq $_pid){
            Write-Output ("There are no processes using port $port")
        } else {
            foreach($process in $_pid){
                try {
                    taskkill /PID $_pid /F
                    Write-Output ("Port " + $port + ": freed ")
                }
                catch {
                    Write-Output ("kports wasn't able to kill task $_pid in port $port. Try executing as administrator")
                }   
            }
        }
    }
}