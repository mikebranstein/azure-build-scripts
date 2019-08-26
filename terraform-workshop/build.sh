# How to execute this script
#
# 1. Ask attendees to open a Cloud Shell (bash)
# 2. Have them paste the following command into the Cloud Shell, then wait for it to complete
# 
# bash <(curl -LOks https://raw.githubusercontent.com/mikebranstein/azure-build-scripts/master/terraform-workshop/build.sh)

# clean up environment before running
[ -d "azure-build-scripts-master" ] && rm -rf azure-build-scripts-master

# grab all scripts and unzip
curl -LOk https://github.com/mikebranstein/azure-build-scripts/archive/master.zip
unzip master.zip
cd azure-build-scripts-master/terraform-workshop

# get tenant and subscription
export TF_VAR_tenant_id=$(az account list --query "[0].tenantId" -otsv) 
export TF_VAR_subscription_id=$(az account list --query "[0].id" -otsv) 

# run terraform
terraform init
terraform apply --auto-approve
