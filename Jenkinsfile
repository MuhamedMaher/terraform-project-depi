pipeline {
    agent any

    environment {
        TF_VAR_PRIVATE_IPS_FILE = 'ansible/inventory/inventory.ini'
    }

    stages {
        stage('Terraform Init and Plan') {
            when {
                changeset "**/terraform/**"
            }
            steps {
                dir('terraform') {
                    sh 'terraform init'
                    sh 'terraform plan'
                }
            }
        }
        stage('Terraform Apply') {
            when {
                changeset "**/terraform/**"
            }
            steps {
                dir('terraform') {
                    sh 'terraform apply -auto-approve'
                    script {
                        def ips = sh(script: 'terraform output -raw private_ips', returnStdout: true)
                        writeFile file: env.TF_VAR_PRIVATE_IPS_FILE, text: "[private_instances]\n${ips}"
                    }
                }
            }
        }
        stage('Ansible Configuration') {
            when {
                anyOf {
                    changeset "**/ansible/**"
                    triggeredBy 'Terraform Apply'
                }
            }
            steps {
                dir('ansible') {
                    sh 'scp -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa -r . ubuntu@<Bastion_Host_IP>:~/ansible/'
                    sh 'ssh -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa ubuntu@<Bastion_Host_IP> "cd ~/ansible && ansible-playbook playbooks/docker_install.yml"'
                }
            }
        }
    }
}

