# kiratech-test

 Cluster Kubernetes

## Infrastruttura

Sono state create 3 VM all'interno di Virtual Box.

1. **Distribuzione**:

    La scelta iniziale è ricaduta su CentOS Stream 9 per la creazione del cluster, poiché offriva una distribuzione stabile e in continuo aggiornamento, siccome più recente. Tuttavia, dopo diverse prove, ho riscontrati molti problemi di incompatibilità nell'uso dei playbook Ansible per la configurazione del cluster Kubernetes. Questo mi ha portato ad optare per CentOS 7, che è ampiamente supportato e compatibile con i tool necessari.

    CentOS 7 offre una base consolidata e ampiamente adottata in ambiente enterprise, con una vasta documentazione e community di supporto. Anche se più datata rispetto alla Stream 9, questa versione garantisce stabilità e compatibilità, soprattutto per quanto riguarda l'uso di strumenti come Ansible e Kubernetes.
    La scelta di questa distribuzione è stata fatta perchè rispecchia maggiormente un'ambiente aziendale che di fatto usano distribuzioni Red Hat Enterprise Linux (RHEL).

    I problemi riscontrati sono causati dall'incompatibilità dell'installazione del cluster kubernetes con il playbook trovato.
    CentOS 7 supporta Docker come runtime principale per i container, ed è ben integrato nei playbook tradizionali per Kubernetes.
    CentOS Stream 9 ha abbandonato il supporto a Docker  Questo implica che i playbook devono essere modificati per rimuovere Docker e configurare containerd come runtime predefinito per i container. Inoltre, i comandi e le configurazioni relativi a Docker non funzionano più su CentOS Stream.

2. **Compatibilità e Supporto per Kubernetes**:

    CentOS 7 è noto per la sua compatibilità con i tool di orchestrazione come Kubernetes e per essere un ambiente largamente utilizzato in infrastrutture enterprise.
    Inoltre CentOS è noto per la sua stretta compatibilità con RHEL, che è ampiamente utilizzato nelle infrastrutture enterprise e in ambienti Kubernetes.

3. **Gratuità e Accessibilità**:

    Essendo una distribuzione gratuita, CentOS Stream 9 come CentOS7 ti offre tutte le funzionalità di un ambiente di livello enterprise senza i costi a una licenza RHEL, il che risulta ideale per fare testing, sviluppo e sperimentazione.

4. **Gestione e Sicurezza Avanzata**:

    Anche se meno aggiornata della Stream 9, CentOS 7 continua a ricevere aggiornamenti di sicurezza regolari e offre strumenti avanzati per la gestione del sistema, rendendolo una scelta solida e sicura per l'ambiente di sviluppo.

## Progetto

Alle VM è stato impostato corrispettivamente un ip statico e la scheda di rete è stata impostata per far si che possano comunicare tra di loro.

**Indirizzi ip**:

- kubernetes-master:  192.168.1.110
- kubernetes-worker1: 192.168.1.111
- kubernetes-worker2: 192.168.1.112

Per far si che le VM comunicassero tra di loro, è stata creata una entry per la risoluzione dei nomi nel percorso **/etc/hosts** su ogni VM.

>192.168.1.110 kubernetes-master.net kubernetes-master <br>
192.168.1.111 kubernetes-worker1.net kubernetes-worker1
<br>
192.168.1.112 kubernetes-worker2.net kubernetes-worker2

Dopo proviamo a fare il ping per vedere le VM sono raggiungibili tra di loro.

Per la creazione del cluster si è fatto affidamento al seguente repository dopo aver studiato e analizzato il codice fornito.
In partical modo i playbook di ansible.

---

Installiamo Git per scaricare il repository

>git clone <https://github.com/learnitguide/kubernetes-and-ansible.git>

Con il comando impostiamo lo static hostname:

> hostnamectl set-hostname kubernetes-name

Successivamente entriamo e impostiamo le variavili anche all'interno del nostro repo kubernetes-and-ansible con **cd kubernetes-and-ansible\centos** entriamo nella directory impostiamo l'ip della nostra VM kubernetes-master e delle nostre kubernetes-worker nei seguenti file:

