#!/bin/bash

# Vérifier si Git est installé
if ! command -v git &> /dev/null; then
    echo "❌ Git n'est pas installé. Installez-le avec : sudo apt install git"
    exit 1
fi

# Vérifier si le dossier est un dépôt Git
if [ ! -d .git ]; then
    echo "❌ Ce dossier n'est pas un dépôt Git. Faites : git init ou clonez un dépôt."
    exit 1
fi

# Afficher l'état du dépôt
echo "
📌 État actuel du dépôt :"
git status

# Ajouter tous les fichiers modifiés
git add .

# Demander un message de commit
read -p "Message du commit : " commit_msg
if [ -z "$commit_msg" ]; then
    echo "❌ Message de commit vide. Abandon."
    exit 1
fi
git commit -m "$commit_msg"

# Vérifier si un remote origin existe
if ! git remote | grep origin > /dev/null; then
    echo "
⚠️ Aucun remote 'origin' trouvé."
    read -p "Entrez l'URL du dépôt GitHub (HTTPS ou SSH) : " repo_url
    git remote add origin "$repo_url"
fi

# Afficher la liste des branches
echo "
📌 Branches disponibles :"
git branch

# Demander la branche à utiliser
read -p "Nom de la branche à pousser (laisser vide pour utiliser la branche actuelle) : " branch_name
if [ -z "$branch_name" ]; then
    branch_name=$(git rev-parse --abbrev-ref HEAD)
else
    # Créer la branche si elle n'existe pas
    if ! git show-ref --verify --quiet refs/heads/$branch_name; then
        git checkout -b "$branch_name"
    else
        git checkout "$branch_name"
    fi
fi

# Pousser vers le remote origin
if git push -u origin "$branch_name"; then
    echo "
✅ Modifications poussées avec succès sur la branche '$branch_name' du dépôt distant."
else
    echo "
❌ Échec du push. Vérifiez votre connexion ou vos droits sur le dépôt."
fi

