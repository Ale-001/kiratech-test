# Secondo progetto

Per questo progetto si voleva provare a deployare delle istanze ECS su AWS attraverso l'uso di terraform.

Con il successivo obiettivo di riuscire a creare un cluster usando ansible.

## Step Preliminari

- Installare AWS Cli
- Installare Terraform

Per l'installazione di Terraform si è fatto affidamento alla seguente guida:

> https://spacelift.io/blog/how-to-install-terraform

Per installare ansible si è proseguito ad installarlo tramite WSL all'interno della AWS Cli

Siccome non è possibile installare Ansible su Windows


Entrare nella cartella terraform

Comandi:

> terraform init

> terraform validate

> terraform plan

> terraform apply

Attualmente è ancora in corso, il deploy dei servizi permette di connettersi e di creare le istance EC2 e di connettersi con ssh alle istanze

## Comando per creare le chiavi ssh:

> ssh-keygen -t rsa -b 2048 -f C:\Users\biond\.aws\aws_k8s_cluster\key.pem -C "biondoalessandro2001@gmail.com"

## Modifica dei permessi chiave pubblica

chmod 400 /mnt/c/Users/biond/.aws/aws_k8s_cluster/key.pem

## Comando per collegarsi con ssh alle istance EC2:

ssh -i "C:\Users\biond\.aws\aws_k8s_cluster\key.pem" ec2-user@<public_ip>

## Copio la chiave su wls nel percorso per far funzionare lo script ansible:

~/key.pem

cp /mnt/c/Users/biond/.aws/aws_k8s_cluster/key.pem ~/

chmod 400 ~/key.pem

ls ~/

## Modificare l'ip del file inventory.ini di Ansible

Inserire l'indirizzo ip delle istanze EC2

## Comando per eseguire lo script ansible:

cd C:\Users\biond\.aws\aws_k8s_cluster\ansible
ansible-playbook -i inventory.ini playbook.yml