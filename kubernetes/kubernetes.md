----------------------------------------------------------------- What is kubernetes---------------------------------------------------------------------------

>> Kubernetes: Container orchestration tool

>> Features: 

1. High Availability or no downtime
2. Scalability or high performance
3. Disaster recovery - backup and restore


---------------------------------------------------------------- Main k8s components---------------------------------------------------------------------------

>> Nodes & Pods

1. Node is a physical or vm contisting of one or multiple pods
2. Pod is smallest unit of k8s
3. Pod is Abstraction over container
4. Usually 1 application per pod (app may comprise of multiple containers).
5. Each pod gets its own ip address
6. New ip address on re-creation

>> Service & Ingress

a) LoadBalancing
b) Service discovery (Labels & Selectors)
c) External connection

1. Service is permanent ip address that can be attached to a pod
2. Lifecycle of pod and service is not connected
3. Internal service (http://db-service-ip:port) and External service (https://my-app.com)
4. Ingress-  Another k8's sevice where request goes to Ingress instead of service and then forwarded to Service. 
5. Ingress is used to route traffic into cluster and setup external services (IP)

>> configMap & Secret

1. ConfigMap: Contains the external configuration of your application which is connected to POD so that pod gets the data configMap has. ( EX: If username/password changes then rebuild of docker image app can be avoided and the property can be given in ConfigMap as DB_USER = ora19c DB_PWD = password123).
2. Secret: Used to store secret data in encrypted format (base64 encoded), just as ConfigMap we can connect secret to a POD so that POD can see that data and read from secret.
3. We can use data of ConfigMap and Secret from inside the application using environment variable or as property file.

Note: This built-in security mechanism is not enabled by default

>> Data storage

1. Volume: If the Database container or POD gets restarted then data would be gone, So Volume is used in k8's for data persistance.
2. Volume can be on same local machine or on the Node where the POD is running.
3. Volume can be created even on remote that is outside of the k8's cluster.

>> Deployment & Stateful set

1. Deployment: Another componenet of Kubernetes used to create blueprint of pods(replica of existing or running pod). Instead of creating 
		multiple pods for scaling up/down, we will create deployments and specify how many replicas.
2. If one of the replicas of our application pod would die/stop then service will forward the request to another pod.
3. We cannot replicate Database using deployment, because if we have replica of Database then they need to access same shared data storage(volume) and there its not possible to manage which pod is writing or reading data from that storage. So here Stateful set is used.

4. Stateful set: - This component is meant specifically for application like Databases(MySQL, MongoDB).


-------------------------------------------------------------------- Kubernetes Architecture------------------------------------------------------------------

1. Worker machine or Node

--> Each node has multiple Pods on it
--> 3 processes must be installed on every node(Container runtime like docker, Kubelet, kubeproxy)
--> Kubelet: Interacts with both the container and node. It starts the Pod with a container inside.

2. Master Node 

--> 4 processes run on every master node(API server, Scheduler, Controller Manager, etcd)
--> Api server: Is like a cluster gateway & acts as gateway for authentication.
--> Scheduler: It decides on which Node new Pod should be scheduled.
--> Controller Manager: Detects cluster state changes (if pods crash/die it detects that and tries to restore the cluster state by restarting the pods by making request to Scheduler)
--> etcd: Is the key value store where all cluster data or cluster changes is stored(Application is not stored in etcd)

>> Add new Master/Node server
1. get new bare server
2. install all the master/worker node processes
3. add it to the cluster

----------------------------------------------------------- Minikube & Kubectl --------------------------------------------------------------------------------

1. Minikube : Its a 1 Node k8's cluster
--> creates virtual box on your laptop
--> Node runs in that virtual box
--> 1 Node k8's cluster for testing on local machine

2. Kubectl : Command line tool for k8's cluster
--> Minikube runs both Master and worker processes inside a single Node
--> The Master process called API server is main entry point into the k8's cluster.
--> There are ways to communicate to API server using UI, K8's API and kubectl(CLI - most powerful among 3 clients)

3. Installation of Minikube & Kubectl
--> Download kubectl & minikube-linux-amd64 binary
	$sudo install kubectl /usr/local/bin/kubectl
	$sudo install minikube-linux-amd64 /usr/local/bin/minikube

4. Minikube & kubectl commands

$ minikube start - Starts a local k8's cluster
$ minikube status - Show the status of running cluster
$ kubectl get all - Shows all components running in a kubernetes cluster
$ kubectl get nodes - Show all cluster nodes running 
$ kubectl version - Show both client and Server version 
$ kubectl create deployment <name> - Creates deployment
$ kubectl edit deployment <name> - To Edit the deployment
$ kubectl edit pod <name> - To edit the pod config yaml
$ kubectl edit node <name (ex: minikube) - To edit node config yaml
$ kubectl edit replicaset <name> - To edit replicaset config yaml
$ kubectl edit services <service name> - To edit services config yaml
$ kubectl delete deployment <name> - Delete the deployment
$ kubectl get nodes | pod | services | replicaset | deployment
$ kubectl get nodes | pod | services | deployment -o wide
$ kubectl get deployment -o yaml
$ kubectl logs <pod name> - Check logs from console
$ kubectl exec -it <pod name> -- /bin/bash - To enter into the POD
$ kubectl create -h - Help section
$ kubectl describe node | pod | service | deployment <name>
$ kubectl describe node | pod | service | deployment -o wide

5. Create pod with tomcat container

$ kubectl create deployment tomcat-depl --image=tomcat
$ kubectl get deployment
$ kubectl get pods
$ kubectl get replicaset

>> To edit deployment yaml file and change the image version to tomcat:9, Once done tomcat:9 image pod will be created & the old is deleted
$ kubectl edit deployment tomcat

Note:
--> We don't directly create/manage pods instead "deployment" does that for us
--> "kubectl create deployment tomcat-depl --image=tomcat" is blueprint for creating pods
--> Name & Image to use is the most basic configuration needed for deployment and rest is default.
--> Between deployment and pod there is another layer which is automatically managed by k8's deployment called "replicaset"
--> Replicaset is managing the replicas of a POD

Layers of Abstraction:
--> Deployment manages a Replicaset
--> Replicaset manages all the replicas of POD
--> Pod is an abstraction of container

>> To check POD logs and pod additional description/debug 
$ kubectl logs <pod_name>
$ kubectl describe pod <pod_name>
$ kubectl describe pod -o wide - Describe the pod with full info as output
$ kubectl exec -it <pod_name> -- /bin/bash


---------------------------------------------------------- K8's YAML configuration file ---------------------------------------------------------------------

1. Kubernetes Yaml file for deployment (tomcat-deployment.yaml)

apiVersion: apps/v1
kind: Deployment
metadata:
  name: tomcat-deployment
  labels:
    app: tomcatdepl
spec:
  replicas: 1
  selector:
    matchLabels:	     #assigns labels to the pods for future selection
      app: tomcatdepl
  template:
    metadata:
      labels:
        app: tomcatdepl
    spec:
      containers:
        - name: tomcatdepl
          image: tomcat
          ports:
            - containerPort: 8080


2. Run the file using kubectl command to create, delete deployment & pod.

$ kubectl apply -f <file_name.yaml>
$ kubectl get pod
$ kubectl get deployment
$ kubectl delete -f <file_name.yaml>

3. Yaml overview [deployment.yaml vs service.yaml]

>> Each configuration file has 3 parts

	1) metadata
	2) specification
	3) status - automatically created & managed by k8's using info from etcd

