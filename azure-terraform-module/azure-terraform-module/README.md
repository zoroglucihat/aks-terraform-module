# Azure AKS Terraform Module

This repository contains a modular Terraform configuration to provision a secure and scalable Azure Kubernetes Service (AKS) environment.

## 🏗️ Architecture

This Terraform configuration creates the following Azure resources:

- **Resource Group** - Main container for all resources
- **Virtual Network (VNet)** and **Subnet** - Network infrastructure
- **Network Security Group (NSG)** - Security rules
- **Azure Key Vault** - Secure storage for secrets and keys
- **AKS Cluster** - Kubernetes cluster

## 📦 Modules

| Module    | Description                                          | Resources |
|-----------|------------------------------------------------------|-----------|
| `network` | Creates VNet, Subnet and NSG                        | `azurerm_virtual_network`, `azurerm_subnet`, `azurerm_network_security_group` |
| `keyvault`| Creates Azure Key Vault                             | `azurerm_key_vault` |
| `aks`     | Deploys AKS cluster with system-assigned identity   | `azurerm_kubernetes_cluster` |

## 🚀 Quick Start

### Prerequisites

1. **Azure CLI** installed and authenticated
   ```bash
   az login
   ```

2. **Terraform** installed (v1.0+ recommended)
   ```bash
   terraform version
   ```

3. **Azure Subscription** with required permissions

### 1. Clone the repository

```bash
git clone https://github.com/zoroglucihat/aks-terraform-module.git
cd aks-terraform-module
```

### 2. Configure Terraform variables

Copy the `terraform.tfvars.example` file and fill with your values:

```bash
cp terraform.tfvars terraform.tfvars.local
```

**terraform.tfvars.local** content:
```hcl
location            = "West Europe"
resource_group_name = "rg-aks-production"
tenant_id           = "your-tenant-id-here"
```

> 📝 **Note:** `.tfvars` files are included in .gitignore and not committed to version control.

### 3. Initialize Terraform

```bash
terraform init
```

### 4. Review the plan

```bash
terraform plan
```

### 5. Deploy the infrastructure

```bash
terraform apply
```

## ⚙️ Configuration

### Variables

| Variable Name       | Description                    | Type   | Default     | Required |
|---------------------|--------------------------------|--------|-------------|----------|
| `location`          | Azure region                   | string | -           | Yes      |
| `resource_group_name` | Resource group name          | string | -           | Yes      |
| `tenant_id`         | Azure Active Directory tenant | string | -           | Yes      |

### Outputs

After terraform apply completes, the following values are outputted:

- AKS cluster name
- Cluster connection information
- Key Vault name
- Resource group name

## 🔧 Advanced Configuration

### Key Vault Naming

Key Vault names must be globally unique. This configuration automatically adds a unique suffix:
```hcl
keyvault_name = "aks-keyvault-${random_string.suffix.result}"
```

### Network Configuration

Default network settings:
- **VNet CIDR:** `10.0.0.0/16`
- **Subnet CIDR:** `10.0.1.0/24`

### AKS Configuration

Default AKS settings:
- **Node Count:** 2
- **VM Size:** Standard_DS2_v2
- **Kubernetes Version:** Latest stable

## 🎯 Usage Examples

### Connect to AKS Cluster

```bash
# Get AKS credentials
az aks get-credentials --resource-group rg-aks-production --name aks-cluster

# Check cluster status
kubectl get nodes
```

### Access Key Vault

```bash
# List Key Vault
az keyvault list --resource-group rg-aks-production

# Add secret
az keyvault secret set --vault-name aks-keyvault-abc123 --name mysecret --value myvalue
```

## 🛠️ Troubleshooting

### Common Issues

1. **Resource Group not found error**
   - ✅ Fixed: Resource group is now automatically created by Terraform

2. **Key Vault name already in use**
   - ✅ Fixed: Unique names generated with random suffix

3. **Missing provider configuration**
   - ✅ Fixed: azurerm provider configuration added

### Useful Commands

```bash
# Check Terraform state
terraform state list

# Recreate resources
terraform taint module.aks.azurerm_kubernetes_cluster.aks
terraform apply

# Destroy entire infrastructure
terraform destroy
```

## 📁 Project Structure

```
.
├── main.tf                 # Main Terraform configuration
├── variables.tf            # Input variables
├── outputs.tf              # Output values
├── terraform.tfvars        # Variable values (ignored)
├── .gitignore             # Git ignore rules
├── modules/
│   ├── network/           # Network module
│   ├── keyvault/          # Key Vault module
│   └── aks/               # AKS module
└── README.md              # This file
```

## 🔒 Security Considerations

- **Sensitive Data:** `.tfvars` files are not included in version control
- **State Files:** `.tfstate` files are also ignored (use remote state for production)
- **Key Vault:** Uses automatically managed identity
- **Network:** Network security provided by NSG

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## 📞 Support

For questions, please open an issue or contact [contact information].
