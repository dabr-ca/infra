#!/usr/bin/env python

import os
import json

import boto3


TAG_NAME = os.environ['TAG_NAME']
PG_DUMP_SCRIPT = '''#!/bin/bash

# cloud-init quirk
export HOME=/root

pushd $(mktemp -d)

# Install dependencies
apt-get update -y
apt-get install -y curl ansible python3-boto3

# Download the playbook
curl -OL https://github.com/dabr-ca/config/raw/main/roles/pg_dump/files/do_pg_dump.yaml

# Run the playbook
ansible-playbook -i localhost, do_pg_dump.yaml

# Shutdown to terminate the EC2 instance
poweroff
'''


def lambda_handler(*_):

    ec2 = boto3.resource('ec2')
    client = boto3.client('ec2')

    # Step 1: Find an EC2 instance with tag
    instances = ec2.instances.filter(
        Filters=[
            {'Name': 'tag:Name', 'Values': [TAG_NAME]}
        ]
    )
    instances = list(instances)

    if len(instances) != 1:
        return {
            'statusCode': 500,
            'body': json.dumps(f'Too few or too many instances found with tag {TAG_NAME=}')
        }

    instance = instances[0]
    instance_id = instance.id
    instance_details = client.describe_instances(InstanceIds=[instance_id])
    instance_info = instance_details['Reservations'][0]['Instances'][0]

    # Extract necessary details from the A instance
    ami_id = instance_info['ImageId']
    instance_type = instance_info['InstanceType']
    subnet_id = instance_info['SubnetId']
    key_name = instance_info['KeyName']
    security_groups = [sg['GroupId'] for sg in instance_info['SecurityGroups']]
    iam_instance_profile_arn = instance_info.get('IamInstanceProfile', {}).get('Arn')
    iam_instance_profile = {'Arn': iam_instance_profile_arn} if iam_instance_profile_arn else None
    block_device_mappings = [{
        'DeviceName': '/dev/sda1',
        'Ebs': {
            'VolumeType': 'gp3',
            'DeleteOnTermination': True
        }
    }]

    # Step 2: Launch an EC2 instance with same config but name=B
    user_data_script = PG_DUMP_SCRIPT

    new_instance = ec2.create_instances(
        ImageId=ami_id,
        InstanceType=instance_type,
        KeyName=key_name,
        SecurityGroupIds=security_groups,
        SubnetId=subnet_id,
        BlockDeviceMappings=block_device_mappings,
        UserData=user_data_script,
        MinCount=1,
        MaxCount=1,
        InstanceInitiatedShutdownBehavior='terminate',
        IamInstanceProfile=iam_instance_profile,
    )

    new_instance_id = new_instance[0].id

    print(f'Launched new instance with ID: {new_instance_id}')

    return {
        'statusCode': 200,
        'body': json.dumps(f'New instance {new_instance_id} launched successfully')
    }


if __name__ == '__main__':
    print(lambda_handler())
