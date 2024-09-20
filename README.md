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

Dopo aver eseguito il playbook, verifichiamo che sia stato creato il nostro nodo

> kubectl get nodes

Ci deve restiruire il Nodo:

- kubernetes-master
