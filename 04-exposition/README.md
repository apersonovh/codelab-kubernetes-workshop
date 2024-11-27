**Si besoin de revenir en arrière [⬅️](../03-frontend-deployment/README.md)**

## Contexte 📖

C'est bien ton histoire mais comment j'accède à mon appli ?  

On va voir comment exposer les composants en interne et en externe du cluster. avec les `Services` et les `Routes`.  

![Schéma de l'etape 3.1](../assets/schema-kube-codelab-etape-3.1.png)

## Concepts 🎨

Un `Service` est un objet Kubernetes qui permet d'exposer un ensemble de `Pods` en interne du cluster.  
Il se base sur un selecteur de labels pour cibler l'ensemble de pods à exposer.  
Il permet de gérer la résolution de nom DNS, le load balancing entre les `Pods` et le port-forwarding.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: appname
spec:
  type: ClusterIP
  selector:
    app: appname
  ports:
  - port: 8080
    targetPort: 8080
```

La section `metadata` permet de définir le nom du `Service`.  
La section `spec` permet de définir les caractéristiques du `Service` :  
  * `type` : type d'exposition du service  
    * `ClusterIP` : expose le `Service` en interne du cluster, c'est le type par défaut et le plus utilisé.  
    * `NodePort` : expose le `Service` sur un port fixe de chaque noeud du cluster, difficile à utiliser et maintenir.  
    * `LoadBalancer` : expose le `Service` sur un port fixe et provisionne un `LoadBalancer` externe, dépend de l'implémentation du cluster Kubernetes sous-jacent.  
    * `ExternalName` : permet de matérialiser une URL externe vers un `Service`.  
  * `selector` : permet de définir quels `Pods` sont gérés par le `Service`.  
  * `ports` : permet de définir les ports exposés par le `Service` et le port-forwarding entre les `Pods` et le `Service`.  
    * `port` : port du `Service`.  
    * `targetPort` : port du `Pod`.    

Une `Route` est un objet OpenShift qui permet d'exposer un `Service` en externe du cluster.  
Il permet de choisir quelles URL sont exposées et de gérer le routage des requêtes vers les `Services` correspondants à l'instar d'un reverse proxy ou d'une VIP.  

```yaml
apiVersion: route.openshift.io/v1
kind: Route
metadata:
  name: appname
spec:
  host: myapp.exmaple.com
  path: /
  port:
    targetPort: 8080
  tls:
    insecureEdgeTerminationPolicy: Redirect
    termination: edge
  to:
    kind: Service
    name: appname
```

La section `metadata` permet de définir le nom de la `Route`.
La section `spec` permet de définir les caractéristiques de la `Route` :  
  * `host` : URL à exposer.  
  * `path` : chemin de l'URL à exposer.  
  * `port` : permet de définir le port du `Service` à exposer.  
  * `tls` : permet de définir les paramètres de sécurité de la `Route`.  
    * `insecureEdgeTerminationPolicy` : permet de définir la politique de terminaison des connexions non sécurisées.  
    * `termination` : permet de définir le type de terminaison des connexions sécurisées.  
  * `to` : permet de définir le `Service` à exposer.  

En dehors d'OpenShift on utilise plutôt un objet `Ingress` qui a globalement les mêmes fonctionnalités.

## Cheat Sheet 📋

* Astuce : taper `Service` dans un fichier `.yaml` sur dans VS Code permet de récupérer un template.

![Service Helper 1](../assets/service-helper-vscode-1.png)

![Service Helper 2](../assets/service-helper-vscode-2.png)

* Astuce : Il n'existe pas de helper pour créer des manifests yaml de `Route` dans l'extension VS Code, réutilisez l'exemple ci-dessus comme base.  

* Astuce : il est possible de séparer plusieurs fragments de `yaml` dans un seul fichier en utilisant `---` comme séparateur.

## Pratique 👷

1) Créez un fichier `exposition.yaml` et créez un `Service` :  
    * nommé `shop-backend-service`  
    * ciblant les `Pods` identifiés par le label `app: shop-backend-label`  
    * exposant le port `8080` du `Pod` sur le port `8080` du `Service`


2) Dans le même fichier, créez un deuxième `Service` :  
    * nommé `shop-frontend-service`  
    * ciblant les `Pods` identifiés par le label `app: shop-frontend-label`  
    * exposant le port `8080` du `Pod` sur le port `8080` du `Service`


3) Dans le même fichier, créez une `Route` :  
    * nommé `shop-backend-route`  
    * utilisant le `host` : `<trigramme>-devshop.apps.ocp4.innershift.sodigital.io` (remplacer `<trigramme>` par votre trigramme)
    * exposant le port `8080` du `Service` nommé `shop-backend-service` sur le chemin `/api`  


4) Dans le même fichier, créez une `Route` :
    * nommé `shop-frontend-route`
    * utilisant le `host` : `<trigramme>-devshop.apps.ocp4.innershift.sodigital.io` (remplacer `<trigramme>` par votre trigramme)
    * exposant le port `8080` du `Service` nommé `shop-frontend-service` sur le chemin `/`


5) Déployer les `Services` et les `Routes`
```shell
kubectl apply -f exposition.yaml
```

6) Vérifier le statut des `Services`
```shell
kubectl get svc
```

7) Vérifier le statut des `Routes`
```shell
kubectl get route
```

8) Tester l'accès à l'application depuis un navigateur : `https://<trigramme>-devshop.apps.ocp4.innershift.sodigital.io/` (remplacer `<trigramme>` par votre trigramme)  

## Les données sont bien statiques, on passe à la base de données ? [➡️](../05-database/README.md)
