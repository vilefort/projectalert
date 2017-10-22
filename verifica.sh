#!/bin/sh
PATH=/usr/local/bin:/usr/local/sbin:~/bin:/usr/bin:/bin:/usr/sbin:/sbin

#Verificação Script diferencial
# Alex Vilefort  Twiter @p1Alex
# @Dicom Soluções
#VARIAVEIS
#INICIO=`DATE: "+DATE: %m/%d/%y%n Hora: %H:%M:%S"`
INICIO=`date`
LOG=/Users/dicom/dicom/logs/verifica.log

#DEFINA AQUI O DIRETORIO do ICloud onde vai os logs e arquivos pasrtilhados
CLOUD=/Users/dicom/Library/Mobile\ Documents/com~apple~CloudDocs/dicom1609/

#Processos
MEMORIA=`top -l 1 | awk '/Horos/ {print $8 }'`
HTTP=`curl -sL -w "%{http_code}\\n" "localhost:3333" -o /dev/null`

#CRIA O ARQUIVO DE LOGS
echo " " >> $LOG
echo " " >> $LOG
echo "|-----------------------------------------------" >> $LOG
echo " Checagem em  $INICIO" >> $LOG
echo " Memoria usada :  $MEMORIA" >> $LOG
echo " Teste do Webserver :  $HTTP" >> $LOG


PROCESSO="/Applications/Horos.app/Contents/MacOS/Horos";
OCORRENCIAS=`ps wax | grep $PROCESSO | grep -v grep| wc -l`
STATHOROS="HON"
if [ $OCORRENCIAS -eq 0 ]
then
STATHOROS="HOFF"
su - dicom -c "nohup /Applications/Horos.app/Contents/MacOS/Horos >> /Users/dicom/dicom/logs/horos2.log"
echo "$STATHOROS" >> $LOG
fi

sleep 3
PROCESSO="/Applications/TeamViewerHost.app/Contents/MacOS/TeamViewerHost";
OCORRENCIAS=`ps wax | grep $PROCESSO | grep -v grep| wc -l`
STATTV="TON"
if [ $OCORRENCIAS -eq 0 ]
then
STATTV="TOFF"
nohup /Applications/TeamViewerHost.app/Contents/MacOS/TeamViewerHost >> /dev/null &
echo "$STATTV" >> $LOG
fi

PROCESSO="noip2";
OCORRENCIAS=`ps wax | grep $PROCESSO | grep -v grep| wc -l`
if [ $OCORRENCIAS -eq 0 ]
then
#nohup /usr/local/bin/noip2 >> /dev/null &
echo "Noip nao estava executando" >> $LOG
fi

echo "1;Dicom-Teste ;$INICIO ;$MEMORIA ;$HTTP ;$STATHOROS" > /Users/dicom/dicom/logs/alerta.csv
chmod 777 /Users/dicom/dicom/logs/alerta.csv
sleep 1
scp /Users/dicom/dicom/logs/alerta.csv alert@192.168.15.151:/home/dicom/alerta/
