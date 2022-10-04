# inspired by https://jarekprzygodzki.dev/post/monitor-new-process-creation/

# $events = Get-Event
$count = 0

$action = {
  $sourceeventargs | Format-List -Property * | Write-Host
  write-host "process created"
  $count += 1
}
$Query = "select * from __instanceCreationEvent within 1 where targetInstance isa 'win32_Process'"
Register-CimIndicationEvent -Query $query -Action $action -SourceIdentifier "ProcessStart"

sleep 30

# $watcher = Setup-Event-Watcher
# $watcher.waitForNextEvent()
# Get-EventSubscriber
# echo what
# while ($e = Get-Event) {
#   $e.SourceEventArgs | Format-List -Property *
#   $count += 1
#   if ($count -gt 5) {
#     break
#   }
# }

echo "count: $count"

Get-EventSubscriber | Unregister-Event

echo "final events"
Get-Event | Remove-Event

# Get-Event -ClassName Win32_ProcessStartTrace -SourceIdentifier "ProcessStarted"
