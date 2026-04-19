import boto3
import os
import json

def lambda_handler(event, context):
    print("[START] Alfa Operations Sentinel: Incident Detected!")
    print(f"DEBUG: Received event: {json.dumps(event)}")

    instance_id = os.environ.get('INSTANCE_ID')
    ec2 = boto3.client('ec2')

    try:
        # [AI] AI-Driven Operational Reasoning:
        # "I detect a StatusCheckFailed alarm on a mission-critical instance."
        # "First response protocol: Reboot the instance to restore availability."
        
        print(f"[WARNING] Incident: Health Check Failure on {instance_id}")
        print("[AI] Action: Triggering automated instance reboot...")
        
        ec2.reboot_instances(InstanceIds=[instance_id])
        
        return {
            'statusCode': 200,
            'body': json.dumps(f"Successfully triggered reboot for {instance_id}")
        }
    except Exception as e:
        print(f"[ERROR] Error during remediation: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps(f"Remediation failed: {str(e)}")
        }
