import unittest
from unittest.mock import MagicMock, patch
import os
import sys
sys.path.append(os.path.join(os.path.dirname(__file__), '../lambda'))
import remediator

class TestAlfaSentinel(unittest.TestCase):
    @patch('boto3.client')
    def test_lambda_handler_success(self, mock_boto_client):
        mock_ec2 = MagicMock()
        mock_boto_client.return_value = mock_ec2
        os.environ['INSTANCE_ID'] = 'i-1234567890abcdef0'
        event = {'source': 'aws.cloudwatch', 'detail': {'alarmName': 'alfa-status-check-failure'}}
        response = remediator.lambda_handler(event, {})
        mock_ec2.reboot_instances.assert_called_once_with(InstanceIds=['i-1234567890abcdef0'])
        self.assertEqual(response['statusCode'], 200)

if __name__ == "__main__":
    unittest.main()
