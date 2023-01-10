add-type @"
using System.Net;
using System.Security.Cryptography.X509Certificates;
public class TrustAllCertsPolicy : ICertificatePolicy {
public bool CheckValidationResult(
ServicePoint srvPoint, X509Certificate certificate,
WebRequest request, int certificateProblem) {
return true;
}
}
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy

$VAULT_ADDRESS = "https://server.vault.corp.ru:8200/v1/secret-frn/data"
$VAULT_TOKEN = "s.3JtmJmwqweaWEQ3432NTpYljENA"
$dbuser = "usr1cv8"
$cladmuser = "user2"

$wget1 = $(Invoke-WebRequest -Uri $VAULT_ADDRESS/users_sql_franch36db1 -Headers @{"X-Vault-Token"="$VAULT_TOKEN"})
$dbpass = $wget1.Content | C:\scripts\jq.exe -r .data.data.$dbuser
$wget2 = $(Invoke-WebRequest -Uri $VAULT_ADDRESS/user1_franch36ts1 -Headers @{"X-Vault-Token"="$VAULT_TOKEN"})
$clpass = $wget2.Content | C:\scripts\jq.exe -r .data.data.$cladmuser
$path1c = "C:\Program Files (x86)\1cv8\common\1cestart.exe"
write-host "Введите имя базы для создания на сервере разработчиков franch36db2 (напр. retail_mag0XX_pilot0X):"
$nbase = read-host
write-host "Введите описание базы (напр. Тестовая база МАГ0ХХ pilot0Х):"
$descrbase = read-host
$arg1c = "CREATEINFOBASE Srvr=""franch36db2"";Ref=""$nbase"";DBMS=""MSSQLServer"";DBSrvr=""franch36db2"";SUsr=""$cladmuser"";SPwd=""$clpass"";DB=""$nbase"";DBUID=""$dbuser"";DBPwd=""$dbpass"";SQLYOffs=""2000"";CrSQLDB=""Y"";SchJobDn=""N"";Descr=""$descrbase"";LicDstr=""Y"";Locale=""ru_RU"" /AddInList $descrbase /Out create.log"
Start-Process $path1c $arg1c
