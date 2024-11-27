**Si besoin de revenir en arrière [⬅️](../06-backend-autoscaler/README.md)**

## Contexte 📖

Ça fait quand même beaucoup de fichiers yaml à maintenir en cohérence...  

J'ai entendu parler de `Helm` en conférence technique l'autre jour, est-ce que ça pourrait nous aider ?  

Mettons en place un `Chart Helm` pour déployer notre application ! 🚀  

## Concept 🎨

`Helm` est un outil qui permet de gérer des `Charts` pour déployer des applications sur Kubernetes.  
C'est un package manager pour Kubernetes.  
Un `Chart` est un ensemble de fichiers `yaml` configurable via l'usage de `templates`  
Un `Chart` est composé de plusieurs fichiers :  
  * `Chart.yaml` : informations sur le `Chart` (nom, version, description, dépendances...)  
  * `values.yaml` : configurations par défaut pour les templates    
  * `templates/` : répertoire contenant les templates `yaml`  

Les templates utilisent la syntaxe `Go` pour les variables et les conditions.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Values.name | default "appname" }}
  labels:
    {{- toYaml .Values.matchLabel | nindent 4 }}
spec:
  replicas: {{ .Values.replicas }}
  selector:
    matchLabels:
      {{- toYaml .Values.matchLabel | nindent 6 }}
  template:
    metadata:
      labels:
        {{- toYaml .Values.matchLabel | nindent 8 }}
    spec:
      containers:
        - name: {{ .Values.name | default "appname" }}
          image: {{ .Values.image }}
          ports:
            - containerPort: {{ .Values.port }}
          resources:
            {{- toYaml .Values.resources | nindent 12 }}
```

Le déploiement d'un `chart` Helm créé une `release` Helm, portant sa propre configuration et cycle de vie.  

Les `releases` Helm permettent de gérer l'atomicité de la solution et offrent une capacité de rollback de l'ensemble de la solution.  

Les `charts` Helm peuvent déployés depuis un dossier ou être stockés dans un `repository` Helm pour être partagés et réutilisés.  

## Cheat Sheet 📋

**Ajout d'un repository Helm**
```bash
helm repo add <repo-name> <repo-url>
```

**Liste des repositories Helm**
```bash
helm repo list
```

**Installation d'un Chart Helm distant**
```bash
helm upgrade --install --values values.yaml <release-name> <repo-name>/<chart-name>
```

**Installation d'un Chart Helm local**
```bash
helm upgrade --install --values values.yaml <release-name> <repo-dir>
```

**Liste des releases Helm**
```bash
helm list
```

## Pratique 👷

1) Explorer le dossier `07-helm/chart/shop-app`
  * `Chart.yaml` : informations sur le `Chart`
  * `values.yaml` : configurations par défaut pour les templates
  * dossier `templates/` : contient les templates `yaml`

2) Modifier le fichier `07-helm/chart/shop-app/values.yaml` pour changer le hostname de l'ingress

3) Supprimer les anciennes ressources créées
```shell
kubectl delete -f 03-frontend-deployment/deploy-frontend.yaml
kubectl delete -f 04-exposition/exposition.yaml
kubectl delete -f 05-database/database.yaml
kubectl delete -f 05-database/backend.yaml
kubectl delete -f 06-backend-autoscaler/hpa-backend.yaml
kubectl delete pvc --all
```

4) Déployer le chart `shop-app` local avec Helm
```shell
cd 07-helm/chart/shop-app
helm upgrade --install shop-app-release-local .
```

5) Vérifier que la `release` a bien été créé
```shell
helm list
```

6) Vérifier que le déploiement a bien été effectué
```shell
kubectl get all
```

7) Supprimer la `release` Helm
```shell
helm delete shop-app-release-local
```

8) Créer un fichier `my-values.yaml` pour personnaliser les valeurs du `Chart` (exemple changement du nom d'un composant)

9) Installer la `release` Helm depuis le repository distant avec des valeurs personnalisées (changement de nom par exemple)
```shell
helm repo add workshop https://gitlab.com/api/v4/projects/61280261/packages/helm/stable
helm upgrade --install --values my-values.yaml shop-app-release-dist workshop/shop-app-openshift
```

10) Vérifier que la `release` a bien été créé
```shell
helm list
```

11) Vérifier que le déploiement a bien été effectué
```shell
kubectl get all
```

## Nous voilà prêts pour l'échéance ! ✨