>> deployment.yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: tomcat-deployment
  labels: ~~~
spec:
  replicas: 2
  selector: ~~
  template: ~~

>> service.yaml

apiVersion: v1
kind: Service
metadata:
  name: tomcat-service
spec:
  selector: ~~
  ports: ~~

>> Template:
	- Has its own "metadata" and "spec" section
	- applies to Pod
	- blueprint for a Pod (name, image, port)

>> Labels & Selectors & Ports(Connecting Deployment to Pods)
	- Pods get the label through the template blueprint
	- This label is matched by the selector
	- Pods get the label through the template blueprint.
	- The label is matched by the selector


---------------------------------------------------------------- Demo - MongoDB & MongoExpress --------------------------------------------------------------
Overview of K8's component:

>> 2 Deployment / Pod
>> 2 Service
>> 1 ConfigMap
>> 1 Secret

1. Create a configuration file for deployment called mongodb-deployment.yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: mongodb-deployment
  labels:
    app: mongodb
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mongodb
  template:
    metadata:
      labels:
        app: mongodb
    spec:
      containers:
        - name: mongodb
          image: mongo
          ports:
            - containerPort: 27017
          env:
            - name: MONGO_INITDB_ROOT_USERNAME
              valueFrom:
                secretKeyRef:
                  name: mongodb-secret
                  key: mongo-root-username
            - name: MONGO_INITDB_ROOT_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: mongodb-secret
                  key: mongo-root-password


2. Create a Secret using a confiuration file to map with deployment called mongodb-secret.yaml

apiVersion: v1
kind: Secret
metadata:
  name: mongodb-secret
type: Opaque
data:
  mongo-root-username: bW9uZ29kYg==
  mongo-root-password: cGFzc3dvcmQ=


>> This file contains value of username & password in bsae64 encoded
$ echo -n "mongodb" | base64

>> To create secret reference in k8's & run the deployment 
$ kubectl apply -f mongodb-secret.yaml
$ kubectl get secret
$ kubectl apply -f mongodb-deployment.yaml
$ kubectl get pods
$ kubectl get pod --watch
$ kubectl describe pod

