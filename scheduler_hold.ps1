$instances = aws ec2 describe-instances --filters Name=tag:Scheduled,Values=schdeuled-22_to_9,schdeuled-22_to_1,schdeuled-22_to_9 --output json | ConvertFrom-Json

foreach ($instance in $instances.Reservations.Instances) {
    $instanceId = $instance.InstanceId
    $instanceName = $instance.Tags.Where({ $_.Key -eq "Name" }).Value
    $currentTagValue = $instance.Tags.Where({ $_.Key -eq "Scheduled" }).Value

    if ($currentTagValue -eq "schdeuled-22_to_9") {
        $newValue = "schdeuled-22_to_9-hold"
    } elseif ($currentTagValue -eq "schdeuled-22_to_1") {
        $newValue = "schdeuled-22_to_1-hold"
    } else {
        $newValue = "schdeuled-22_to_9-hold"  # Default value for other cases
    }

    if ($newValue -ne $currentTagValue) {  # Only update if the value has changed
        aws ec2 create-tags --resources $instanceId --tags Key=Scheduled,Value=$newValue
        Write-Output "Instance $instanceName ($instanceId) has been updated with tag Scheduled: $newValue"
    }
}
