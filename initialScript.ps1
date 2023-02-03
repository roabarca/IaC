$templateFileName = 'azuredeploy.json'
$templateFileParametersName = 'azuredeploy.parameters.json'
$env = 'test'
$project = 'tproj'
$client = 'tclient'

# Provide the name of the closest Azure region in which you can provision Azure VMs
# $location = Read-Host -Prompt 'Enter the name of Azure region (i.e. centralus)'
$location = 'eastus'

# This is a random string used to assign the name to the Azure storage account
#$suffix = Get-Random
# $resourceGroupName = Read-Host -Prompt 'Enter the name of the resource group (i.e. azrgdemo)'
$resourceGroupName = 'azrgscriptdemo'

# Create the resource group
az group create --location $location --resource-group $resourceGroupName

# Deploy the initial resources to resource group
$deployName = 'az400m13l01deployment'
az deployment group create --name $deployName --resource-group $resourceGroupName --template-file ./Initial/$templateFileName --parameters ./Initial/$templateFileParametersName --parameters env=$env project=$project client=$client

$adfName = (Get-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -Name $deployName).Outputs.dataFactoryName.value

# Obtener ObjectID
$adfObjectID = (Get-AzDataFactoryV2 -ResourceGroupName $resourceGroupName -Name $adfName).Identity.PrincipalId

# Deploy the key vault
az deployment group create --name $deployName --resource-group $resourceGroupName --template-file ./key-vault-create/$templateFileName --parameters ./key-vault-create/$templateFileParametersName --parameters objectId=$adfObjectID env=$env project=$project client=$client