3. Create a "Internal service" so that other components or pods can interact with this DB

>> Service configuration file can be created inside the deployment yaml mongodb-deployment.yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: mongodb-deployment
  labels:
    app: mongodb
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mongodb
  template:
    metadata:
      labels:
        app: mongodb
    spec:
      containers:
        - name: mongodb
          image: mongo
          ports:
            - containerPort: 27017
          env:
            - name: MONGO_INITDB_ROOT_USERNAME
              valueFrom:
                secretKeyRef:
                  name: mongodb-secret
                  key: mongo-root-username
	        - name: MONGO_INITDB_ROOT_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: mongodb-secret
                  key: mongo-root-password

---

apiVersion: v1
kind: Service
metadata:
  name: mongodb-service
spec:
  selector:
    app: mongodb
  ports:
    - protocol: TCP
      port: 27017
      targetPort: 27017

>> To check if service is attached to correct pod using enpoint from service description
$ kubectl describe service mongodb-service
$ kubectl get pod -o -wide


4. Mongo-Exproess Deployment, Service & ConfigMap

>> Deployment configuration file for mongo express to connect to MongoDB Address/Internal service & creds to authenticate
>> ConfigMap: 
a. external configuration
b. centralized
c. other components can use it
>> ConfigMap must already be in the K8's cluster when referencing it
>> Database refernce url should be from service configuration file created beforehand for mongodb deployment

>> Create the configMap first by using service.

apiVersion: v1
kind: ConfigMap
metadata:
  name: mongodb-configmap
data:
  database_url: mongodb-service


>> For deployment configuration file

apiVersion: apps/v1
kind: Deployment
metadata:
  name: mongo-express
  labels:
    app: mongo-express
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mongo-express
  template:
    metadata:
      labels:
        name: mongo-express
    spec:
      containers:
        - name: mongo-express
          image: mongo-express
          ports:
            - containerPort: 8081
          env:
            - name: ME_CONFIG_MONGODB_ADMINUSERNAME
              valueFrom:
                secretKeyRef:
                  name: mongodb-secret
                  key: mongo-root-username
            - name: ME_CONFIG_MONGODB_ADMINPASSWORD
              valueFrom:
                secretKeyRef:
                  name: mongodb-secret
                  key: mongo-root-password
            - name: ME_CONFIG_MONGODB_SERVER
              valueFrom:
                configMapKeyRef:
                  name: mongodb-configmap
                  key: database_url


>> Start appliing the yaml file 
$ kubectl apply -f mongodb-configmap.yaml
$ kubectl apply -f mongo-express.yaml
$ kubectl get pod
$ kubectl logs mongo-express-5bf4b56f47-xhdmp



5. Create external service for mongodb to access mongo-express from browser

>> Type of external service will be Loadbalancer which assigns service an external ip address and so accepts external requests
>> nodePort: This port is where external ip address will be open, and can be used to access app from browser
>> Nodeport has a range from 30000 - 32767 and has to in this range only.
>> External service has to be created in deployment config file with type as LoadBalancer
>> The default internal/external service type is ClusterIP.

apiVersion: v1
kind: Service
metadata:
  name: mongo-express-service
spec:
  selector:
    app: mongo-express
  type: LoadBalancer
  ports:
    - protocol: TCP
      port: 8081
      targetPort: 8081
      nodePort: 30000

>> Create the service by applying the config file
$ kubectl apply -f mongo-express.yaml
$ kubectl get service

>> The external service (mongo-express-service) show EXTERNAL-IP as <pending> in minikube (not the case with prod k8's setup)
>> For this we have to execute "minikube service <service_name"
$ minikube service mongo-express-service



-------------------------------------------------------------- KUBERNETES NAMESPACES------------------------------------------------------------------------

1. What is Namespace?

>> In k8's cluster we can organize resources in namespace.
>> Virtual cluster inside a cluster.
>> 4 Namespaces by default:
a). kube-system - Do not create or modify in kube-system, system processes of Master & kubectl 
b). kube-public - Publically accessible data
		- A configmap which contains cluster information
		- $ kubectl cluster-info
c). kube-node-lease - Holds information about heartbeats of node
		    - Each node has associated lease object in namespace
		    - Determine the availability of a node
d). default - Resources created are located here.

2. Create Namespace by using kubectl & config file

$ kubectl get namespace
$ kubectl create namespace my-namespace

apiVersion: v1
kind: ConfigMap
metadata:
  name: mongodb-configmap
  namespace: my-namespace
data:
  database_url: mongodb-service
 
3. Use of Namespace

