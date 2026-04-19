.PHONY: build plan simulate clean help

help:
	@echo "Alfa AWS Sentinel PoC: Automated Cloud Operations"
	@echo ""
	@echo "Usage:"
	@echo "  make build      Package the self-healing Lambda function"
	@echo "  make plan       Run Terraform plan to see infrastructure changes"
	@echo "  make simulate   Trigger a manual incident simulation"

build:
	@echo " Packaging Lambda remediator..."
	@cd lambda && zip remediator.zip remediator.py
	@echo "[SUCCESS] Build complete: lambda/remediator.zip"

plan:
	@echo "[SETUP] Running Terraform plan..."
	@cd terraform && terraform init -backend=false && terraform plan

simulate:
	@echo "[START] Simulating production incident..."
	@python3 scripts/simulate_incident.py
