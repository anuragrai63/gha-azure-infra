### 🛠️ Infrastructure-as-Code Project

## 🎯 Purpose
This project aims to provide a complete Infrastructure-as-Code (IaC) solution leveraging Azure and Terraform. This setup is intended to automate the provisioning of infrastructure components, improving efficiency, consistency, and repeatability.

## 🌐 Architecture Overview
This project is designed following a hub-and-spoke topology which includes:
- **Hub VNet**: Serves as the central point of communication.
- **Spoke VNet 1**: Dedicated for application workloads.
- **Spoke VNet 2**: Used for database workloads..

## ⚙️ Complete Setup Instructions
1. **Setup Azure Service Principal**  
   - Create a Service Principal in Azure. Reference guide: [Azure SP](https://learn.microsoft.com/en-us/azure/developer/terraform/authenticate-to-azure)
   - Capture the App ID, Secret, and Tenant ID.
   
2. **Configure Terraform Backend**  
   - Create an Azure Storage Account to store the Terraform state.  
   - Configure the backend in your `main.tf` file:
     ```hcl
     terraform {
       backend "azurerm" {
         resource_group_name  = "mytfstate"
         storage_account_name  = "mytfstate"
         container_name       = "terraform-state"
         key                  = "terraform.tfstate"
       }
     }
     ```

3. **Setup GitHub Secrets**  
   - Navigate to your GitHub repository settings and add secrets: `AZURE_CLIENT_ID`, `AZURE_CLIENT_SECRET`, `AZURE_TENANT_ID`.

4. **Deploy Infrastructure**  
   - Run the following commands in your terminal:  
     ```bash
     terraform init
     terraform plan
     terraform apply
     ```

5. **Verify Deployment**  
   - Check the Azure portal to ensure all resources are created as expected.

6. **Documentation and Workflow**  
   - Follow the CI/CD workflow as documented below.

## 🔄 CI/CD Workflow Documentation  
- **Continuous Integration (CI)**: Automatically test and validate Terraform configurations on each commit.
- **Continuous Deployment (CD)**: Deploy validated configurations automatically to the Azure environment using GitHub Actions.

## 🗂️ Project Structure  
```
|- /terraform            # Root directory
|- README.md             # Project documentation
```

## 🏷️ Configuration Variables
- `LOCATION`: Azure region for resource deployment.
- `RESOURCE_GROUP`: Azure resource group name.

## 🏆 Key Achievements  
- Infrastructure automation with Terraform
- CI/CD integration with GitHub Actions
- Security and compliance measures implemented
- Robust network design with isolation
- Operational excellence and best practices adhered to

## 🚀 Advanced Usage Examples
- Managing multiple environments (dev, staging, prod).
- Custom module creation to encapsulate infrastructure.

## 🔒 Security Considerations
- Ensure secrets are not hardcoded in configuration files.
- Follow principle of least privilege for Azure Service Principal.

## 📚 Resources
- [Terraform Documentation](https://www.terraform.io/docs/index.html)
- [Azure Documentation](https://docs.microsoft.com/en-us/azure/)

## 🤝 Contributing Guidelines
- Fork the repository, make changes, and submit a pull request.
- Follow the code of conduct.



## 🙌 Support Information
For support, open an issue in the GitHub repository or contact the project maintainer.