>> Resources can be grouped in Namespace - Database, Monitoring, Elastic stack, Nginx-Ingress all in different Namespace.
>> To avoid conflict if multiple teams are using same application cluster for deployment
>> Resource sharing for Staging & Development, Ex: Create a resource of Nginx-Igress controller in one cluster & use it for another clusters.
>> Resource sharing for Blue/Green deployment
>> Access and resource limits on Namespaces, by giving team to access to only Namspaces of specific cluster.

4. Characteristics of Namespace.

>> ConfigMap & Secret resources cannot be accessed from another Namespace. 
>> Access Service (Niginx, Elastic search) which are shared resources can be accessed across other Namespaces.
>> Components like volume, persistant volume & node can't be created within a Namespace. They live globally in a cluster & can't be isolated.

5. List all components which are bound & not bound to Namespaces

$ kubectl api-resources --namespaced=false
$ kubectl api-resources --namespaced=true


6. Create components in Namespace (No namespace defined in config file, "default" so default is taken)

$ kubectl create namespace my-namespace

apiVersion: v1
kind: ConfigMap
metadata:
  name: mysql-namespace
  namespace: my-namespace
data:
  db_url: mysql-service.database


$ kubectl apply -f mysql-namespace.yaml
$ kubectl get namespace


7. Change active or default Namespace

>> Install "kubens" tool 
$ sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
$ sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
$ sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens

>> To switch the active namespace

$ kubens my-namespace


------------------------------------------------------------------ K8's Ingress-------------------------------------------------------------------------------

1. External service v/s Ingress & Internal service



>> External service configuration file

apiVersion: v1
kind: Service
metadata:
  name: myapp-external-service
spec:
  selector:
    app: myapp
  type: LoadBalancer
  ports:
    - protocol: TCP
      port: 8080
      targetPort: 8080
      nodePort: 35010



>> Ingress configuration file

a. Host should have valid domain address
b. Map the domain name to Node's IP address, which is the entrypoint.

apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: myapp-ingress
spec:
  rules:
    - host: myapp.com
      htpp:
        paths:
          - backend:
            serviceName: myapp-internal-service
            servicePort: 8080



>> Internal service configuration file 

a. No node port in internal service
b. Type is ClusterIP (default) and not LoadBalancer

apiVersion: v1
kind: Service
metadata:
  name: myapp-internal-service
spec:
  selector:
    app: myapp
  ports:
    - protocol: TCP
      port: 8080
      targetPort: 8080


>> Configure Ingress in cluster

a. Need an implementation for ingress which is Ingress controller pod.
b. Ingress controller:
		
	- Evaluates all the rules defined in cluster
	- Manage all redirection
	- Its the entrypoint of the cluster
	- K8's cluster flow diagram:

my-app POD <------- my-app Service (internal) <-------- my-app Ingress <--------- Ingress controller POD

c. A seperate Proxy server with public IP adress and open ports has to setup as an entrypoint to cluster (Not in case of cloud).
d. In this way No sserver in K8's cluster is accessible from outside.

htpp://myapp.com -------> Proxy server -------> Ingress controller checks ingress rules ------> my-app service


>> Install Ingress controller in Minikube

$ minikube addons enable ingress
$ kubectl get pods -n ingress-nginx

>> Enable kubernetes-dashboard namespace if not enabled by default

$ minikube addons enable dashboard
$ minikube addons enable metrics-server
$ minikube dashboard --url
$ kubectl get ns
$ kubectl get all -n kubernetes-dashboard

2. Configure kubernetes-dashboard as a internal service using Ingress

>> service Name & service Port should be of service on which kubernetes-dashboard is running (kubectl get all -n kubernrtes-dashboard)

apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: dashboard-ingress
  namespace: kubernetes-dashboard
spec:
  rules:
    - host: dashboard.com
      http:
        paths:
          - pathType: Prefix
            path: "/"
            backend:
              service:
                name: kubernetes-dashboard
                port:
                  number: 80


$ kubectl apply -f kubernetes-dashboard.yaml
$ kubectl get ingress -n kubernetes-dashboard
$ kubectl get ingress -n kubernetes-dashboard --watch

>> After IP address is assingned to ingress(kubectl get ingress -n kubernetes-dashboard) the IP has to be appended to /etc/hosts file.

$ echo -e "192.168.49.2 dashboard.com" >> /etc/hosts

>> Open the browser and serch for "dashboard.com"
>> The request will come into minikube cluster will be handed over to ingress controller.
>> Then ingress cotroller will evaluate rules defined in configuration file and forward that request to service.

3. Ingress Default Backend

>> $ kubectl get ingress -n <name-space> - Will have a attribute called "Default backend"
>> Whenever request comes into k8's cluster that is not met to any backend then this default backend is used to handle it.
>> It is used to display custom error message when app url is not hit in browser(ex: dashboard.com/kube)

>> Create an Internal service with default http backend

