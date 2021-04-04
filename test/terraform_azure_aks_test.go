package test

import (
	"fmt"
	"testing"
	"os"

	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestTerraformAzureAKSLEO(t *testing.T) {
	t.Parallel()
	expectedClusterName := fmt.Sprintf("terratest-aks-cluster-%s", random.UniqueId())
	expectedResourceGroupName := fmt.Sprintf("terratest-aks-rg-%s", random.UniqueId())
	backendClientId := os.Getenv("BACKEND_CLIENT_ID")
	backendClientSecret := os.Getenv("BACKEND_CLIENT_SECRET")
	tenantID := os.Getenv("TENANT_ID")
	subscriptionID := os.Getenv("SUBSCRIPTION")
	backendSSHKey := os.Getenv("BACKEND_SSH_KEY")
	environment := os.Getenv("ENV")
	dbName := os.Getenv("DB_NAME")
	expectedAagentCount := 3
    // Enable and provide the following variables to test backend config with http backend

	//projectId := "terratest-aks-cluster"
	//storageAccountName := os.Getenv("STORAGE_ACCOUNT_NAME")
    //containerName := projectId + "-tfstate"
    //backendConfigKey := environment + ".terraform.tfstate"
	//saResourceGroupName := os.Getenv("SA_RG_NAME")


	terraformOptions := &terraform.Options{
		TerraformDir: "/template",
		Vars: map[string]interface{}{
			"resource_group_name":     expectedResourceGroupName,
			"backend_client_id":       backendClientId,
			"backend_client_secret":   backendClientSecret,
			"tenant_id":               tenantID,
			"subscription_id":         subscriptionID,
			"backend_ssh_key":         backendSSHKey,
			"environment":             environment,
			"db_name":                 dbName,

		},
		// Enable the following block to test backend config with http backend
		/*BackendConfig: map[string]interface{}{
			"resource_group_name": saResourceGroupName,
			"storage_account_name":    storageAccountName,
			"container_name": containerName,
			"key": backendConfigKey,
			"subscription_id": subscriptionID,
			"tenant_id": tenantID,
            "client_id": backendClientId,
			"client_secret": backendClientSecret,
		},*/
			
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Look up the cluster node count
	cluster, err := azure.GetManagedClusterE(t, expectedResourceGroupName, expectedClusterName, "")
	require.NoError(t, err)
	actualCount := *(*cluster.ManagedClusterProperties.AgentPoolProfiles)[0].Count

	// Test that the Node count matches the Terraform specification
	assert.Equal(t, int32(expectedAagentCount), actualCount)
	
}