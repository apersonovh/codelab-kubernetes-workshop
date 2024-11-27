**Si besoin de revenir en arrière [⬅️](../README.md)**

## Contexte 📖

J'ai une super idée de produit à lancer ! La boutique des horreurs vestimentaires ! Avec Halloween qui approche ça va faire un carton !  

J'ai développé mon application et préparé des images de conteneur pour les différents composants : `shop-frontend`, `shop-backend` et `shop-database`

Faut que je déploie ça vite et bien, on m'a dit de faire ça sur kubernetes, mais je n'y connais rien !

On m'a filé ce schéma, mais c'est de la magie noire 🔮 pour moi...

![Schéma de l'architecture de l'application](../assets/schema-kube-codelab-base.png)

✂ Commençons par découper ça ✂

![Schéma de l'architecture de l'application](../assets/schema-kube-codelab-base-details.png)

Ok j'y vois déjà un peu plus clair, mais il va falloir y aller petit à petit...

## Cheat sheet 📋

**Selection du projet openshift**
```shell 
oc project <project-name>`
```

**Créé ou configure les ressources décrites dans le fichier yaml**
```shell
kubectl apply -f <fichier.yml>
```

**Supprime les ressources décrites dans le fichier yaml**
```shell
kubectl delete -f <fichier.yml>
```

**Liste les objets Kubernetes**
```shell
kubectl get pods
kubectl get services
kubectl get deployments
```

**Affiche les logs d'un pod**
```shell
kubectl logs <pod-name>
```

## Pratique 👷

1. Sélectionner votre contexte 

```shell
oc project <trigramme>-kata-kubernetes
```

## Le premier `Pod`, c'est par là [➡️](../01-backend-pod/README.md)
