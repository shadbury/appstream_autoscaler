#!/usr/bin/env make
include Makehelp

ifdef CI
	export AWS_DIR = ./init/aws
else
	export AWS_DIR = ~/.aws
endif

export CI_PROJECT_NAME ?= docker-volume
export CI_JOB_ID ?= local


## Initialise Terraform
init: .env
	docker-compose run --rm envvars ensure --tags terraform-init
	docker-compose run --rm terraform-utils sh -c 'cd ${TERRAFORM_ROOT_MODULE}; terraform init ${BACKEND_CONFIG}'
.PHONY: init

## Initialise Terraform but also upgrade modules/providers
upgrade: .env init
	docker-compose run --rm envvars ensure --tags terraform-init
	docker-compose run --rm terraform-utils sh -c 'cd ${TERRAFORM_ROOT_MODULE}; terraform init -upgrade ${BACKEND_CONFIG}'
.PHONY: upgrade

## Generate a plan
plan: .env init workspace
	docker-compose run --rm envvars ensure --tags terraform
	docker-compose run --rm terraform-utils sh -c 'cd ${TERRAFORM_ROOT_MODULE}; terraform plan'
.PHONY: plan

## Generate a plan without color to save as text file
plan-no-color: .env init workspace
	docker-compose run --rm envvars ensure --tags terraform
	docker-compose run --rm terraform-utils sh -c 'cd ${TERRAFORM_ROOT_MODULE}; terraform plan  -no-color'
.PHONY: plan

## Generate a plan and apply it
apply: .env init workspace
	docker-compose run --rm envvars ensure --tags terraform
	docker-compose run --rm terraform-utils sh -c 'cd ${TERRAFORM_ROOT_MODULE}; terraform apply'
.PHONY: apply

## Apply for CICD systems
applyAuto: .env init workspace
	docker-compose run --rm envvars ensure --tags terraform
	docker-compose run --rm terraform-utils sh -c 'cd ${TERRAFORM_ROOT_MODULE}; terraform apply -auto-approve'
.PHONY: applyAuto



## Destroy resources
destroy: .env init workspace
	docker-compose run --rm envvars ensure --tags terraform
	docker-compose run --rm terraform-utils sh -c 'cd ${TERRAFORM_ROOT_MODULE}; terraform destroy'
.PHONY: destroy

## Show the statefile
show: .env init workspace
	docker-compose run --rm envvars ensure --tags terraform
	docker-compose run --rm terraform-utils sh -c 'cd ${TERRAFORM_ROOT_MODULE}; terraform show'
.PHONY: show

## Show root module outputs
output: .env init workspace
	docker-compose run --rm envvars ensure --tags terraform
	docker-compose run --rm terraform-utils sh -c 'cd ${TERRAFORM_ROOT_MODULE}; terraform output'
.PHONY: output

## Switch to specified workspace
workspace: .env
	docker-compose run --rm envvars ensure --tags terraform
	docker-compose run --rm terraform-utils sh -c 'cd $(TERRAFORM_ROOT_MODULE); terraform workspace select $(TERRAFORM_WORKSPACE) || terraform workspace new $(TERRAFORM_WORKSPACE)'
.PHONY: workspace

## Validate terraform is syntactically correct
validate: .env init
	docker-compose run --rm envvars ensure --tags terraform
	docker-compose run --rm terraform-utils sh -c 'cd ${TERRAFORM_ROOT_MODULE}; terraform validate'
.PHONY: validate

## Format all Terraform files
format: .env
	docker-compose run --rm terraform-utils terraform fmt -diff -recursive
.PHONY: format

## Interacticely launch a shell in the Terraform docker container
shell: .env
	docker-compose run --rm terraform-utils sh
.PHONY: shell

## Generate Docker env file
.env:
	touch .env
	docker-compose run --rm envvars validate
	docker-compose run --rm envvars envfile --overwrite
.PHONY: .env
