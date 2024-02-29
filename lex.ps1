$SeedURL="https://www.fortypoundhead.com"

Add-Type -Path 'C:\Program Files (x86)\MySQL\Connector NET 8.0\Assemblies\v4.5.2\MySql.Data.dll'
$Connection = [MySql.Data.MySqlClient.MySqlConnection]@{ConnectionString='server=127.0.0.1;uid=lex;pwd=lex;database=lex'}
$Connection.open()
$sql = New-Object MySql.Data.MySqlClient.MySqlCommand
$sql.Connection = $Connection

$LinkList=(Invoke-webrequest -uri $SeedURL).links | select outertext,href

forEach($Link in $LinkList){
    
    $OuterText=$Link.OuterText
    $HREF=$Link.href
    $DateTime=Get-Date -uformat "%Y-%m-%d %T"

    Try {
        $sql.CommandText = "insert into main (anchortext,url) values ('$OuterText','$HREF')"
        $sql.ExecuteNonQuery() | out-null
    } Catch {
        write-host "Error sending to db $href" -foregroundcolor Red
    }
}

$Connection.Close()
