
# execute this script
# [ -d "azure-build-scripts-master" ] && rm -rf azure-build-scripts-master;curl -LOk https://github.com/mikebranstein/azure-build-scripts/archive/master.zip; unzip master.zip; cd azure-build-scripts-master/terraform-workshop; chmod +x build.sh; ./build.sh

export TF_VAR_tenant_id=$(az account list --query "[0].tenantId")
export TF_VAR_subscription_id=$(az account list --query "[0].id")

# run terraform
terraform init
terraform apply