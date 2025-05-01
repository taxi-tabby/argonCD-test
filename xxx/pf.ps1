# 포트 포워딩을 백그라운드에서 실행
$process_id1 = Start-Process kubectl -ArgumentList "port-forward", "-n", "default-vitess", "--address", "localhost", (kubectl get service -n default-vitess --selector='planetscale.com/component=vtctld' -o name | Select-Object -First 1), "15000", "15999" -PassThru
$process_id2 = Start-Process kubectl -ArgumentList "port-forward", "-n", "default-vitess", "--address", "localhost", (kubectl get service -n default-vitess --selector='planetscale.com/component=vtgate,!planetscale.com/cell' -o name | Select-Object -First 1), "15306:3306" -PassThru
$process_id3 = Start-Process kubectl -ArgumentList "port-forward", "-n", "default-vitess", "--address", "localhost", (kubectl get service -n default-vitess --selector='planetscale.com/component=vtadmin' -o name | Select-Object -First 1), "14000:15000", "14001:15001" -PassThru

# 약간의 대기
Start-Sleep -Seconds 2

# 사용자에게 알림
Write-Host "You may point your browser to http://localhost:15000, use the following aliases as shortcuts:"
Write-Host 'alias vtctldclient="vtctldclient --server=localhost:15999 --logtostderr"'
Write-Host 'alias mysql="mysql -h 127.0.0.1 -P 15306 -u user"'
Write-Host "Hit Ctrl-C to stop the port forwards"

# 프로세스 종료 대기
Wait-Process -Id $process_id1.Id
Wait-Process -Id $process_id2.Id
Wait-Process -Id $process_id3.Id