apiVersion: v1
kind: Service
metadata:
  name: default-http-backend
spec:
  selector:
    app: default-response-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080


4. Path based routing - Multiple paths for same host

>> Same domain with many services.
>> http://myapp.com/analytics - for analytics page
   http://myapp.com/shopping - for shopping page

apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: simple-fanout-example
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
    - host: myapp.com
      http:
        paths:
          - pathType: Prefix
            path: "/"
            backend:
              service:
                name: analytics-service
                port:
                  number: 80
	      - pathType: Prefix
	        path: "/"
            backend:
	          service: 
		        name: shopping-service
		        port:
		          number: 8080
                  
                  
5. Host based routing - Multiple sub-domains or domains

>> Instead of 1 hosts and multiple path, here we have multiple hosts with 1 path.
>> Each host represents a sub-domain
>> http://analytics.myapp.com - for analytics page
   http://shopping.myapp.com - for shopping page


apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: name-virtual-host-ingress 
spec:
  rules:
    - host: analytics.myapp.com
      http:
        paths:
          - pathType: Prefix
            path: "/"
            backend:
              service:
                name: analytics-service
                port:
                  number: 3000
    - host: shopping.myapp.com
        http:
          paths: 
            - pathType: Prefix
              path: "/"
              backend:
                service:
                  name: shopping-service
                  port:
                    number: 8080



6. Configuring TLS certificate - https//.

>> Create a secret config file with tls certificate and key
>> The Data key need to be "tls.crt" and "tls.key"
>> Values are file contents not file paths/location
>> Secret component must be in the same namespace as the ingress component.

apiVersion: v1
kind: Secret
metadata:
  name: testsecret-tls
  namespace: default
type: kubernetes.io/tls
data:
  tls.crt: base64 encoded cert
  tls.key: base64 encoded key

>> Use the secret service with secretName tag

apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: tls-example-ingress
spec:
  tls:
    - hosts:
        - analytics.myapp.com
      secretName: testsecret-tls
  rules:
    - host: analytics.myapp.com
      http:
        paths:
          - pathType: Prefix
            path: "/"
            backend:
              service:
                name: analytics-service
                port:
                  number: 80




------------------------------------------------------------------------- HELM -------------------------------------------------------------------------------

What is HELM ?

>> Package Manager for Kubernetes.
>> Used to package YAML files and distribute them in public and private repositories ( Ex - Elastic stack for Logging)

1. First feature: Helm charts

>> Bundle of YAML files
>> Create own Helm charts with Helm
>> Push them to Helm repository
>> Download and use existing ones.
>> $ helm search <keyword> - To search for helm charts in repo.

2. Second feature: Templating engine

>> Ex- There is a Application made up of multiple microservices and deployed in k8's cluster. Deployment nd service configuration is almost
 same with only different docker image name & version tags so, we would have multiple similar configuration files with some unique tag/value

a) Using Helm we can define a common blueprint for all the dynamic values in the config files.
b) Dynamic values are replaced by placeholder, that would be in a template file (Template file has placeholder)
c) The value of placeholder should be defined in values.yaml file.
d) .Values is an Object which is created based on the values defined.
e) Values defined either via yaml file or with --set flag

>> Conclusion: So, instead of having multiple yaml config files for different microservices. A single values.yaml file with placeholder and multiple template config files fetching values from values.yaml can be created.


Template file:

apiVersion: v1
kind: Pod
metadata:
  name: {{ .Values.name }}
spec:
  containers:
    - name: {{ .Values.containers.name }}
      image: {{ .Values.containers.image }}
      ports: {{ .Values.containers.port }}


values.yaml file:

apiVersion: v1
kind: Pod
metadata:
  name: my-app
spec:
  containers:
    - name: my-app-container
      image: my-app-image
      ports: 9000

3. Helm chart structure - Directory structure

mychart/
  Chart.yaml
  values.yaml
  charts.yaml
  charts/
  templates/
...


mychart folder   ---> Name of chart
Chart.yaml       ---> meta info about chart
values.yaml      ---> values for the template files (default values you can override)
charts folder    ---> chart dependencies
templates folder ---> the actual template files

>> When Helm install command is run, The template files will be filled with the values from values.yaml

$ helm install <chart_name>


4. Release management: Keep track of all chart execution

$ helm install <chart_name>  - Install chart v1.0.0
$ helm upgrade <chart_name>  - Upgrade chart v1.0.1
$ helm rollback <chart_name> - Rollback back to v1.0.0



---------------------------------------------------------------------- K8's Volume-----------------------------------------------------------------------------

>> How to persist data in kubernetes using volume?

a. Persistent Volume (pv)
b. Persistent Volume claim (pvc)
c. Storage class (sc)

>> Srorage requirement:

