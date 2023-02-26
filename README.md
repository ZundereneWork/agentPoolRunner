# agentPoolRunner [![Build_Push_Agent](https://github.com/ZundereneWork/agentPoolRunner/actions/workflows/agentBuild.yml/badge.svg?branch=main)](https://github.com/ZundereneWork/agentPoolRunner/actions/workflows/agentBuild.yml) [![Deploy_Agent](https://github.com/ZundereneWork/agentPoolRunner/actions/workflows/agetnHelm.yml/badge.svg?branch=main)](https://github.com/ZundereneWork/agentPoolRunner/actions/workflows/agetnHelm.yml)


## First steps
- Create the Azure Active Directory application.
  ``` bash  
  az ad app create --display-name myApp 
  ```
- Create un service principal.
  ``` bash 
   az ad sp create --id $appId
  ```
- Create a new role assignment by subscription and object.
  ``` bash 
  az role assignment create --role contributor --subscription $subscriptionId --assignee-object-id  $assigneeObjectId --assignee-principal-type ServicePrincipal --scope /subscriptions/$subscriptionId/resourceGroups/$resourceGroupName
  ```
  