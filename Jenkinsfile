pipeline {
    agent { label 'master' } // Нода, де є Go
    environment {
        REPO_URL = 'https://github.com/Tymchuk25/gogs.git'
        BRANCH = 'main'
    }
    stages {
        stage('Clone Repository') {
            steps {
                echo 'clone'
                //sh 'sudo rm -rf gogs && sudo rm -rf gogs.zip  && git clone -b $BRANCH --depth 1 $REPO_URL gogs'
            }
        }

        stage('Build Artifact') {
            steps {
                echo 'build'
               // sh 'pwd && ls -la'
                //sh '''
                //if [ -d "gogs" ]; then cd gogs; else echo "Error: gogs directory not found"; exit 1; fi
                //whoami
                //ls -la
                //go build -o gogs
                //'''
            }
        }

        stage('Archive Artifact') {
            steps {
                echo 'archive'
                sh 'sleep 7'
                //sh '''
                //zip -r gogs.zip gogs
                //'''
            }
        }

        stage('Transfer Archive to Ansible Node') {
            steps {
               // sh '''
                //scp gogs.zip vagrant@192.168.56.113:/tmp/gogs.zip
                //'''
                echo 'transfer'
            }
        }

        stage('Run Ansible Playbook') {
            agent { label 'master' } // Нода з Ansible
            steps {
              //  sh '''
               // pwd
              //  whoami
  //  which ansible-playbook || echo "Ansible не знайдено!"
  //  ansible-playbook --version
   // ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i /var/lib/jenkins/workspace/PipelineGogsApp/ansible/host.ini /var/lib/jenkins/workspace/PipelineGogsApp/ansible/roleplaybook.yml
// '''           
            }
        }
    }
}

