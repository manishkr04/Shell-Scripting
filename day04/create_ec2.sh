#!/bin/bash

set -euo pipefail

#check if AWS CLI is installed 

check_awscli(){
	if ! command -v aws $> /dev/null;
	then
		echo "AWS CLi is not installed, please install it first." >&2
	else
		echo "Aws cli is already installed"
	fi

}

#installing AWS_CLI 
install_awscli(){
	echo "Installing AWS CLI v2 on LInux..."

	#Download and install AWS CLI v2
	curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
	sudo apt-get install -y unzip &> /dev/null
	unzip awscliv2.zip
	sudo ./aws/install


	#verify installation
	aws --version

	#clean up
	rm -rf awscliv2.zip

}

# Function to check if AWS CLI is configured
check_aws_configuration(){
    echo "Checking if AWS CLI is configured..."

    # Get the configured AWS Access Key, Secret Key, and Region
    aws_access_key=$(aws configure get aws_access_key_id)
    aws_secret_key=$(aws configure get aws_secret_access_key)
    aws_region=$(aws configure get region)
    aws_output=$(aws configure get output)

    # Check if any of the required configuration values are missing
    if [[ -z "$aws_access_key" || -z "$aws_secret_key" || -z "$aws_region" || -z "$aws_output" ]]; then
        return 1  # AWS CLI is not configured
    else
        return 0  # AWS CLI is configured
    fi
}

#configure AWS CLI

configure_awscli(){
	echo "Configuring AWS CLI..."

	#Prompt for AWS credentials and default region
	read -p "Enter Your AWS Access Key ID: " aws_access_key
	read -p "Enter Your AWs secret Access Key: " aws_secret_key
	read -p "Enter your default AWS region: " aws_region
	read -p "Enter your output format (json, text, or table); " aws_output

	#Run AWS CLI configuration command
	aws configure set aws_access_key_id "$aws_access_key"
	aws configure set aws_secret_access_key "$aws_secret_key"
	aws configure set region "$aws_region"
	aws configure set output "$aws_output"

	echo "Aws CLI has been configured."
}

#function to check in certain interval to come into running state
wait_for_instance(){
	local instance_id="$1"
	echo "waiting for instance $instance_id to be in running state..."

	while true;
	do
		state=$(aws ec2 describe-instances \
		       	--instance-ids "$instance_id" \
			--query 'Reservations[0].Instances[0].State.Name' --output text)
		if [[ "$state" == "running" ]]; 	then
			echo "Instance $instance_id is now running."
			break
		fi
		sleep 10
	done
}

#Creating EC2 instances
create_ec2_instance(){
	local ami_id="$1"
	local instance_type="$2"
	local key_name="$3"
	local subnet_id="$4"
	local security_group_ids="$5"
	local instance_name="$6"


	#Run AWS CLI command to create EC2 instance 
	instance_id=$(aws ec2 run-instances \
		--image-id "$ami_id" \
		--instance-type "$instance_type" \
		--key-name "$key_name" \
		--subnet-id "$subnet_id" \
		--security-group-id "$security_group_ids" \
		--tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance_name}]" \
		--query 'Instances[0].InstanceId'\
		--output text
	)

	if [[ -z "$instance_id" ]]; then
		echo "Failed to create EC2 instance." >&2
		exit 1
	fi

	echo "Instance $instance_id created Successfully"


	#wait for the instance to be in running state
	wait_for_instance "$instance_id"
}

main(){
	if ! check_awscli; 
	then
		install_awscli || exit 1
	fi


    	if check_aws_configuration; then
        	echo "AWS CLI is already configured."
       		echo "AWS Access Key: $(aws configure get aws_access_key_id)"
       		echo "AWS Region: $(aws configure get region)"
        	echo "Output Format: $(aws configure get output)"
    	else
        	echo "AWS CLI is not configured. Proceeding to configure..."
        	configure_awscli
    	fi
	

	echo "Creating Ec2 Instance..."

	#Specify the parameters for creating the Ec2 instance
	 AMI_ID="ami-0522ab6e1ddcc7055"
   	 INSTANCE_TYPE="t2.micro"
   	 KEY_NAME="pem"
   	 SUBNET_ID="subnet-0cbad325ebddb67b2"
    	 SECURITY_GROUP_IDS="sg-0230519eed63e6e0a"  # Add your security group IDs separated by space
   	 INSTANCE_NAME="Shell-Script-EC2-Demo"

	# Call the function to create the EC2 instance
	 create_ec2_instance "$AMI_ID" "$INSTANCE_TYPE" "$KEY_NAME" "$SUBNET_ID" "$SECURITY_GROUP_IDS" "$INSTANCE_NAME"

	 echo "Ec2 Instance Creation completed"
}

main "$@"
