# Para criar o grupo de arquivos (executar somente na primeira vez)
new-FsrmFileGroup -name "ArquivosRansomware" -IncludePattern @((Invoke-WebRequest -Uri "https://github.com/rodrigoimmaginario/FSRM-prevenir-ransomware/blob/main/metadados.txt").content | convertfrom-json | % {$_.filters})
