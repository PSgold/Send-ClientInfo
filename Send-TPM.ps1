<#
These are the data saved to the buffer and passed to the server:
TpmPresent - 25
[bool]$TpmPresent - 1
TpmReady - 25 
[bool]$TpmReady - 1
TPMEnabled - 25
[int16]$TpmEnabled - 2
TPMActivated - 25
[int16]$TpmActivated - 2


[string]$companyName - 25 bytes
host - 25
[string]$host - 25 bytes
manufacturer - 25
[string]$manufacturer - 25 bytes
model - 25
[string]$model - 25 bytes
serial - 25
[string]$serial - 25 bytes

Relevant Columns in database:
Host,Text
TpmPresent,Int
TpmReady,Int
TpmEnabled,Int
TpmActivated,Int
Manufacturer, Text
Model,Text
serial,Text

#>

function Pad-String {
    param (
        [Parameter(Mandatory=$true)][string]$str,
        [Parameter(Mandatory=$true)][int]$charSize
    )
    [int]$padding = $charSize - $str.Length
    for([int]$p=0;$p -lt $padding;$p++){
        $str+="`0"
    }
    return $str
}

[byte[]]$buffer = @(
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
    0x00,
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
    0x00,0x00,
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
    0x00,0x00,
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
    0x00,0x00,
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
    0x00,0x00,
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
    0x00,
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
    0x00,
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
    0x00,
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
)
$tpmInfo = Get-Tpm
$encoding = [System.Text.ASCIIEncoding]::new()
[int]$buffIndex = 0

#company name - 25 bytes
[string]$companyName = "Tango"
$companyName = Pad-String -str $companyName -charSize 25
[byte[]]$companyNameByte = $encoding.GetBytes($companyName)
for([int]$p=0;$p -lt 25;$p++){
    $buffer[$buffIndex] = $companyNameByte[$p]
    $buffIndex++
}

#host name - 51
[string]$columnName = "Host"
$columnName = Pad-String -str $columnName -charSize 25
[byte[]]$columnNameByte = $encoding.GetBytes($columnName)
for([int]$p=0;$p -lt 25;$p++){
    $buffer[$buffIndex] = $columnNameByte[$p]
    $buffIndex++
}
$buffer[$buffIndex] = 3;$buffIndex++
[string]$hostName = $env:COMPUTERNAME
$hostName = Pad-String -str $hostName -charSize 25
[byte[]]$hostNameByte = $encoding.GetBytes($hostName)
for([int]$p=0;$p -lt 25;$p++){
    $buffer[$buffIndex] = $hostNameByte[$p]
    $buffIndex++
}

#TPM Present - 27
$columnName = "TpmPresent"
$columnName = Pad-String -str $columnName -charSize 25
$columnNameByte = $encoding.GetBytes($columnName)
for([int]$p=0;$p -lt 25;$p++){
    $buffer[$buffIndex] = $columnNameByte[$p]
    $buffIndex++
}
$buffer[$buffIndex] = 1;$buffIndex++
if($tpmInfo.TpmPresent){$buffer[$buffIndex] = 1}
else{$buffer[$buffIndex] = 0}
$buffIndex++

#TPM Ready - 27
$columnName = "TpmReady"
$columnName = Pad-String -str $columnName -charSize 25
$columnNameByte = $encoding.GetBytes($columnName)
for([int]$p=0;$p -lt 25;$p++){
    $buffer[$buffIndex] = $columnNameByte[$p]
    $buffIndex++
}
$buffer[$buffIndex] = 1;$buffIndex++
if($tpmInfo.$TpmReady){$buffer[$buffIndex] = 1}
else{$buffer[$buffIndex] = 0}
$buffIndex++

#TPM Enabled - 27
$columnName = "TpmEnabled"
$columnName = Pad-String -str $columnName -charSize 25
$columnNameByte = $encoding.GetBytes($columnName)
for([int]$p=0;$p -lt 25;$p++){
    $buffer[$buffIndex] = $columnNameByte[$p]
    $buffIndex++
}
$buffer[$buffIndex] = 2;$buffIndex++
$tpmEnabledMem = Get-Member -Name "TpmEnabled" -InputObject $tpmInfo
if($tpmEnabledMem -eq $null){$buffer[$buffIndex] = 2}
else {
    if($tpmInfo.TpmEnabled){$buffer[$buffIndex] = 1}
    else{$buffer[$buffIndex] = 0}
}
$buffIndex++

#TPM Activated - 27
$columnName = "TpmActivated"
$columnName = Pad-String -str $columnName -charSize 25
$columnNameByte = $encoding.GetBytes($columnName)
for([int]$p=0;$p -lt 25;$p++){
    $buffer[$buffIndex] = $columnNameByte[$p]
    $buffIndex++
}
$buffer[$buffIndex] = 2;$buffIndex++
$tpmActivatedMem = Get-Member -Name "TpmActivated" -InputObject $tpmInfo
if($tpmActivatedMem -eq $null){$buffer[$buffIndex] = 2}
else {
    if($tpmInfo.TpmActivated){$buffer[$buffIndex] = 1}
    else{$buffer[$buffIndex] = 0}
}
$buffIndex++


#Manufacturer - 51
$system = Get-CimInstance -ClassName Win32_ComputerSystem
$columnName = "Manufacturer"
$columnName = Pad-String -str $columnName -charSize 25
$columnNameByte = $encoding.GetBytes($columnName)
for([int]$p=0;$p -lt 25;$p++){
    $buffer[$buffIndex] = $columnNameByte[$p]
    $buffIndex++
}
$buffer[$buffIndex] = 3;$buffIndex++
[string]$manufacturer = $system.Manufacturer
$manufacturer = Pad-String -str $manufacturer -charSize 25
[byte[]]$manufacturerByte = $encoding.GetBytes($manufacturer)
for([int]$p=0;$p -lt 25;$p++){
    $buffer[$buffIndex] = $manufacturerByte[$p]
    $buffIndex++
}

#Model - 51
$columnName = "Model"
$columnName = Pad-String -str $columnName -charSize 25
$columnNameByte = $encoding.GetBytes($columnName)
for([int]$p=0;$p -lt 25;$p++){
    $buffer[$buffIndex] = $columnNameByte[$p]
    $buffIndex++
}
$buffer[$buffIndex] = 3; $buffIndex++
[string]$model = $system.Model
$model = Pad-String -str $model -charSize 25
[byte[]]$modelByte = $encoding.GetBytes($model)
for([int]$p=0;$p -lt 25;$p++){
    $buffer[$buffIndex] = $modelByte[$p]
    $buffIndex++
}

#serial - 51
$columnName = "Serial"
$columnName = Pad-String -str $columnName -charSize 25
$columnNameByte = $encoding.GetBytes($columnName)
for([int]$p=0;$p -lt 25;$p++){
    $buffer[$buffIndex] = $columnNameByte[$p]
    $buffIndex++
}
$buffer[$buffIndex] = 3; $buffIndex++
[string]$serial = (Get-CimInstance -ClassName Win32_BIOS).SerialNumber
$serial = Pad-String -str $serial -charSize 25
[byte[]]$serialByte = $encoding.GetBytes($serial)
for([int]$p=0;$p -lt 25;$p++){
    $buffer[$buffIndex] = $serialByte[$p]
    $buffIndex++
}


$tcpClient = [System.Net.Sockets.TcpClient]::new("192.168.12.5",62211)
$tcpClientStream = $tcpClient.GetStream()
$tcpClientStream.Write($buffer,0,$buffer.Length)
$tcpClientStream.Flush()
$tcpClientStream.Close()
$tcpClient.Close()