<p align="center">
  <img src="https://raw.githubusercontent.com/yourusername/AD-Disaster-Recovery/main/assets/banner.gif" alt="AD Recovery Banner" width="800"/>
</p>

# 🛡️ Active Directory Disaster Recovery PowerShell Script

[![PowerShell](https://img.shields.io/badge/PowerShell-PS-blue?logo=powershell\&logoColor=white)](https://github.com/yourusername/AD-Disaster-Recovery)


---

## 📌 Overview

This **ALL-IN-ONE PowerShell script** helps IT admins recover an Active Directory environment when a Primary Domain Controller (PDC) or any Domain Controller (DC) is permanently down.

Features include:

* ⚡ **Seize FSMO roles**
* 🔄 **Convert ADC → PDC**
* 🧹 **Remove metadata of a dead DC**
* 🌐 **Clean DNS records**
* ⏱️ **Configure Time Service**
* ✅ **Run AD health checks automatically**

---

## 🔥 Features

| Feature                 | Description                                     | Status |
| ----------------------- | ----------------------------------------------- | ------ |
| Seize FSMO Roles        | Take ownership of all FSMO roles from a dead DC | ✅      |
| Convert ADC → PDC       | Promote an Additional DC to PDC Emulator role   | ✅      |
| Remove Dead DC metadata | Clean AD metadata of offline DCs                | ✅      |
| Clean DNS records       | Remove stale DNS entries related to dead DC     | ✅      |
| Configure Time Service  | Set W32Time service for proper time sync        | ✅      |
| AD Health Checks        | Automatically validate AD health post-recovery  | ✅      |

---

## 🛠️ How to Use

<details>
<summary>1️⃣ Clone or Download</summary>

Clone the repository using:
```bash
git clone https://github.com/tishan-nilusha/Active-Directory-Disaster-Recovery-PowerShell-Script
```
Or download the ZIP file and extract it.

</details>

<details>
<summary>2️⃣ Edit Script</summary>

Open `AD-Recovery.ps1` and update the dead DC hostname:

```powershell
$DeadDC = "DC01"
```

> Replace `DC01` with your actual dead DC name.

</details>

<details>
<summary>3️⃣ Enable Script Execution (One-Time)</summary>

Run this command in PowerShell:

```powershell
Set-ExecutionPolicy RemoteSigned
```

Press **Y** and Enter.

</details>

<details>
<summary>4️⃣ Run the Script</summary>

Change directory to the repository and run the script:

```powershell
cd AD-Disaster-Recovery
.\AD-Recovery.ps1
```

</details>

---

## ✅ Verification

After the script completes, check:

```powershell
netdom query fsmo
Get-ADDomainController -Filter *
```

* FSMO roles should now be owned by the new DC
* Dead DC should no longer be listed

---

