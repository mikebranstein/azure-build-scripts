# How to execute this script
#
# 1. Open a Cloud Shell (bash)
# 2. Paste the following command into the Cloud Shell, then wait for it to complete
# 
# cd ~;[ -d "azure-build-scripts-master" ] && rm -rf azure-build-scripts-master;curl -LOk https://github.com/mikebranstein/azure-build-scripts/archive/master.zip; unzip master.zip; cd azure-build-scripts-master/api-management-demo; chmod +x build.sh; ./build.sh

export TF_VAR_tenant_id=$(az account list --query "[0].tenantId" -otsv) 
export TF_VAR_subscription_id=$(az account list --query "[0].id" -otsv) 

# set the default subscription
az account set --subscription $TF_VAR_subscription_id

# zip up netcore app code
cd src/ApiDemo
zip -r app.zip .
mv app.zip ../../app.zip
cd ../../

# run terraform
terraform init
terraform apply --auto-approve