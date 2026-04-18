import boto3
import sys

def simulate_failure(alarm_name):
    print(f"🛠️ Simulating Production Incident for: {alarm_name}")
    cw = boto3.client('cloudwatch')
    
    try:
        cw.set_alarm_state(
            AlarmName=alarm_name,
            StateValue='ALARM',
            StateReason='Manual simulation of production failure for PoC demonstration.'
        )
        print("✅ Incident simulated. Check CloudWatch/Lambda logs for remediation.")
    except Exception as e:
        print(f"❌ Failed to simulate incident: {e}")

if __name__ == "__main__":
    simulate_failure('alfa-status-check-failure')
