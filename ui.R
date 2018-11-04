ui <- 
fluidPage(
  navbarPage("Projet R & Data Visualization",
    tabPanel("Introduction",
             img(src = "kickstarter-logo-color.png"),
             h3("Visualisation de données sur un dataset de projets"),
             br(),
             HTML("<h3><u>Présentation</u></h3>"),
             br(),
             p("Kickstarter est une entreprise d'investissement de projet américaine basée sur le principe de financement participatif lancée en 2009 à New York."),
             p("C'est une des premières entreprises dans ce domaine, et les projets dits \"créatifs\" ainsi financés s'étalent de l'alimentaire aux nouvelles technologies, sans oublier de passer par le domaine 
             de l'art. Depuis le lancement, ce sont plus de 150 000 projets qui ont été intégralement financés."),
             p("Cette plateforme de financement s'exporte dans l'hexagone, mais aussi dans différents pays européens à partir de juin 2015, amenant ainsi une diversification de l'origine des projets. La majorité 
             restant néanmoins toujours d'origine américaine."),
             br(),
             HTML("<i><b>Exemples de catégories sur Kickstarter (elle-même divisées en sous-catégories)</b></i>"),
             br(),
             br(),
             img(src="Categories.png",align="center"),
             br(),
             br(),
             HTML("<h3><u>Principe</u></h3>"),
             p("À l'instar des sociétés de financement locales de crowdfunding que nous avons en France telles que Ulule ou KissKissBankBank (racheté courant 2017 par la Banque Postale), un porteur de projet défends
             son projet en ligne, tout en fixant un objectif de fond à atteindre, ainsi qu'une date limite et la contrepartie qui résulte d'un investissement. Une fois les fonds rassemblés, Stripe (plateforme de 
             paiement) procède au transfert monétaire tout en collectant une commission et délivre leurs \"récompenses\" aux investisseurs. Dans le cas où un objectif n'est pas atteint, aucun paiement ne sera effectué.
             Bien que Kickstarter autorisait déjà les projets étrangers, cette exportation lui apporte de la visibilité en plus mais également l'amélioration de ses filtres géographiques ainsi qu'un accès facilité aux
             citoyens étrangers sur la plateforme. Le crowdfunding, ou financement participatif est alors une expression signifiant qu'un grand nombre de personnes participe au financement d'un projet donné."),
             p("Le site se différencie des autres plateformes dans la mesure où aucun droit n'est revendiqué par la plateforme. En revanche, celle-ci perçoit une commission sur les projets et ceux-ci sont archivés
             de manière \"définitif\" sur le website, sans droit de modification ou de suppression; en restant toutefois consultables par les tiers."),
             HTML("<h3><u>Distinction</u></h3>"),
             p("En 2011, la plateforme Kickstarter est classée parmi les \"meilleures inventions de l'année 2010\", mais également parmi \"les meilleures sites webs de l'année 2011\" par le TIME. Par ailleurs, elle 
             est considérée comme étant l'une des \"idées les plus intelligentes pour un site web\" par le Miami New Times. Enfin, elle est qualifiée de \"NEA du peuple\" par le New York times, c'est à dire considérée
             comme un fonds national pour les arts."),
             HTML("<h3><u>Le dataset</u></h3>"),
             p("À partir de 2012, soit 3 ans après leur lancement, la plateforme dispose d'assez de données pour en publier des statistiques sur leur site. Afin de réaliser ce projet d'étude de visualisation en R, 
             nous nous sommes alors procurés un jeu de données dans les bibliothèques du website Kaggle, qui regroupe une grande variété de dataset."),
             p("Le dataset obtenu via Kaggle est un jeu regroupant divers informations sur les projets entre le lancement de Kickstarter et le début de l'année 2018. Regroupant différentes données comme le pays 
             d'origine du projets, l'objectif ou bien l'état du projet. Notre objectif ici est alors de mieux interpréter le set de données et en tirer des conclusions et statistiques pertinentes tout en restant 
             général.")
    ),   
    tabPanel("Dashboard",
      #titlePanel("Kickstarter Projects Dataset"),
      sidebarLayout(
        sidebarPanel(
          #style = "position:fixed;width:inherit;",
          radioButtons(
            "GlobalOrYear", "", c("Par année" = "per_year", "Global" = "global"), inline = TRUE
          ),
          conditionalPanel(
            condition = "input.GlobalOrYear == 'per_year'",
            sliderInput("yearInput", "Année", 2009, 2017, 1)
          ),
          radioButtons(
            "WorldOrCountry", "", c( "Monde entier" = "world","Par pays" = "per_country"), inline = TRUE
          ),
          conditionalPanel(
            condition = "input.WorldOrCountry == 'per_country'",
            selectInput('country', 'Pays', cntrycode)
          )
        ),
        mainPanel(
          tabsetPanel(
            tabPanel("Présentation",
              h3("Bienvenue sur le dashboard !"),
              br(),
              HTML("<h3><u>Visualisation des données</u></h3>"),
              br(),
              p("La visualisation des données se fait en 3 partie qui\n sont représenté par les  3 onglets :
                Général, Détails, Résumé statistique."),
              br(),
              HTML("Tout d'abord, la partie que vous voyez sur la gauche que l'on appelle \"side panel\" ou panneau latéral
                sert uniquement pour les 2 onglets Détails et Résumé statistique. En effet comme leurs noms l'indique ils
                permmettent de voir plus en détails la visualisation des données notamment en selectionnant l'année 
                et le pays ou de manière global (de 2009 à 2017) et dans le monde entier ce qui fait.
                beaucoup de combinaisons possibles. Si une des combinaisons n'affiche rien sur les graphiques ou NA dans
                le résumé statistique, cela veut dire que les données n'existent pas.<br>Ces 2 onglets (uniquement, donc un changement n'affectera pas l'onglet général)
                sont donc dépendant de ce panneau latéral."),
              br(),br(),
              HTML("<i><b>Général</b></i>\n"),br(),
              HTML("L'onglet Général permet d'avoir une vue d'ensemble des données grace à des
                   élements de répresentation dynamique et des graphiques d'évolutions"),
              br(),br(),
              HTML("<i><b>Détails</b></i>\n"),br(),
              HTML("L'onglet Détails contient 2 graphiques : Le nombre de projets par état et 
                le nombre de projets par catégories avec le pourcentage des différents états de projet.<br>
                Cela nous permet déjà d'avoir de manière satisfaisante beaucoup d'informations sur les données.<br>
                Le panneau latéral permet de voir pour chaque pays en fonction de l'année ces informations ou 
                sinon de manière plus globale de 2009 à 2017 et/ou pour le monde entier. N'hésitez pas à tester 
                les différentes combinaisons !<br>L'onglet Résumé statistique vient compléter cet onglet"),
              br(),br(),
              HTML("<i><b>Résumé statistique</b></i>\n"),br(),
              HTML("Le résumé statistique à pour objectif de représenter le plus de variables du dataset possible
                sous forme de données uniques qui permettent de résumer l’information contenue dans les données<br>
                C'est un moyen efficace dde comprendre plus en profondeur avec moins de 7 données comme 
                la moyenne, la mediane, le maximum, ect.<br>Nous avons fait le choix de prendre le minimum, 
                la moyenne, le maximum, la somme."),
              br(),br()
            ), 
            
            tabPanel("Géneral",
                     h3("Carte dynamique"),
                     p("Carte du monde comprenant différentes caractéristiques issues du dataset, par pays et depuis le lancement de Kickstarter. Le siège étant à New York (Brooklyn) et l'entreprise ayant été fondée à 
                       Manhattan, il n'y a à priori rien d'anormal d'observer que la grande majorité des projets présentés et financés sur la plateforme Kickstarter soient d'origine Américaines. De même, ces projets se 
                       retrouvent également nombreux au Mexique mais également en Europe, résultat de l'expansion de cette compagnie. (Lancement en Europe depuis fin mai 2015). Au niveau des autres pays ou continent, 
                       les projets sont actuellement peu voire inexistants; et, en ce qui concerne la stratégie de cette entreprise, un billet datant du 19 octobre 2018 précise que celle-ci fait de son mieux pour être présent
                       dans un nombre plus grand de pays."),
              leafletOutput("map"),
              br(),
              h3("Catégorie"),
              p("Blocs des différentes catégories de projets divisées en sous-catégories, dont les rubriques sont proportionnelles au nombre de projets dans la catégorie."),
              d3tree3Output("categoryTree"),

              br(),
              br(),
              h3("Délai d'accomplissement"),
              p("Diagramme en boîte représentant le nombre moyen de jours nécessaires pour atteindre l'objectif fixé du projet (Par années). On observe alors que le délai tends à se réduire au fil des années. 
              On peut notamment voir que en 2017 une médiane \"collée\" au 1er quartile. La médiane étant le séparateur entre les valeurs les plus grandes et les valeurs les plus petites, ainsi 50% des nombres
              de jours d'accomplissement se trouvent au dessus et en dessous du premier quartile. Par ailleurs à partir de 2011, nous remarquons des points situés à l'extérieur de la boxplot, montrant alors une
              certaine disparité au sein des valeurs, qui s'accentue au fil des années."),
              br(),plotOutput("days"),
              br(),
              h3("Évolution du nombre d'investisseurs"),
              p("Graphique offrant l'évolution du nombre d'investisseurs par années, en fonction également de l'état final du projet. On peut observer une évolution croissante du nombre d'investisseurs au fur et
              à mesure des années, malgré une légère baisse en 2014 dont l'origine pourrait être dûe quelques polémique entre
                2013 et 2014 par rapport à de gros projet"),
              p("Le nombre total d'investisseurs par année, quel que soit l'état du projet, est représenté par la courbe noire."),
              splitLayout(cellWidths = c("50%", "50%"), plotOutput("nbprojects"), plotOutput("bckersSum")),
              br(),
              h3("Moyenne de financement"),
              p("On peut voir, sur ce graphique, le financement moyen requit par les projets, regroupé par année mais également par catégorie."),
              p("Par exemple, on peut lire ici que le domaine de la musique est celui ayant été le plus financé en 2015, ou bien qu'en 2017 près de 30000 dollars ont été investis dans la catégorie Food."),
              br(),
              plotOutput("meanFunding")
            ),
            
            tabPanel("Détails",
              #conditionalPanel(
              #  condition = "input.GlobalOrYear == 'per_year'",
                plotOutput("PlotState"),
                plotOutput("PlotMainCategoryState")
              #)
            ),
            tabPanel("Résumé statistique",
              h4("Synthèse"),
              verbatimTextOutput("summary"),   
        
              h4("Projet ayant été le plus financé"),
              verbatimTextOutput("maxPledged"),
              
              h4("Projet ayant le plus de contributeurs"),
              verbatimTextOutput("maxBckers"),
              
              h4("Projet ayant le plus de financement par contributeurs"),
              verbatimTextOutput("maxAvrgBckers"),
              
              h4("Projet ayant le plus grand financement à atteindre"),
              verbatimTextOutput("maxGoal"),
              
              #h4("Financement engagé par pays"),
              #verbatimTextOutput("sumcurrency"),
              
              h4("Quantile représentant nombre de backers par % de projets"),
              verbatimTextOutput("backers"),
              
              h4("Quantile représentant la somme de fonds levés par % de projets"),
              verbatimTextOutput("invest")
            )
          )
        )       
      )
    )
  )
)


