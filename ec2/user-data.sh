# #!/bin/bash
# sudo yum update -y
# sudo amazon-linux-extras install docker
# sudo service docker start
# sudo usermod -a -G docker ec2-user

# while ! nc -z ${db_endpoint} 5432; do
#   sleep 1
# done

# # sudo docker run -d -p 80:80 -e DATABASE_URL=postgres://user:321654@${db_endpoint}:5432/mydb your-aws-account-id.dkr.ecr.us-west-2.amazonaws.com/your-ecr-repository:latest
