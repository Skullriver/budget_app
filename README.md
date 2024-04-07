# Projet individuel

`Alina Novikova`  

`alina.novikova@etu.sorbonne-universite.fr`

`Master 2 STL UE TPALT - Sorbonne Université`

`Mars 2024`

# SophistiSpend

SophistiSpend est une application de gestion budgétaire développée à l'aide de Swift pour les appareils iOS. Il permet aux utilisateurs de suivre leurs revenus, dépenses et transferts entre portefeuilles, les aidant ainsi à gérer efficacement leurs finances.

## Features

- **Suivi des revenus** : enregistrez facilement vos sources de revenus et suivez vos revenus totaux.
- **Gestion des dépenses** : catégorisez et surveillez vos dépenses pour mieux comprendre vos habitudes de dépenses.
- **Gestion de portefeuille** : créez et gérez plusieurs portefeuilles pour organiser efficacement vos fonds.
- **Transferts** : transférez facilement des fonds entre vos portefeuilles avec des enregistrements de transactions détaillés.
- **Visualisation des données** : visualisez vos données financières à l'aide de tableaux et de graphiques intuitifs pour de meilleures informations.

## Architecture

L'application est construite à l'aide du modèle d'architecture MVVM (Model-View-ViewModel), offrant une séparation claire des préoccupations et améliorant la maintenabilité. SwiftUI est utilisé pour le développement frontend, interagissant avec un backend Go qui communique avec une base de données PostgreSQL.