- hosts
- env_variables

### Chiavi ssh

Generiamo una chiave ssh sulla nostra VM kubernetes-master

Una volta creata andiamo a creare con **ssh** una chiave pubblica e una privata, e andiamo a inserire la chiave pubblica all'interno del percorso **/root/.ssh/authorized_keys** , quest'ultimo punto lo facciamo anche per le altre vm, in maniera tale da poter accedere in maniera da avere una connessione sicura tra le nostre vm.

---

Una volta fatto possiamo eseguire il playbook settingup_kubernetes_cluster.yml

Con il comando:

> ansible-playbook settingup_kubernetes_cluster.yml

[settingup_kubernetes_cluster.yml](../kubernetes-and-ansible/centos/settingup_kubernetes_cluster.yml)

Questo primo playbook, esegue tre playbook differenti:

```yml
- import_playbook: playbooks/prerequisites.yml
- import_playbook: playbooks/setting_up_nodes.yml
- import_playbook: playbooks/configure_master_node.yml
```

---

### prerequisites.yml

Questo playbook è progettato per essere eseguito su tutti i nodi con l'obiettivo di disabilitare lo swap
Lo swap è uno spazio di memoria su disco utilizzato dai sistemi operativi per estendere la capacità della RAM.
Serve per rendere più efficienti le risorse e per evitare di sovracaricare la memoria ram e il sistema.

[prerequisites.yml](../kubernetes-and-ansible/centos/playbooks/prerequisites.yml)

---

### setting_up_nodes.yml

Questo playbook si occupa di configurare un nodo per Kubernetes, installando i pacchetti necessari, configurando i repository e gestendo le impostazioni del firewall.
Inoltre vengono configurate le variabili come: packages, services, e ports che verranno utilizzate nel playbook.

[setting_up_nodes.yml](../kubernetes-and-ansible/centos/playbooks/setting_up_nodes.yml)

---

### configure_master_node.yml

Questo playbook si occupa di configurare e inizializzare un nodo master in un cluster Kubernetes.

[configure_master_node.yml](../kubernetes-and-ansible/centos/playbooks/configure_master_node.yml)

---

Dopo aver eseguito il playbook, verifichiamo che sia stato creato il nostro nodo

> kubectl get nodes

Ci deve restiruire il Nodo:

- kubernetes-master

Successivamente eseguiamo il playbook:

> ansible-playbook join_kubernetes_workers_nodes.yml

[join_kubernetes_workers_nodes.yml](../kubernetes-and-ansible/centos/join_kubernetes_workers_nodes.yml)

E verifichiamo che siano stati creati correttamente anche i nodi dei worker

> get nodes

Ora che abbiamo creato il nostro cluster, proviamo a fare il deploy di un container apache

> kubectl apply -f httpd-deployment.yml

[httpd-deployment.yml](../kubernetes-and-ansible/centos/httpd-deployment.yml)

Con il seguente comando possiamo visionare i nostri deploy:

> kubectl get deploy

Mentre se vogliamo visionare nel dettaglio i nostri pods creati, usiamo il seguente comando:

> kubectl get pods

Se vogliamo avere maggiori informazioni dei nostri pods, come ad esempio visionare su che nodo sono o l'indirizzo ip, usiamo il comando:

> kubectl get pods -o wide

Per verificare se il nostro server-apache è raggiungibile possiamo vedere se tramite comando, la porta di apache è la 80:

> curl indirizzo-ip:porta

Nel mio laboratorio mi ha restituito:

```html
<html><body><h1>It works! </h1></body></html>
```

In questo primo laboratorio, mi sono focalizzato sul capire cosa fosse kubernetes e come quest'ultimo permettesse di orchestrare i container (pod) creati.

Sono state riscontrate molte difficoltà in particolar modo dal punto di vista di tool come ansible che non avevo mai approfondito e visto.

## In progress

Attualmento sto provando a ricrearlo anche su Fedora
