# AamMeshPS
This is test used as part of the application process for Infrastructure Engineers at AAM. The challenge is to fix this partially completed PowerShell module so that all Pester tests pass, you will find various syntax issues and tests missing their code implementation.

## Pester Tests
Pester tests are created and placed in the test folder. Running the command below from the root of the AamMeshPS repo will run all of the Pester tests in the Test repo.

```
Invoke-PSake .\build.psake.ps1 -taskList Test
```

[Pester](https://github.com/pester/Pester/wiki) is written in PowerShell and uses a Behaviour Driven Development (BDD) syntax that should be familiar to those experienced within other languages too.

## Background
**Node:** A server or virtual machine
**Node name:** The hostname of the node. Two formats are supported old (e.g. UK2-D-ADM005) or new (e.g. UK1DEVGENAPP222)
**Region identifier:** Regions include EMEA (Europe), APAC (Asia-Pacific), AMRS (Americas). The region specifies where in the world the node is deployed.
**Environment identifier:** Environments include DEV (Development), UAT (User-Acceptance Test) and more. The environment specifies how and when the node is managed, patched and deployed to across the estate.


## Test


**Bonus points** for forking the repo and submitting a PR


