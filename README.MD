## Instructions

### Prepare Credentials

Retrieve your access key from AWS IAM service.
Enter your configuration when prompted:
```
aws configure
```

### Apply Infrastructure
Before running infrastructure, make sure already created   
(1) execution_role with AmazonECSTaskExecutionRolePolicy and CloudWatchLogsFullAccess  
(2) task_role: don't need to have any specific policy here (not accessing other aws resource)  
for ECS 

Already push the docker image onto ecr manually (The terraform will create an ecr), and specific the image url in the terraform ecs module.
```
aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin <aws account id>.dkr.ecr.<aws region>.amazonaws.com
```
```
docker tag ecr_service:latest <aws account id>.dkr.ecr.<aws region>.amazonaws.com/ecr_service:latest
```
```
docker push <aws account id>.dkr.ecr.us-west-2.amazonaws.com/ecr_service:latest
```

Since if I try to build the image using terraform docker provider, it keeps prompt missing cache (and I can't fix it with several attempting)
```
cd terraform
terraform init
terraform apply -auto-approve
```

### Send Requests
Make sure you are in terraform folder

Get public ip address
```
aws ec2 describe-network-interfaces \
--network-interface-ids $(
    aws ecs describe-tasks \
    --cluster $(terraform output -raw ecs_cluster_name) \
    --tasks $(
        aws ecs list-tasks \
        --cluster $(terraform output -raw ecs_cluster_name) \
        --service-name $(terraform output -raw ecs_service_name) \
        --query 'taskArns[0]' --output text
    ) \
    --query "tasks[0].attachments[0].details[?name=='networkInterfaceId'].value" \
    --output text
) \
--query 'NetworkInterfaces[0].Association.PublicIp' \
--output text
```

Send some requests:
```
curl http://<PUBLIC-IP-ADDRESS>:8080/v1/products/<productId>  
curl -X POST http://<PUBLIC-IP-ADDRESS>:8080/v1/products/<productId>/details -H "Content-Type: application/json" -d '{
  "product_id": <productId>,
  "sku": "SKU001",
  "manufacturer": "Acme",
  "category_id": 10,
  "weight": 500,
  "some_other_id": 1001
}'
```

## Clean Up
```
terraform destroy -auto-approve
```

Delete the ECR manually on aws


