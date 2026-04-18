# 🛡️ Alfa AWS Sentinel: Automated Cloud Operations

## Project Overview
Alfa AWS Sentinel is a Proof of Concept (PoC) demonstrating **Self-Healing Infrastructure** designed for mission-critical AWS environments. 

This tool automates the "Detection-to-Remediation" lifecycle, reducing manual toil for Cloud Operations teams and ensuring 24/7 availability for global clients.

## 💎 The Edge: Why This Matters for Alfa
*   **Operational Stability:** Directly addresses the "availability and performance" focus of the Alfa Cloud team.
*   **Automated Incident Response:** Replaces manual NOC checks with automated health-check remediation.
*   **Shift-Left Reliability:** Uses Infrastructure-as-Code (Terraform) to bake reliability into the deployment from day one.

## 🏗️ Technical Stack
*   **Infrastructure:** Terraform (AWS)
*   **Observability:** CloudWatch Alarms & Metrics
*   **Self-Healing:** AWS Lambda (Python / Boto3)
*   **Management:** Makefile

## 🚀 How It Works
1.  **Monitor:** CloudWatch tracks the `StatusCheckFailed` metric for mission-critical EC2 instances.
2.  **Detect:** An alarm triggers when a health check failure is detected.
3.  **Remediate:** The alarm invokes the `remediator` Lambda function, which uses the AWS SDK (Boto3) to automatically reboot the instance and restore service.
4.  **Log:** Every action is logged in CloudWatch Logs for audit trails and post-mortem analysis.

## 🛠️ Local Demo
You can build and simulate the automation using the included Makefile:
```bash
# Package the Lambda code
make build

# See the infrastructure plan
make plan

# (Optional) Simulate an incident if deployed
# make simulate
```

---
**Built for the Alfa Cloud Operations Team by Aegis Agent.**
