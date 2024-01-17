$instances = aws ec2 describe-instances --filters Name=tag:Scheduled,Values=schdeuled-22_to_9-hold,schdeuled-22_to_1-hold,schdeuled-22_to_9-hold --output json | ConvertFrom-Json

foreach ($instance in $instances.Reservations.Instances) {
    $instanceId = $instance.InstanceId
    $instanceName = $instance.Tags.Where({ $_.Key -eq "Name" }).Value
    $currentTagValue = $instance.Tags.Where({ $_.Key -eq "Scheduled" }).Value

    if ($currentTagValue -in ("schdeuled-22_to_9-hold","schdeuled-22_to_1-hold","schdeuled-22_to_9-hold")) {
        $newValue = $currentTagValue.Substring(0, $currentTagValue.Length - 5)  # Remove "-hold"
        aws ec2 create-tags --resources $instanceId --tags Key=Scheduled,Value=$newValue
        Write-Output "Instance $instanceName ($instanceId) has been updated with tag Scheduled: $newValue"
    }
}
