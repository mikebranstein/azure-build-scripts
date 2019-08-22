
# execute this script
# curl -LOk https://github.com/mikebranstein/azure-build-scripts/archive/master.zip | unzip;

export TF_VAR_tenant_id=$(az account list --query "[0].tenantId")
export TF_VAR_subscription_id=$(az account list --query "[0].id")

# run terraform
terraform init
terraform apply