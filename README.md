Terraform Templates to Deploy Infrastructure onto AWS

PreRequisites:
To generate new SSH Keys, on a Mac, run the command ssh-keygen -f panorama_demo_key -t rsa -N '' in your ssh-keys folder or directory. On Windows, you can use PuttyGen to generate new SSH keys.
THere is no default username/password for Panorama, you will need to use SSH to configure the password for the Admin account.
Code Organization:
    - aws_single_panorama.tf: Contains the definition of the various artifacts that will be deployed on AWS.
    - aws_vars.tf: Define the various variables that will be required as inputs to the Terraform template.
Note: The aws_vars.tf has default values provided for certain variables. These can obviously be overridden by specifying those variables and values in the terraform.tfvars file.

Credentials and Authentication:
Modify the aws_vars.tf to provide the AWS ACCESS_KEY and SECRET_KEY.

The structure of the aws_creds.tf file should be as follows:

    provider "aws" {
      access_key = "<access_key>"
      secret_key = "<secret_key>"
      region     = "${var.aws_region}"
    }

Usage:
run terraform: terraform apply

Notes:
The intention of this configuration is to deploy a management-only version of Panorama.  This does not use bootstraping and will require to login and configure an Admin password and import the license/Serial Number. 
To SSH to Panorama you can use the same private key generated, panorama_demo_key. For example ssh -i panorama_demo_key admin@(EIP assigned to Panorama)

Support:
This template is a fork of the Palo Alto Networks terraform template and is released under an as-is, best effort, support policy. These scripts should be seen as community supported and Palo Alto Networks will contribute our expertise as and when possible. We do not provide technical support or help in using or troubleshooting the components of the project through our normal support options such as Palo Alto Networks support teams, or ASC (Authorized Support Centers) partners and backline support options. The underlying product used (the VM-Series firewall) by the scripts or templates are still supported, but the support is only for the product functionality and not for help in deploying or using the template or script itself. Unless explicitly tagged, all projects or work posted in our GitHub repository (at https://github.com/PaloAltoNetworks) or sites other than our official Downloads page on https://support.paloaltonetworks.com are provided under the best effort policy.
