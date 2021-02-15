# How to execute this script
#
# 1. Ask attendees to open a Cloud Shell (bash)
# 2. Have them paste the following command into the Cloud Shell, then wait for it to complete
# 
# [ -d "azure-build-scripts-master" ] && rm -rf azure-build-scripts-master;curl -LOk https://github.com/mikebranstein/azure-build-scripts/archive/master.zip; unzip master.zip; cd azure-build-scripts-master/terraform-workshop; chmod +x build.sh; ./build.sh

export TF_VAR_tenant_id=$(az account list --query "[?isDefault].tenantId" -otsv) 
export TF_VAR_subscription_id=$(az account list --query "[?isDefault].id" -otsv) 
echo "Tenant Id: $TF_VAR_tenant_id"
echo "Subscription Id: $TF_VAR_subscription_id"

# run terraform
terraform init
terraform apply --auto-approve
