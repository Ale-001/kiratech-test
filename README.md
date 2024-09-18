# kiratech-test

 Cluster Kubernetes

## Infrastruttura

Sono state create 3 VM all'interno di Virtual Box.

1. **Distribuzione**:

    La scelta della distribuzione utilizzata per la creazione del cluster è ricaduta su CentOS Stream 9 che attualmente offre una distribuzione stabile e in continuo aggiornamento, dato che recentemente CentOS verso il mese di giugno non è più supportata negli aggiornamente.
    La scelta di questa distribuzione è stata fatta perchè rispecchia maggiormente un'ambiente aziendale che di fatto usano distribuzioni Red Hat Enterprise Linux (RHEL).
    Questo significa che si riesce a beneficiare di una piattaforma stabile, ma che riceve aggiornamenti e correzioni prima della versione definitiva di RHEL, garantendo un ambiente più moderno e testato.

2. **Compatibilità e Supporto per Kubernetes**:

    CentOS è noto per la sua stretta compatibilità con RHEL, che è ampiamente utilizzato nelle infrastrutture enterprise e in ambienti Kubernetes.

3. **Gratuità e Accessibilità**:

    Essendo una distribuzione gratuita, CentOS Stream 9 ti offre tutte le funzionalità di un ambiente di livello enterprise senza i costi a una licenza RHEL, il che risulta ideale per fare testing, sviluppo e sperimentazione.

4. **Gestione e Sicurezza Avanzata**:

    Con CentOS Stream 9, hai accesso a strumenti di gestione avanzati e patch di sicurezza regolari, il che rende il sistema una scelta sicura e gestibile per scenari di sviluppo su VirtualBox.

Alle VM è stato impostato corrispettivamente un ip statico e la scheda di rete è stata impostata per far si che possano comunicare tra di loro.

**Indirizzi ip**:

- kubernetes-master: 192.168.1.120
- kubernetes-worker1: 192.168.1.121
- kubernetes-worker2: 192.168.1.122
