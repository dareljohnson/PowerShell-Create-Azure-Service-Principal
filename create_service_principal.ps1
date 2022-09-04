# Create Azure Service Principal
# Author: Darel Johnson
# Created: 09/01/2022

$subscriptionName = 'Developer Subscription Plan' # Replace this with your subscription
$appDisplayName = 'EventHubScaler' # This can be anything you want

$resourceGroupName = 'Devlab2-US-East' # Replace this with your resource group

Login-AzureRmAccount # You'll be prompted to login'
Select-AzureRmSubscription -SubscriptionName $subscriptionName

$sp = New-AzureRmADServicePrincipal -DisplayName $appDisplayName
New-AzureRmRoleAssignment -ServicePrincipalName $sp.AppId -RoleDefinitionName Owner -ResourceGroupName $resourceGroupName

$sp | Select DisplayName, AppId # You'll need the ApplicationId later

# While you’re connected you can use the following command to get the values you need for TenantId and SubscriptionId:
Get-AzureRmSubscription | Select-Object SubscriptionId, TenantId, SubscriptionNamels

# Get Client Secret
$sp.PasswordCredentials.SecretText

<#
	Make sure to copy & save the SubscriptionId, TenantId, and client secret from the command line. Also, copy & save
	the clientId from the Service principal (EventHubScaler) that was created under App registrations in Active Directory (AD).
	You'll need these values to update the application settings for the Function App (AutoDeflateHub).
#>

# write to file
$sp | Select DisplayName, AppId | Out-File -FilePath .\appIds.txt -Append
Get-AzureRmSubscription | Select-Object SubscriptionId, TenantId | Out-File -FilePath .\appIds.txt -Append
$sp.PasswordCredentials.SecretText | Out-File -FilePath .\appIds.txt -Append