1. Storage that doesn't depend on the pod lifecycle - Eveytime pod gets restarted data gets deleted from Database pods. So, There has to be a storage that doesn't depend on the pod lifecycle.

2. Srorage must be availaible on all nodes - Whenever pod gets restarted the data is stored and redirected to new pod (any node) SO, storage must be availailble on all nodes.

3. Storage needs to survive even if cluster crashes


1. Persistant volume:

- A cluster resource as RAM or CPU used to store data
- Created via YAML file (kind: PersistentVolume)
- Need actual physical storage like NFS,AWS
- PV are not namespaced and are accessible to whole cluster


apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv
spec:
  capacity:
    storage: 5Gi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Recycle
  storageClassName: slow
  mountOptions:
    - hard
    - nfsvers=4.1
  nfs:
    path: /tmp #dir path on nfs server
    server: 172.17.0.2 #nfs server ip


- Types of Access modes

a. ReadWriteOnce: the volume can be mounted as read-write by a single node, allow multiple pods to access the volume when pods are running on same node.
b. ReadOnlyMany: the volume can be mounted as read-only by many nodes.
c. ReadWriteMany: the volume can be mounted as read-write by many nodes.
d. ReadWriteOncePod: the volume can be mounted as read-write by a single Pod, ensures that only one pod across whole cluster can read that PVC or write to it.


2. PersistentVolumeClaim

- PVC binds are exclusive, and since PVC are namespaced objects, mounting claims with "Many" modes (ROX, RWX) is only possible within one namespace.


apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: myclaim
spec:
  accessModes:
    - ReadWriteOnce
  volumeMode: Filesystem
  resources:
    requests:
      storage: 8Gi
  storageClassName: slow
  selector:
    matchLabels:
      release: "stable"
    matchExpressions:
      - {key: environment, operator: In, values: [dev]}
      
# POD config file with volume attribute

apiVersion: v1
kind: Pod
metadata:
  name: mypod
spec:
  containers:
    - name: myfrontend
      image: nginx
      volumeMounts:
      - mountPath: "/var/www/html" #path inside container where the volume is accessible or mounted. The app can access volume from this path.
        name: mypd
  volumes:
    - name: mypd
      persistentVolumeClaim:
        claimName: myclaim
        


>> Levels of volume abstraction

1. POD requests the volume through the pv claim
2. Claim tries to find a volume in cluster
3. Volume has the actual storage backend.


>> Types of volumes: 
- awsElasticBlockStore
- azureDisk
- azureFile
- cephfs
- configMap

NOTE: ConfigMap and Secret are also volume type. These are local volumes and not created via PV and PVC.


3. Multiple volume types


apiVersion: apps/v1
kind: Deployment
metadata:
  name: elastic
  labels:
    app: elastic
spec:
  replicas: 1
  selector:
    matchLabels:
      app: elastic
  template:
    metadata:
      labels:
        name: elastic
    spec:
      containers:
        - name: elastic-container
          image: elastic:latest
          ports:
          - containerPort: 9200
          volumeMounts:
            - name: es-persistent-storage
              mountPath: /var/lib/data
            - name: es-secret-dir
              mountPath: /var/lib/secret
            - name: es-config-dir
              mountPath: /var/lib/config
        
        volumes:
          - name: es-persistent-storage
            persistentVolumeClaim:
              claimName: es-pv-claim
          - name: es-secret-dir
            secret:
              secretName: es-secret
          - name: es-config-dir
            configMap:
              name: es-config-map


4. Storage class

>> Storage class provisions persistent volumes dynamically, when pvc claims it.
>> SC can be created as a config file.
>> StorageBackend is defined in the SC component via "provisioner" attribute.
>> Internal provisioner - "kubernetes.io" and External provisioner - "aws-ebs"
>> configure parameters for storage we want to request for PV.

apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: storage-class-name
provisioner: kubernetes.io/aws-ebs
parameters:
  type: io1
  iopsPerGB: "10"
  fsType: ext4


apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mypvc
spec:
  accessModes:
    - ReadWriteOnce
  volumeMode: Filesystem
  resources:
    requests:
      storage: 100Gi
  storageClassName: storage-class-name



------------------------------------------------------------------ K8's Statefulset---------------------------------------------------------------------------

1. What is statefulset ?

>> A kubenetes component which is used specifically for stateful application (ex - Databases like mySql, Oracle).
>> As stateless application are deployed using Deployment, the stateful application are deployed using StatefulSet.

2. Deployment vs StatefulSet

>> Replicating stateful application is more difficult.
>> Can't be deleted/created at same time 
>> can't be randomly addressed
>> replica Pods are not identical. 

3. Pod Identity

- Sticky(fixed order) identity for each pod.
- created from same specification, but not interchangeable.
- persistent identifier across any re-scheduling.


