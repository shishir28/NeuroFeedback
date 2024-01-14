$resourceGroup = "NeuroFeedbackApp-DEV_RG"
$location = "australiaeast"
$eventHubNamespace = "NeuroFeedbackAppns"
$eventHubName = "NeuroFeedbackApp"

$storageAccName = "neurofeedbackappstrg"
$storageSKU = "Standard_LRS"

#Create resource group
az group create -n $resourceGroup -l $location

# Create an Event Hubs namespace. Specify a name for the Event Hubs namespace.
az eventhubs namespace create --name  $eventHubNamespace --resource-group $resourceGroup -l $location


# Create an event hub. Specify a name for the event hub. 

az eventhubs eventhub create --name $eventHubName --resource-group $resourceGroup --namespace-name $eventHubNamespace

#create a publisher policy to send messages

az eventhubs eventhub authorization-rule create --resource-group $resourceGroup  --namespace-name  $eventHubNamespace --eventhub-name $eventHubName --name $eventHubPolicyName --rights Send


$messagegateway_func_app = "NeuroFeedbackApp-Dev-MessageGateway-func"
$messagegateway_func_plan = "NeuroFeedbackApp-Dev-MessageGateway-plan"
$messagegateway_func_app_insights = ""NeuroFeedbackApp-Dev-MessageGateway-insights"