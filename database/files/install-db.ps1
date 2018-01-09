[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string[]]$DbDns,
    [Parameter(Mandatory=$true)]
    [string[]]$DbName,
    [Parameter(Mandatory=$true)]
    [string[]]$DbLoginName,
    [Parameter(Mandatory=$true)]
    [string[]]$DbPassword
)

$qualtrakSecurityPath = "$PSScriptRoot\CryptoWrapper\Qualtrak.Coach.Security.dll"
$cryptoWrapperPath = "$PSScriptRoot\CryptoWrapper\CryptoWrapper.dll"
$dacfxPath = "$PSScriptRoot\DAC\bin\Microsoft.SqlServer.Dac.dll"

If (Test-Path $dacFxPath) {
    Write-Host "DAC dll loading..."
    Add-type -Path "$dacfxPath"
} Else { Write-Error "DAC path no existing" }


Function GetDeploySQLConnectionString {
    # TODO: add credentials here
    $result = "Data Source=$($DbDns);Initial Catalog=$($DbName);Persist Security Info=True;User ID=$($DbLoginName);Password=$($DbPassword);"
    $result
 }
 
 Function RunDbDeploy($connString) {
    Write-Host "Deploying database scripts, this can take some time..." -BackgroundColor Green -ForegroundColor Black
    $dacServices = New-Object Microsoft.SqlServer.Dac.DacServices ("$connString")
    $package = [Microsoft.SqlServer.Dac.DacPackage]::Load("$PSScriptRoot\db\Evaluate.dacpac")

    Try {
        $dacServices.Deploy($package, $DbName, $true)
        Write-Host "    1st time: Database scripts deployed to db: $DbName" -BackgroundColor Yellow -ForegroundColor Black
    } Catch {
        $dacServices.Deploy($package, $DbName, $true)
        Write-Host "    2nd time: Database scripts deployed to db: $DbName" -BackgroundColor Yellow -ForegroundColor Black
    }
}

$connString = GetDeploySQLConnectionString  
RunDbDeploy $connString                    