4. Why is identity necessary - Scaling database application.

- If one DB is used for readring and writing data, then another DB is introduced will result in data inconsistency.
- So, There is a mechanism that decides only one pod is allowed to write/change data and reading at same time.
- The POD that is allowed to write or change data is called MASTER.
- The other PODS which are only allowed to read data are called Slaves or Worker nodes.
- These pods do not have access to same physical storage, even though they use same data.
- They each have their own replicas of storege that each one can access for itself.
- Data synchronization: Master has access to write db, so Worker pods should update their db taking Master as reference.
- When a new worker pod joins, it clones data from previous (not any pod, but always previous one) for continous synchronization.
- Data will survive even when all Pods die, as all data is stored in PV.
- Next pod is only created, if previous is up and running.
- Delete Statefulset or scale down to 1 replica happens in reverse order starting from last one.


5. POD State

- When a pod is rescheduled on another Node, the data should be accessible across all nodes for the pod to read.
- So, Remote storage has to be made availaible for other nodes to access the data.


apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mysql
spec:
  serviceName: mysql
  replicas: 3
  selector:
    matchLabels:
      app: mysql
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
      - name: mysql
        image: mysql:5.7
        ports:
        - containerPort: 3306
        env:
        - name: MYSQL_ROOT_PASSWORD
          value: password
        volumeMounts:
        - name: mysql-persistent-storage
          mountPath: /var/lib/mysql
  volumeClaimTemplates:
  - metadata:
      name: mysql-persistent-storage
    spec:
      accessModes: [ "ReadWriteOnce" ]
      resources:
        requests:
          storage: 1Gi


-------------------------------------------------------------------- K8's Services-------------------------------------------------------------------------

What is service and When we need it?

>> Each Pod has it's own IP address, but POD's are ephemeral (are destroyed frequently when Pod is restarted)
>> Service: 
- Provides stable IP address
- Proivdes LoadBalancing
- Loose coupling within & outside cluster.

1. ClusterIP Service:

>> Default type of IP when type not specified
>> To check IP address of a pod in a cluster 
$ kubectl get pod -o wide 

- Service communication: "Selector" (Which pods to forward the request to?)

>> Pods are identified via "selectors" attribute defined as key value pair from yaml config file
>> These key value pairs are labels the pod should have to match the selector.
>> key value pairs under metadata are arbitory (random)
>> The deployment configuration metadata label should be matched with service selector.

- Service communication: port (Which port to forward the request to?)

>> If multiple ports are open in pod, then its picked by "targetPort" attribute defined in yaml.
>> Service port can be arbitary, but "targetPort" must match the port container is listening.
>> If multiple ports are defined in config file then it has to be named.

2. Headless Service - (clusterIP is defined as None in config file)

>> Client or another POD wants to communicate with 1 specific pod directly without going through service.
>> Use cases: Stateful application like databases mysql, mongodb.
>> Here, POD replicas are not identical
Ex:  In mysql: Master is only allowed too write to DB and Worker pods has to connect to Master to synchronize data. When new worker pod starts it should connect to most recent worker node to clone the data.

>> Client needs to figure out IP address of each POD.
Option 1: API call to k8's API server
- makes app too tied to k8's API
- inefficient

Option 2: DNS Lookup
- DNS Lookup for Service - returns single IP address (ClusterIP)
- Set ClusterIP to "None" - returns POD IP address instead


apiVersion: v1
kind: Service
metadata:
  name: mongo-service-headless
spec:
  clusterIP: None
  selector:
    app: mongodb
  ports:
    - protocol: TCP
      port: 8081
      targetPort: 8081

3. Three types of Service attributes

a). ClusterIP 

>> DEFAULT, type not needed
>> internal service
>> No access to external traffic, only accessible within cluster.

apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  type: ClusterIP


b). Nodeport

>> Creates a service that is accessible on a static port on each worker node in a cluster.
>> External traffic has access to fixed port on each worker node. (ex - http://ip-adress-of-worker-node:nodePort)
>> nodePort attribute has a range of 30000-32767
>> When Nodeport is created ClusterIP is also created automatically where nodeport will direct to.

apiVersion: v1
kind: Service
metadata:
  name: my-service-nodeport
spec:
  type: Nodeport
  selector:
    app: microservice-one
  ports:
    - protocol: TCP
      port: 3200
      targetPort: 3000
      nodePort: 30008

c). LoadBalancer

>> Secure compared to Nodeport
>> Become accessible externally through cloud providers LoadBalancer.
>> When LoadBalancer is created ClusterIP & Nodeport is also created automatically


apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  type: LoadBalancer
  selector:
    app: microservice-one
  ports:
    - protocol: TCP
      port: 3200
      targetPort: 3000
      nodePort: 30008
	  
      
      
