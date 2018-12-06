# infra - Shippable infrastructure

This project contains scripts that are used to manage Shippable infrastructure
for RC and Production environments. Most of the code uses `terraform` while some of
the utilities are in `bash`.

The project is hooked up in Shippable assembly lines to execute whenever a change is
merged. The job(s) in the assembly lines ensure that the state file is updated
correctly and can only be accessed with correct permissions.

## RC

The directory `rc-saas` contains components needed to provision RC
infrastructure. This provisions the following components:

- VPC, subnets, internet gateway, NAT/jumpbox
- instances for running Shippable services
- load balancers to expose Shippable API and UI
- instances for running Shippable shared build nodes
- test instances required by Shippable development team

## Production

The directory `prod-saas` contains components needed to provision RC
infrastructure. This provisions the following components:

- VPC, subnets, internet gateway, NAT/jumpbox
- instances for running Shippable services
- load balancers to expose Shippable API and UI

The directory `prodci-saas` contains components needed to run on-demand builds
behind a static IP which helps in whitelisting IP addresses. Read the
[documentation](http://docs.shippable.com/platform/tutorial/runtime/manage-node-pools/#using-static-ip-to-whitelist-traffic-from-on-demand-nodes) for more details.

## Workflow

- Make changes in any script(s)
- Comment out `terraform apply` line in `provision.sh` script
- Send PR, get it merged after review(s)
- Make sure the job runs `terraform plan` with expected results
- Uncomment `terraform apply` in `provision.sh` script
- Send PR, get it merged
- The job should run `terraform apply`, resulting in expected changes
