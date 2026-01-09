# =========================================================
# ALL-IN-ONE AD DISASTER RECOVERY SCRIPT
# FSMO Seize + Metadata Cleanup + Time Sync + Health Check
# Run on Healthy ADC (New PDC)
# =========================================================

Import-Module ActiveDirectory

# ===== VARIABLES (CHANGE THIS) =====
$DeadDC = "Server1.headoffice.local"                 # OLD / DEAD DC NAME
$NewPDC = $env:COMPUTERNAME      # CURRENT ADC / NEW PDC
$Domain = (Get-ADDomain).DNSRoot
$ConfigDN = (Get-ADRootDSE).configurationNamingContext

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host " AD DISASTER RECOVERY STARTED " -ForegroundColor Cyan
Write-Host " New PDC : $NewPDC"
Write-Host " Dead DC : $DeadDC"
Write-Host "=========================================" -ForegroundColor Cyan

# =========================================================
# STEP 1: CHECK CURRENT FSMO ROLES
# =========================================================
Write-Host "`n[STEP 1] Current FSMO Roles" -ForegroundColor Yellow
netdom query fsmo

# =========================================================
# STEP 2: SEIZE ALL FSMO ROLES
# =========================================================
Write-Host "`n[STEP 2] Seizing ALL FSMO Roles to $NewPDC" -ForegroundColor Red

Move-ADDirectoryServerOperationMasterRole `
-Identity $NewPDC `
-OperationMasterRole SchemaMaster,DomainNamingMaster,PDCEmulator,RIDMaster,InfrastructureMaster `
-Force -Confirm:$false

# =========================================================
# STEP 3: VERIFY FSMO ROLES
# =========================================================
Write-Host "`n[STEP 3] FSMO Roles After Seize" -ForegroundColor Green
netdom query fsmo

# =========================================================
# STEP 4: CONFIGURE TIME SERVICE (PDC EMULATOR)
# =========================================================
Write-Host "`n[STEP 4] Configuring Time Service" -ForegroundColor Cyan

w32tm /config /manualpeerlist:"time.windows.com,0x8" /syncfromflags:manual /reliable:yes /update
Restart-Service w32time
w32tm /resync /force

# =========================================================
# STEP 5: METADATA CLEANUP - COMPUTER OBJECT
# =========================================================
Write-Host "`n[STEP 5] Removing Dead DC Computer Object" -ForegroundColor Yellow
Remove-ADComputer $DeadDC -Confirm:$false -ErrorAction SilentlyContinue

# =========================================================
# STEP 6: REMOVE NTDS SETTINGS
# =========================================================
Write-Host "`n[STEP 6] Removing NTDS Settings Object" -ForegroundColor Yellow

Get-ADObject -Filter 'objectClass -eq "nTDSDSA"' -SearchBase $ConfigDN |
Where-Object { $_.DistinguishedName -match $DeadDC } |
ForEach-Object {
    Remove-ADObject $_ -Recursive -Confirm:$false
}

# =========================================================
# STEP 7: REMOVE SERVER OBJECT
# =========================================================
Write-Host "`n[STEP 7] Removing Server Object" -ForegroundColor Yellow

Get-ADObject -Filter 'objectClass -eq "server"' -SearchBase $ConfigDN |
Where-Object { $_.Name -eq $DeadDC } |
ForEach-Object {
    Remove-ADObject $_ -Recursive -Confirm:$false
}

# =========================================================
# STEP 8: CLEAN DNS RECORDS
# =========================================================
Write-Host "`n[STEP 8] Cleaning DNS Records" -ForegroundColor Yellow

Get-DnsServerResourceRecord -ZoneName $Domain |
Where-Object { $_.RecordData -match $DeadDC } |
Remove-DnsServerResourceRecord -ZoneName $Domain -Force

# =========================================================
# STEP 9: VERIFY DC LIST
# =========================================================
Write-Host "`n[STEP 9] Verifying Active Domain Controllers" -ForegroundColor Green
Get-ADDomainController -Filter *

# =========================================================
# STEP 10: HEALTH CHECKS
# =========================================================
Write-Host "`n[STEP 10] Running Health Checks" -ForegroundColor Cyan
dcdiag /e
repadmin /replsummary

Write-Host "`n=========================================" -ForegroundColor Green
Write-Host " AD DISASTER RECOVERY COMPLETED SUCCESSFULLY " -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
