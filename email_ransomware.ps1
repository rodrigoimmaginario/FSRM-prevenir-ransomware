
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Parâmetros recebidos da triagem de arquivos
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
$SourceIoOwner = $args[0] # Dono do arquivo
$SourceFilePath = $args[1] # Caminho do arquivo
$FileScreenPath = $args[2] # Caminho da triagem
$FileServer = $args[3] # Servidor
$ViolatedFileGroup = $args[4] # Regra que foi violada
$DateTimeIncident = Get-Date -f "dd/MM/yyyy HH:mm:ss"


#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Configuração do email
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
$Username = "<ENDERECO EMAIL>"
#$Password = ""
$SMTPServer = "<servidor SMTP>"
$SMTPPort = "25"
#$Credencial = New-Object -TypeName pscredential -ArgumentList ($Username,(ConvertTo-SecureString -String $Password -AsPlainText -Force))
$EmailCC = "email-2@email.com"
$EmailBcc = "email-1@email.com"
$Subject = "Foi detectado um arquivo nao autorizado do grupo '$ViolatedFileGroup'"
$Body = "Um arquivo nao permitido foi detectado na triagem do grupo de '$ViolatedFileGroup'. Por medida de seguranca todos os compartilhamentos de rede do usuario foram bloqueados.`n
Usuario: $SourceIoOwner`nArquivo: $SourceFilePath em $FileScreenPath`nServidor: $FileServer`nData: $DateTimeIncident`n`n`nContate o setor de TI imediatamente!"


#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Envia o email
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
$Message = New-Object System.Net.Mail.MailMessage
$Message.Subject = $Subject
$Message.Body = $Body
$Message.IsBodyHtml = $false
$Message.To.Add( $EmailBcc)
$Message.CC.Add($EmailCC)
#$Message.BCC.Add($EmailBcc)
$Message.From = $Username.Replace("=", "@") # For providers that use = instead @ to identify username
$SMTP = New-Object System.Net.Mail.SmtpClient($SMTPServer, $SMTPPort);
$SMTP.EnableSSL = $false # gmail needs $true
#$SMTP.Credentials = New-Object System.Net.NetworkCredential($Username, $Password);
$SMTP.Send($Message)


#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Bloqueia o acesso de todos compartilhamentos do usuário
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Get-SmbShare -Special $false | ForEach-Object { Block-SmbShareAccess -Name $_.Name -AccountName $SourceIoOwner -Force}

