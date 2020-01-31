
# Create-Teachers-ADGroup Powershell file take 3 input parameter from admin and create new ADgroup. Also it add's all the members in the Azure AD security group. 
# Groupname groupnickname and AccountSkuId parameters
param([string] $GroupName,
[string] $GroupNickName, [string] $AccountSkuId)

# Script which install azureAD, connect it and create a new Azure AD group.

Install-Module AzureAD
Connect-AzureAD
$newGroup = New-AzureADGroup -DisplayName $GroupName -MailEnabled 0 -MailNickName $GroupNickName -SecurityEnabled 1

# Script add all the teachers from Azure AD users to the new Azure AD group.
Install-Module MSOnline
Connect-MsolService
$faculties = Get-MsolUser -all | Where-Object {($_.licenses).AccountSkuId -match $AccountSkuId} | select ObjectId
foreach ($faculty in $faculties){
    Add-AzureADGroupMember -ObjectId $newGroup.ObjectId -RefObjectId $faculty.ObjectId
}