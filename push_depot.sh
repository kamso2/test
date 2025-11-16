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

# Ajouter tous les fichiers modifiés
git add .

# Demander un message de commit
read -p "Message du commit : " commit_msg

# Faire le commit
if [ -z "$commit_msg" ]; then
    echo "❌ Message de commit vide. Abandon."
    exit 1
fi
git commit -m "$commit_msg"

# Récupérer la branche actuelle
current_branch=$(git rev-parse --abbrev-ref HEAD)

# Pousser vers le remote origin
if git push origin "$current_branch"; then
    echo "✅ Modifications poussées avec succès sur la branche '$current_branch' du dépôt distant."
else
    echo "❌ Échec du push. Vérifiez votre connexion ou vos droits sur le dépôt."
fi
