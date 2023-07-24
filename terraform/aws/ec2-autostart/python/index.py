import json
import boto3
region = 'eu-central-1'
ec2 = boto3.resource('ec2', region_name='eu-central-1')
instances = ec2.instances.filter(Filters=[{'Name': 'instance-state-name', 'Values': ['stopped']},{'Name': 'tag:AutoStart','Values':['True']}])
def lambda_handler(event, context):
 instances = ec2.instances.filter(Filters=[{'Name': 'instance-state-name', 'Values': ['stopped']},{'Name': 'tag:AutoStart','Values':['True']}])
 for instance in instances:
     id=instance.id
     ec2.instances.filter(InstanceIds=[id]).start()
     print("Instance ID is running:- "+instance.id)
 return "success"
 