----------------------------------------------------------- KUBERNETES SECURITY (RBAC) ----------------------------------------------------------------------

1. Create user with limited namespace access.

Roles:

Roles define a set of permissions (verbs) for specific resources (API groups, resources, and namespaces) within the cluster. For example, a Role might grant read, write, or delete permissions for Pods in a specific namespace.


RoleBindings:

RoleBindings associate users, groups, or service accounts with Roles, specifying which permissions they have for the specified resources. For example, a RoleBinding might associate a user named "admin" with a Role that grants full control over Pods in a namespace.


ClusterRoles:

ClusterRoles are similar to Roles but apply cluster-wide instead of being namespace-specific. They define permissions for cluster-level resources and operations, such as nodes, namespaces, and custom resources.


ClusterRoleBindings:

ClusterRoleBindings associate users, groups, or service accounts with ClusterRoles, specifying which permissions they have across the entire cluster.



# Example Role definition (roles.yaml)
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: my-namespace
  name: pod-reader
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "watch", "list"]

---

# Example RoleBinding definition (rolebindings.yaml)
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  namespace: my-namespace
  name: read-pods
subjects:
- kind: User
  name: alice
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io
  
  
  
# Example ClusterRole definition (clusterrole.yaml)
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: pod-reader
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "watch", "list"]

---

# Example ClusterRoleBinding definition (clusterrolebinding.yaml)
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: read-pods
subjects:
- kind: User
  name: alice
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io

  
  
--> The Role named "pod-reader" grants permissions to read (get, watch, list) Pods within the "my-namespace" namespace.
--> The RoleBinding named "read-pods" binds the "pod-reader" Role to the user "alice" within the "my-namespace" namespace.



Service Account(USER) --> Role(PERMISSION) & Cluster Role --> Role binding (Binding role to user) & Cluster role binding


-------------------------------------------------------------- k8's COMMANDS --------------------------------------------------------------------------

$ minikube start

$ minikube status 

$ kubectl get all 

$ kubectl get nodes 

$ kubectl version 

$ kubectl create deployment <name> 

$ kubectl edit deployment <name> 

$ kubectl edit pod <name> 

$ kubectl edit node <node_name> 

$ kubectl edit replicaset <name>

$ kubectl edit services <service name>

$ kubectl delete deployment <name>

$ kubectl get nodes | pod | services | replicaset | deployment

$ kubectl get nodes | pod | services | deployment -o wide

$ kubectl get deployment -o yaml

$ kubectl logs <pod name> 

$ kubectl exec -it <pod name> -- /bin/bash

$ kubectl create -h

$ kubectl describe node | pod | service | deployment <name>

$ kubectl describe node | pod | service | deployment -o wide

$ kubectl create deployment tomcat-depl --image=tomcat

$ kubectl get deployment

$ kubectl get pods

$ kubectl get replicaset

$ kubectl edit deployment tomcat

$ kubectl logs <pod_name>

$ kubectl describe pod <pod_name>

$ kubectl describe pod -o wide

$ kubectl exec -it <pod_name> -- /bin/bash

$ kubectl apply -f mongodb-configmap.yaml

$ kubectl apply -f mongo-express.yaml

$ kubectl get pod

$ kubectl logs mongo-express-5bf4b56f47-xhdmp

$ kubectl apply -f mongo-express.yaml                                               

$ kubectl get service

$ minikube service mongo-express-service

$ kubectl api-resources --namespaced=false

$ kubectl api-resources --namespaced=true

$ kubectl get namespace

$ kubectl create namespace my-namespace

$ kubectl get ingress -n kubernetes-dashboard

$ kubectl get ingress -n kubernetes-dashboard --watch


------------------------------------------------------------- Kubernetes Interview ----------------------------------------------------------------------
1. DaemonSet:

DaemonSet that ensures that a specific Pod runs on every node in the cluster.

apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: my-daemonset
spec:
  selector:
    matchLabels:
      app: my-daemon
  template:
    metadata:
      labels:
        app: my-daemon
    spec:
      containers:
      - name: my-daemon-container
        image: my-daemon-image:latest
		
		

2. Rollout:

In Kubernetes (k8s), a rollout refers to the process of updating or modifying a Deployment, StatefulSet, DaemonSet, or ReplicaSet by managing the creation, scaling, and termination of its associated Pods. The rollout process ensures that the desired state of the workload is achieved gradually and without disruption to the availability of the application.

apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 10
  selector:
    matchLabels:
      app: nginx
  ​​strategy: 
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
     —name: nginx
        image: nginx:1.14.2
        ports:
       —containerPort: 80
	   
	   

kubectl describe pod <POD_NAME>

kubectl logs <POD_NAME>

kubectl get all -A

kubectl get pods -o wide

kubectl edit svc <svc_name> 