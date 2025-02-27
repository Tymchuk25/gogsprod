pipeline {
    agent { label 'build' } // Нода, де є Go
    environment {
        REPO_URL = 'https://github.com/Tymchuk25/gogsprod.git'
        BRANCH = 'main'
    }
    stages {

	stage('Clean Workspace') {
            steps {
                echo 'Cleaning workspace...'
                cleanWs()
            }
        }
	    
        stage('Clone Repository') {
            steps {
                echo 'Cloning repository...'
                sh 'git clone --depth 1 $REPO_URL gogs'
            }
        }

	stage('Lint Check'){
	    steps{
		echo 'Lintting...'
		    
		sh '''
  		if [ -d "gogs" ]; then cd gogs; else echo "Error: gogs directory not found"; exit 1; fi
  		/home/vagrant/go/bin/golangci-lint run --verbose ./...
  		'''	
		   }
	}
	    
        stage('Build Artifact') {
            steps {
                echo 'Building the application...'
                sh 'pwd && ls -la'
                sh '''
                whoami
                ls -la
                go build -o gogs || { echo "Build failed!"; exit 1; }
                '''
            }
        }

	stage('Test Application'){
	    steps {
		echo 'Running tests...'
		sh 'go test ./...'		
		}
	}
	    
        stage('Archive Artifact') {
            steps {
                echo 'Archiving application...'
                sh '''
                zip -r gogs.zip gogs
                '''
            }
        }

        stage('Transfer Archive to Ansible Node') {
            steps {
		echo 'Transferring archive to Ansible node...'
                sh '''
                scp gogs.zip vagrant@192.168.56.113:/tmp/gogs.zip
                '''
            }
        }

        stage('Run Ansible Playbook') {
            agent { label 'master' } // Нода з Ansible
            steps {
		echo 'Running Ansible Playbook...'
               // sh '''
	//	set -e
        //        pwd
        //        whoami
        //        which ansible-playbook || { echo "Ansible not found!"; exit 1; }
        //        ansible-playbook --version
	//	ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i /home/vagrant/ansible/host.ini /home/vagrant/ansible/roleplaybook.yml
        //       ''' 
            }
        }
    }
}

