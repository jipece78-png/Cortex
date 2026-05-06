# CORTEX© 1980 : Composition Rédactionnelle de TEXTE

======================================================================
## 🖋️ PRÉFACE DE JÉRÔME CHAILLOUX
======================================================================

> "La thèse CORTEX reste pour moi un excellent souvenir, à une époque où la PAO balbutiait encore sur TRS-80, entre contraintes mémoire, Z80 et sorties imprimantes non graphiques.
> Quel travail ! C'est Roberto et 'l'Histoire' qui vont être contents."
>
> — **Jérôme Chailloux** (Père de VLISP, créateur du langage Le-Lisp)

======================================================================
## 🛰️ PROLOGUE 2026 : UNE BALISE TEMPORELLE
======================================================================

Ce dépôt constitue une **"balise temporelle"** ouverte en 2026 pour l'archivage patrimonial (**Software Heritage / UNESCO**). Il documente la genèse de **CORTEX**, une innovation majeure de la micro-informatique française des années 80.

### 🚀 Points Clés & Innovation (SEO)
*   **Pionnier de la PAO :** Transition historique entre la typographie traditionnelle et l'édition sur écran (**WYSIWYG primitif**).
*   **Ingénierie de pointe :** Pilotage d'une **IBM Selectric** (boule) via un processeur **Zilog Z80** (4300H) et une interface **PPI 8255**.
*   **Symbiose Matérielle :** Collaboration entre l'informatique théorique (Paris VIII), l'électronique discrète et la mécanique de précision (Platine réalisée par un **Meilleur Ouvrier de France**).
*   **Héritage :** Préservation du savoir-faire face à l'obsolescence, du code assembleur aux algorithmes de mise en page.

---

## Système de Composition et Révision de Textes et mise en page sur imprimante à boule IBM
**Archéologie Informatique & Ingénierie de la Contrainte**

---
Note de lecture : > * Pour une lecture optimale de cette archive hors-ligne, utilisez un éditeur compatible Markdown (comme VS Code ctrl maj V) ou Obsidian).

Les listings sources sont au format texte brut, pdf(complet) et asm au choix encodés en UTF-8 pour garantir la pérennité des commentaires. 
==========================================================================

### 1. Informations Générales
* **Conception et Développement :** Jean-Pierre Castejon (Maîtrise informatique, niveau Doctorat)
* **Conseil Scientifique / Mentorat :** Jérôme Chaillou
* **Plateforme :** Radio-Shack TRS-80 (48K RAM) & IBM Selectric 71 (Boule)
* **Statut :** Archivage complet effectué en 2026 pour CORTEX© 1980 
 
---

### 2. Introduction Historique
CORTEX 1980 © est une station précurseur PAO pionnière développée entre 1979 et 1980. Conçue pour transformer un micro-ordinateur TRS-80 en une unité de composition professionnelle, elle permettait de s'affranchir des limites des bandes perforées grâce à une édition directe sur écran (**WYSIWYG primitif**) avant l'impression en 1980.

---

### 3. "La Maîtrise" : Une Ingénierie Hybride
Le projet repose sur une symbiose unique entre le code machine et la mécanique de haute précision :

* **Couplage Matériel (Hardware) :** Pilotage de 11 électro-aimants via une interface 8255 (PPI).
* **Précision MOF :** La platine de fixation des électro-aimants a été réalisée sur mesure par un **Meilleur Ouvrier de France** ajusteur, garantissant l'alignement micrométrique indispensable à la frappe de la boule IBM.
* **Logique Z80 :**
    * Gestion dynamique d'un buffer texte à l'adresse `4516H`.
    * Calcul de matrice de mise en page en temps réel.
    * Implémentation de *Delay Loops* (boucles de temporisation) pour synchroniser le code avec l'inertie physique de la boule Selectric.

---

### 4. Structure du Dépôt (Inventaire)
Le dossier est organisé numériquement pour refléter le cycle de vie du développement :
| Index | Fichier / Dossier | Description |

Markdown
### 4. Structure du Dépôt (Inventaire)

| Index | Document PDF (Cliquer pour ouvrir) | Description |
| :--- | :--- | :--- |
| **0000** | [PROLOGUE 2026](./0000%20PROLOGUE%202026.pdf) | Introduction et genèse du projet. |
| **0000** | [SYNTHÈSE 2026](./0000%20SYNTHÈSE%20ANALYTIQUE%202026%20(%20PAR%20L'IA%20GEMINI).pdf) | Analyse globale par l'IA Gemini. |
| **1000** | [CORTEX_20260430](./1000%20CORTEX_20260430.pdf) | Document de synthèse générale. |
| **1100** | [ANALYSE FONCTIONNELLE](./1100%20–%20CORTEX%20ANALYSE%20FONCTIONNELLE%20SOMMAIRE.pdf) | Logique utilisateur et besoins. |
| **1200** | [ANALYSE ORGANIQUE](./1200%20CORTEX%20ANALYSE%20ORGANIQUE%20.pdf) | Structure interne (Attention à l'espace final). |
| **120H** | [CORTEX HARDWARE](./1200H%20CORTEX%20HARDWARE.pdf) | Spécifications matérielles. |
| **1300** | [PROGRAMMATION](./1300%20CORTEX%20PROGRAMMATION.pdf) | LISTING 1980 et macro **traitecortex**. |
| **1400** | [MISE AU POINT](./1400%20CORTEX%20MISE%20AU%20POINT.pdf) | Rapports de tests et ajustements. |
| **1500** | [UTILISATION](./1500%20UTILISATION%20CORTEX.pdf) | Mode d'emploi de l'environnement. |
| **List** | [LISTING.MD](./LISTING.MD) | Code source et inventaire des macros.


---

### 5. Spécifications Techniques
* **CPU :** Zilog Z80A
* **Adresse de base :** `4300H`
* **Affichage :** 64 caractères x 16 lignes (Standard TRS-80)
* **Points d'entrée clés :** * `DAFF` : Affichage
    * `PCURS` : Gestion du curseur
    * `INIT` : Initialisation système

---

### 6. Évolution et Postérité
* **CORTEX© 1 (1980) :** Version stable documentée ici.
* **CORTEX© 2 :** Intégration de l'algorithme de césure de J. Chaillou, optimisation du timing Selectric 1.
* **1985 la PAO est né avec Mackintoch et PC 16 bits et surtout postcript par Paul Brainerd
* **Années 85+ (Systèmes Experts, PC 64 bits, société Publications Elysées, Jean-Pierre Castejon) : 
    ** Passage à la **MEPA ©** Labeur Presse (Mise En Page Automatique) (langage C portable) sur PC 64 bits et Vax/Vms Cerci.
    * **PANDA © :** MEPA des PA Argus (adressage multicritères, 5 colonnes sur 22 pages, justification verticale ).
    * **BECHOS © :** MEPA Bourse des Échos, flux de données vers sortie MEPA.
    * **SYFI © :** Synthèse Financière (journal rédactionnel entièrement balisé).
    * .... 
    à suivre par d'autres...
    Franchir le pont, briser le cadre... Déployer ses passerelles virtuelles au fil de ses propres progrès, et continuer au-delà de ses supposées limites. ​AMHA, comme on disait en 1980 ;)
    
Jean-Pierre Castejon

> *Ce dépôt constitue une archive de patrimoine numérique, témoignant des solutions d'ingénierie système françaises du début des années 80.*