# Ridgeline Hybrid Infrastructure

Infrastructure as code for Ridgeline Field Services, a fictional 250-person Calgary oilfield services company moving from a Windows Server 2016 server room to a hybrid Azure environment before Windows Server 2016 end of support on **January 12, 2027**.

It's a hands-on Azure build covering all five AZ-104 exam areas: identity and governance, networking, storage, compute, and monitoring and backup.

Everything on the Azure side is deployed from this repo. `main` is protected: changes land only through pull requests.

## Layout

| Folder | What's in it |
| --- | --- |
| `infra/` | Bicep templates, one folder per component |
| `docs/standards/` | Naming and tagging standard |
| `.github/rulesets/` | The branch protection rule for `main`, kept as code |

## Status

| Phase | State |
| --- | --- |
| 0. Lab foundation | In progress |
| 1. Old server room | Not started |
| 2. Identity and governance | Not started |
| 3. Virtual networking | Not started |
| 4. Storage | Not started |
| 5. Compute | Not started |
| 6. Monitor, back up and manage on-premises | Not started |
| 7. Drills, design records and exam prep | Not started |
| Sysadmin side track (optional) | Not started |
