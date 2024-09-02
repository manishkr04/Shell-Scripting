#!/bin/bash


<<task
Deploy a Django app 
and handle the code for errors
task


# Clone the code 

code_clone(){
	echo "Cloning the Django app code"
	git clone https://github.com/LondheShubham153/django-notes-app.git
}

install_requirement(){
	echo "Installing Dependencies"
	sudo apt-get install docker.io nginx -y docker-compose 
}

required_restarts(){
	sudo chown $USER /var/run/docker.sock
	#sudo systemctl enable docker
	#sudo systemctl restart docker
	#sudo systemctl enable nginx
}

deploy(){
	docker build -t notes-app .
	#docker run -d -p 8000:8000 notes-app
	docker-compose up -d


}

echo "**********Deployment Started************"

if ! code_clone; then
	echo "the code directory already exists"
	cd django-notes-app
fi

if ! install_requirement; then 
	echo "Installation Failed"
	exit 1
fi

if ! required_restarts; then
	echo "System fault identified"
	exit 1
fi

if ! deploy; then
	echo " Deployment failed, mailing the admin"
	# sendmail utility
	exit 1
fi

echo "***************Deploment Done***********"

