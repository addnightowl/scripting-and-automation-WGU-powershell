# Anthony Davis, student-id

#Apply exception handling using try-catch for System.OutOfMemoryException.
try {

# Create an Active Directory organizational unit (OU) named “finance.” 
New-ADOrganizationalUnit -Name Finance -ProtectedFromAccidentalDeletion $false

# Use $PSScriptRoot instead of absolute (full) path to file so that the script will work on other systems and locations.
$NewAD = Import-Csv $PSScriptRoot\financePersonnel.csv
$Path = "OU=Finance,DC=ucertify,DC=com"

# Import the financePersonnel.csv file (found in the “Requirements2” directory) into your Active Directory domain and directly into the finance OU. 
# Be sure to include the correct properties found in the .csv file. 
foreach ($ADuser in $NewAD) 
{

$First = $ADUser.First_Name
$Last = $ADUser.Last_Name
$Name = $First + " " + $Last
$SamName = $ADUser.samAccount
$Postal = $ADUser.PostalCode
$Office = $ADUser.OfficePhone
$Mobile = $ADUser.MobilePhone

# Create new AD user for each user in CSV file with the correct properties.
New-AdUser -GivenName $First -Surname $Last -Name $Name -DisplayName $Name -PostalCode $Postal -OfficePhone $Office -MobilePhone $Mobile -Path $Path

}

Write-Host -ForegroundColor Magenta "Finance AD is Complete with New Users added successfully."

# Create the Database
Import-Module -Name sqlps -DisableNameChecking -Force

# Create object for SQL connection
# Use .\UCERTIFY3
$servername = ".\UCERTIFY3"
# Create variables for .\UCERTIFY3 and ClientDB
$srv = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $servername
$databasename = "ClientDB"
$db = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Database -ArgumentList $servername,$databasename
$db.Create()

# ClientDB Created, Date, Time.
Write-Host -ForegroundColor Green $db.Name "Created" $db.CreateDate 

# Invoke SQL Command to import and create Client_A_Contacts table in ClientDB. 
Invoke-Sqlcmd -ServerInstance $servername -Database $databasename -InputFile $PSScriptRoot\Client_A_Contacts.sql

# Define Client_A_Contacts table in ClientDB.
$table = 'dbo.Client_A_Contacts'
$db = 'ClientDB'

Write-Host -ForegroundColor Yellow "Client_A_Contacts Table has been defined."

# Invoke SQL Command to Import Data into Table.
# Prepare Query 
# Insert Data from NewClientData.csv file.
Import-Csv $PSScriptRoot\NewClientData.csv | ForEach-Object {Invoke-Sqlcmd `
-Database $databasename -ServerInstance $servername -Query `
"Insert into $table (first_name, last_name, city, county, zip, officePhone, mobilePhone) VALUES `
('$($_.first_name)',' $($_.last_name)',' $($_.city)',' $($_.county)',' $($_.zip)',' $($_.officePhone)',' $($_.mobilePhone)')"

}

    }
#Apply exception handling using try-catch for System.OutOfMemoryException.
catch [System.OutOfMemoryException] {
            Write-Host -ForegroundColor Red "A system out of memory exception has occured."

}
# The following commands can be run on powershell command line or in powershell ISE.
# Get-ADUser -Filter * -SearchBase “ou=finance,dc=ucertify,dc=com” -Properties DisplayName,PostalCode,OfficePhone,MobilePhone > .\AdResults.txt 
# Invoke-Sqlcmd -Database ClientDB –ServerInstance .\UCERTIFY3 -Query ‘SELECT * FROM dbo.Client_A_Contacts’ > .\SqlResults.txt 
