# Naming and tagging standard

Applies to every Azure resource, on-premises server and Active Directory object in the Ridgeline environment. Based on Microsoft's Cloud Adoption Framework abbreviations, trimmed to what Ridgeline uses.

## Azure resource names

**Pattern:** `<type>-<workload>-<env>-<region>-<nnn>`

| Part | Values |
| --- | --- |
| `type` | CAF abbreviation from the table below |
| `workload` | `hub`, `spk` (spoke network), `idn` (identity), `gov` (governance), `mgmt` (monitoring, automation, backup), `files`, `app` (line-of-business app), `web` (App Service front end), `ctr` (containers) |
| `env` | `prd`, `tst`, `dev` (the lab plays Ridgeline's production, so most things are `prd`) |
| `region` | `cac` (Canada Central), `cae` (Canada East) |
| `nnn` | `001`, `002`… only where more than one can exist |

Lowercase only. Hyphens only. No company prefix on Azure resources: the subscription already says whose they are.

| Resource | Abbreviation | Example |
| --- | --- | --- |
| Resource group | `rg` | `rg-hub-prd-cac` |
| Virtual network | `vnet` | `vnet-hub-prd-cac` |
| Subnet | `snet` | `snet-mgmt-prd-cac` (gateway subnet must be `GatewaySubnet`) |
| Network security group | `nsg` | `nsg-snet-app-prd-cac` |
| VPN gateway | `vpng` | `vpng-hub-prd-cac` |
| Local network gateway | `lgw` | `lgw-headoffice-prd-cac` |
| VPN connection | `con` | `con-hub-to-headoffice` |
| Public IP | `pip` | `pip-vpng-hub-prd-cac` |
| Key Vault | `kv` | `kv-idn-prd-cac-7f3a` (24 characters max, globally unique, so a 4-character random suffix) |
| Storage account | `st` | `stfilesprdcac001` (3–24 lowercase letters and digits, no hyphens, globally unique) |
| Log Analytics workspace | `log` | `log-mgmt-prd-cac` |
| Automation account | `aa` | `aa-mgmt-prd-cac` |
| Recovery Services vault | `rsv` | `rsv-mgmt-prd-cac` |
| Virtual machine | `vm` | `vm-rdg-az-app01` (resource name; the computer name follows the server rule below) |
| Managed disk | `disk` | `disk-rdg-az-app01-os` |
| Budget | `budget` | `budget-ridgeline-monthly` (subscription scope, no region) |
| Policy assignment | `pa` | `pa-require-tags` |
| Management group | `mg` | `mg-ridgeline`, `mg-ridgeline-lab` (no region) |
| Private endpoint | `pep` | `pep-stfilesprdcac001-file` (target resource plus sub-resource) |
| Virtual machine scale set | `vmss` | `vmss-web-prd-cac` |
| Load balancer | `lbe` (external), `lbi` (internal) | `lbe-web-prd-cac` |
| App Service plan | `asp` | `asp-web-prd-cac` |
| Web app | `app` | `app-web-prd-cac-7f3a` (globally unique, so a 4-character random suffix) |
| Container registry | `cr` | `crctrprdcac7f3a` (5–50 letters and digits, no hyphens, globally unique) |
| Container instance | `ci` | `ci-ctr-prd-cac` |
| Action group | `ag` | `ag-mgmt-ops-email` |

## Server names (on-premises and Azure)

**Pattern:** `RDG-<site>-<role><nn>`, uppercase, 15 characters max (the NetBIOS limit).

| Site | Code |
| --- | --- |
| Head office | `HO` |
| Field yard 1 / 2 | `Y1` / `Y2` |
| Azure | `AZ` |

| Role | Code |
| --- | --- |
| Domain controller | `DC` |
| File server | `FS` |
| App / SQL server | `APP` |
| Hyper-V host | `HV` |

Examples: `RDG-HO-DC01` (the 2016 domain controller), `RDG-HO-FS01`, `RDG-HO-APP01`, `RDG-AZ-APP01` (the app server after it moves to Azure in phase 5), `RDG-HO-HV01` (the Hyper-V host on your PC). Numbers are never reused, so a replacement server gets the next number. The side track's in-place upgrade keeps `RDG-HO-FS01`, because the server itself doesn't change.

The Azure VM resource name is `vm-` plus the lowercase computer name, so the two always match up.

## Active Directory names

| Object | Pattern | Example |
| --- | --- | --- |
| Admin account | `adm-t<tier>-<user>` | `adm-t0-zmonaghan` (created in the sysadmin side track) |
| Emergency access account (cloud-only, Entra) | `bg-ea<nn>` | `bg-ea01` |
| Security group | `GRP-<scope>-<purpose>` | `GRP-FS-Finance-Modify` |
| Admin group | `GRP-T<tier>-<purpose>` | `GRP-T0-DomainAdmins` |
| GPO | `<scope>-<C\|U>-<purpose>` | `SRV-C-SecurityBaseline` (C = computer settings, U = user settings) |

Phase 1 deliberately has no OU design, because it's the "before" picture. The OU tree is designed in the sysadmin side track (phase 8).

## Tags

Every resource group gets all required tags. Resources inherit them from their resource group (enforced by Azure Policy in phase 2).

| Tag | Required | Values | Why |
| --- | --- | --- | --- |
| `workload` | Yes | `ridgeline` | Separates the lab from anything else in the subscription |
| `environment` | Yes | `prd`, `tst`, `dev` | Matches the name |
| `owner` | Yes | an email address | Who to ask before deleting it |
| `costCenter` | Yes | `IT-Infra` | Finance chargeback in the scenario |
| `phase` | Yes | `0` to `8` (8 is the sysadmin side track) | Cost Management can group spend by phase |
| `managedBy` | Yes | `bicep`, `portal`, `arc` | Anything marked `portal` is drift to bring into code |
| `expiresOn` | Only for temporary resources | `yyyy-mm-dd` | Flags things like the VPN gateway that should be deleted |

Tag names are camelCase. Tag values are lowercase except emails.

**One resource group per phase.** Each phase deploys into its own resource groups (for example `rg-spk-prd-cac` in phase 3), and they're deleted at the end of every session. The Bicep pipeline brings them back in one run. Only long-lived things such as the budget, management groups and policy assignments sit outside them.

## Exceptions

Where Azure forces a name (`GatewaySubnet`, `AzureBastionSubnet`) or a resource doesn't support tags (budgets, policy assignments), Azure's rule wins. Any other exception is written here with the reason.
