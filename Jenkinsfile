pipeline {
    agent { label 'build' } // Нода, де є Go
    environment {
        REPO_URL = 'https://github.com/Tymchuk25/gogsprod.git'
	GH_TOKEN = credentials('github-credentials')
	ZIP_NAME = 'gogs.zip'
    }
    stages {
	    
	stage('Lint Check'){
	    steps{
		echo 'Lintting...'
		sh '''
  		/home/vagrant/go/bin/golangci-lint run --verbose --timeout=5m ./... 
  		'''	
	    }
	}

	stage('Test Application'){
	    steps {
		echo 'Running tests...'  
		sh '''
  		go test ./...
    		'''		
		}
	}
	    
        stage('Build Artifact') {
	    when { branch 'main' }
            steps {
                echo 'Building the application...'
                sh '''
                go build -o gogs || { echo "Build failed!"; exit 1; }
                '''
            }
        }
	    
        stage('Archive Artifact') {
	    when { branch 'main' }
            steps {
                echo 'Archiving application...'
                sh '''
                zip -r gogs.zip gogs
                '''
	    script {
                    env.TAG_NAME = sh(script: '''
                        git fetch --tags
                        git tag --sort=-v:refname | head -n 1
                    ''', returnStdout: true).trim()
                    echo "Latest Tag: ${env.TAG_NAME}"
                }
            }
        }

        stage('Transfer Archive to Ansible Node') {
	    when { branch 'main' }
            steps {
		echo 'Transferring archive to Ansible node...'
		    echo "TAG_NAME: ${env.TAG_NAME}"
			echo "ZIP_NAME: ${env.ZIP_NAME}"
			echo "GIT_URL: ${env.GIT_URL}"

		sh '''
  		  scp gogs.zip vagrant@192.168.56.113:/tmp/gogs.zip
      		'''
            }
        }

	stage('Create GitHub Release'){
	    when { tag 'v*' }
	    steps {
		echo 'Creating GitHub Release...'
                sh """
                gh release create \
                    ${TAG_NAME} \
                    ${ZIP_NAME} \
                    --repo ${REPO_URL} \
                    --generate-notes
                """
	    }
	}

        stage('Deploy (Run Ansible Playbook)') {
	    when { branch 'main' }
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
    post {         
        always {
            cleanWs()  
        }
    }
}

