# Projet R

Projet R - Dashboard\  
Dataset regroupant tout les projets de la plateforme de financement participatif Kickstarter depuis 2009  
378661 projets avec chacun 15 variables tel que le pays, le nom du projet, le montant demandé, le montant récolté, etc.  


## Installation des packages R

Votre projet nécessite l'installation de packages supplémentaires. Décrivez ici les lignes de codes R à exécuter avant de lancer le script proprement dit.  

package_install = c("shiny", "leaflet","lubridate","tidyverse","countrycode",'treemap',"devtools","geojsonio","ggthemes")  
install.packages(package_install)  

library("devtools")  
install_github("timelyportfolio/d3treeR")  
library("d3treeR")  

library("tidyverse")  
library("lubridate")  
library("tidyr")  
library("dplyr")  
library("shiny")  
library("leaflet")  
library("countrycode")  
library("treemap")  
library("ggthemes")  
library("geojsonio")  
library("rgdal")  


## Le script

Vous décrivez ici les opérations nécessaires à l'exécution de votre notebook dans R Studio.

Ouvrir kickstarter.Rproj dans R  
Une fois le projet ouvert, ouvrir kickstarter_notebook.Rmd, ui.R et server.R dans Files si ils ne le sont pas déjà  
Puis "Run all" (Ctrl+Alt+R) kickstarter_notebook.Rmd  
Attendre que tout charge (un peu long à cause du téléchargement du csv et des packages)  

S'il y a une erreur avec " cntryname <- countrycode(unique(ksprojects1$country), "iso2c", "country.name.fr") "  
changer le "country.name.fr" en "un.name.fr". Le package ne se met pas bien à jour parfois, je n'ai pas réussi à regler   
le probleme car cela vient apparemment du serveur où il le télecharge.  

Un fois fini aller dans ui.R et "Run App"  
Attendre un peu que les différents graphiques chargent  

S'il y a besoin de recharger le csv, décommenter la ligne "#ksprojects <- read.csv("ks-projects-201801.csv",encoding="UTF-8")" et executer là  
Cela permet de charger directement le csv localement (ce qui va beaucoup plus vite)  



