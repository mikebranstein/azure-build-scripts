# Overview

These scripts are used to provision an API Management demo environment. Resources provisioned include:
- resource group
- app service plan
- app service
- .NET Core Web API project deployed into app service
- API Management

## How to run

1. Open a Cloud Shell (bash)
2. Paste the following command into the Cloud Shell, then wait for it to complete

```bash
cd ~;[ -d "azure-build-scripts-master" ] && rm -rf azure-build-scripts-master;curl -LOk https://github.com/mikebranstein/azure-build-scripts/archive/master.zip; unzip master.zip; cd azure-build-scripts-master/api-management-demo; chmod +x build.sh; ./build.sh
```

## About the Web API project

A Web API project is deployed to the app service with a Swagger UI. For the full APi visit https://{app-service-url}/swagger.

## Special Notes

The API Managemnet service is bare-bones, with no APIs associated to it. A future revision of these scripts may add the APIs advertised in the app service.