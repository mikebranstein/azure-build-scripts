# Overview

I conduct a lot of Azure workshops, and I'm always struggling with:
- getting attendees started fast
- not requiring them to have pre-reqs installed on their laptops (b/c this never goes well)

I've tried several approaches, such as:
- using stock Azure Visual Studio Community edition VM images
- one-click deployments to Azure using ARM templates
- having attendees build a VM from a pre-installed VHD

But, all of these seem to create hiccups (some Azure Pass subscriptions don't have access to the VS Community edition images, the ARM template deployments created confusion for attendees, and the pre-installed VHD path took WAY too long).

So, here's the approach I believe will work:
1. Create an Azure Trial subscription (or an Azure Pass) with a personal Microsoft Account*
2. Open the Cloud Shell
3. Paste a brief script into the Cloud Shell that:
    - downloads and self-executes a Terraform process to provision resources (and a stock Windows Server VM)- run a series of Chocolatey install scripts 

## Why an Azure Subscription on a Personal Microsoft Account?

I've found that attendees using their corporate accounts are often locked out of creating resources (like VMs). 

## Why a stock Windows Server VM?

Some Azure Passes don't give attendees access to Visual Studio Comminity edition VM images (i found this out the hard way). 

## Why Cloud Shell?

Cloud Shell is powerful, easy to start using, and has various tools (like Terraform) already installed.

## Why Terraform?

Because I like it and I'm more comfortable using it rather than Azure Resource Manager templates.

## Why Chocolatey?

Because it works and is easy to install common packages with it on Windows. 

# How this repo is structured

Each workshop I run will have a sub-folder in the repo. They each contain 3 files:
1. build.sh: the main script that kicks off the Terraform provisioning process
2. main.tf: the Terraform file with the infrastructure I need for the workshop 
3. Install-Prereqs.ps1: a PowerShell script to install chocolatey and then other pre-req software 

At the top of the build.sh will is a brief script. To trigger the process, have attendees open the Cloud Shell (bash), paste the script into Cloud Shell, press *Enter*, then wait.