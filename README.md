# Active-Directory-Disaster-Recovery-PowerShell-Script

🛡️ Active Directory Disaster Recovery PowerShell Script

FSMO Seize + PDC Recovery + Metadata Cleanup (All-in-One)

📌 Overview

This repository contains an ALL-IN-ONE PowerShell script to recover an Active Directory environment when a Primary Domain Controller (PDC) or any Domain Controller is permanently down.

The script allows you to:

Seize FSMO roles

Convert ADC → PDC

Remove metadata of a dead DC

Clean DNS records

Configure Time Service

Perform AD health checks

🔥 Features

Seize ALL FSMO Roles

Convert ADC to PDC Emulator

Remove Dead DC metadata

Clean DNS records

Configure Time Service (W32Time)

Run AD Health Checks automatically


🛠️ How to Use
1️⃣ Clone or Download
git clone https://github.com/yourusername/AD-Disaster-Recovery.git


Or download the ZIP file and extract.

2️⃣ Edit Script

Open AD-Recovery.ps1 and update the dead DC hostname:

$DeadDC = "DC01"


Replace DC01 with your actual dead DC name.

3️⃣ Enable Script Execution (One-Time)
Set-ExecutionPolicy RemoteSigned


Press Y and Enter.

4️⃣ Run the Script
cd AD-Disaster-Recovery
.\AD-Recovery.ps1

✅ Verification

After the script completes, verify:

netdom query fsmo

Get-ADDomainController -Filter *


FSMO roles should now be owned by the new DC

Dead DC should no longer be listed
