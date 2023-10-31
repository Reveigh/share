cls
netdom query fsmo

$targetSchemaMaster = Read-Host "Enter the name of the new Schema Master (NetBIOS name, not FQDN)"
$targetDomainNamingMaster = Read-Host "Enter the name of the new Domain Naming Master (NetBIOS name, not FQDN)"
$targetPDCEmulator = Read-Host "Enter the name of the new PDC Emulator (NetBIOS name, not FQDN)"
$targetRIDMaster = Read-Host "Enter the name of the new RID Master (NetBIOS name, not FQDN)"
$targetInfrastructureMaster = Read-Host "Enter the name of the new Infrastructure Master (NetBIOS name, not FQDN)"

Move-ADDirectoryServerOperationMasterRole -Identity $targetSchemaMaster -OperationMasterRole SchemaMaster -Force
Move-ADDirectoryServerOperationMasterRole -Identity $targetDomainNamingMaster -OperationMasterRole DomainNamingMaster -Force
Move-ADDirectoryServerOperationMasterRole -Identity $targetPDCEmulator -OperationMasterRole PDCEmulator -Force
Move-ADDirectoryServerOperationMasterRole -Identity $targetRIDMaster -OperationMasterRole RIDMaster -Force
Move-ADDirectoryServerOperationMasterRole -Identity $targetInfrastructureMaster -OperationMasterRole InfrastructureMaster -Force

netdom query fsmo