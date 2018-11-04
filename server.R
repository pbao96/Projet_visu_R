server <- function(input,output,session){
  
  
  ###Géneral###  
  
   
  #interactive map
  output$map <- renderLeaflet(
    worldcntry %>% leaflet() 
    %>% addPolygons(fillColor = ~pal(n),weight = 2,opacity = 1,color = "white",
                    dashArray = "3",fillOpacity = 0.7,
                    highlight = highlightOptions(weight = 5,color = "#666",dashArray = "",
                                                 fillOpacity = 0.7,bringToFront = TRUE),
                    label = labels,
                    labelOptions = labelOptions(style = list("font-weight" = "normal", padding = "3px 8px"),
                                                textsize = "15px",direction = "auto")) 
    %>% addLegend(pal = pal, values = ~n, opacity = 0.7, title = "Nombre de projets",position = "bottomright")
  )
  
  #tree of main categories and categories
  output$categoryTree <- renderD3tree3(
    ksprojects1 %>% count(category,main_category) %>% 
      treemap(
        index=c("main_category","category"), 
        vSize='n',
        type="index",
        title="Catégories et sous-catégories"
      ) %>% d3tree(rootname = "Catégories et sous-catégories")
  )
  
  #sum of backers each year
  output$bckersSum <- renderPlot(
    ksprojects1 %>% select(year,state,backers) %>% group_by(year,state) 
    %>% tally(backers) %>% gather(key, value, n) 
    %>% ggplot(aes(x=as.Date(paste(year, 1, 1, sep = "-")), y=value,colour=state)) 
    + geom_line() + geom_point() + stat_summary(fun.y = sum, colour = "black", geom = 'line')
    + scale_y_continuous(labels=function(n){format(n, scientific = FALSE)})
    + guides(color=guide_legend(title="Etat"))
    + labs(title = "Nombre d'investisseurs par année \npour les différents états de projet", 
           x = "Année", y = "Nombre d'investisseurs") 
    + scale_linetype_stata() 
    + theme(plot.title = element_text(size=14, face="bold"),legend.position=c(0.8, 0.4))
  )
  
  #number of projects each year
  output$nbprojects <- renderPlot(
    ksprojects1 %>% select(year) %>% count(year) 
    %>% ggplot(aes(x=as.Date(paste(year, 1, 1, sep = "-")), y=n))
    + geom_line() + geom_point()
    + labs(title = "Nombre de projets par année", x = "Année", y = "Nombre de projets") 
    + scale_linetype_stata()
    + theme(plot.title = element_text(size=14, face="bold"))
  )
  
  #days to complete each year
  output$days <- renderPlot(
    ksprojects1 %>% select(year, days_to_complete) 
    %>% ggplot(aes(x=as.factor(year), y=days_to_complete))
    + geom_boxplot(fill="slateblue", alpha=0.2,outlier.shape=NA)
    + labs(title = "Temps en jour pour finir les projets par année", 
           y = "Temps (jours)", x = "Année") 
    + scale_linetype_stata()
    + theme(plot.title = element_text(size=14, face="bold"))
  )
  
  #funding per main category each year
  output$meanFunding <- renderPlot(
    ksprojects1 %>% select(year,main_category,usd_goal_real) %>% group_by(year,main_category) 
    %>% summarize(mean_usd_goal_real = mean(usd_goal_real)) %>% gather(key, value, mean_usd_goal_real) 
    %>% ggplot(.) 
    + geom_point(mapping=aes(y=main_category, x=value, group=as.factor(year), color=as.factor(year))) 
    + scale_x_continuous(labels=function(n){format(n, scientific = FALSE)})#, trans='log10')
    + labs(title = "Moyennes de financement (dollars) par categories pour chaque année", 
           x = "Moyenne de financement", y = "Categorie") 
    + guides(color=guide_legend(title="Année"))
    + scale_linetype_stata()
    + theme(plot.title = element_text(size=14, face="bold"),legend.position=c(0.9, 0.29))
  )

  
  
###Détails###  
  
  
    
  #numbers of projects per state (canceled, failed, successful, suspended)
  output$PlotState <- renderPlot( 
    ksprojects1 %>% filter(if(input$GlobalOrYear == 'per_year') (year == input$yearInput) else TRUE) 
    %>% filter(if(input$WorldOrCountry == 'per_country') (country == input$country) else TRUE) 
    %>% count(state) 
    %>% ggplot(.,aes(x=state,y=n)) 
    + geom_bar(stat="identity") + geom_text(aes(label = n), position = position_dodge(0), vjust = -0.5)
    + labs(title = "Nombre de projets par états", x = "Etat", y = "Nombre de projets") 
    + theme_economist()
  )

  #number of projects per year and category with percentage of state group###
  output$PlotMainCategoryState <- renderPlot(
    ksprojects1 %>% filter(if(input$GlobalOrYear == 'per_year') (year == input$yearInput) else TRUE) 
    %>% filter(if(input$WorldOrCountry == 'per_country') (country == input$country) else TRUE)  
    %>% count(state,main_category) 
    %>% ggplot(., aes(x=main_category, y=n, group=state, color=state, fill=state))
    + geom_bar(stat="identity") 
    #+ stat_summary(fun.y = sum, aes(label = ..y.., group = main_category, hjust = -0.5), geom = "text")
    + scale_fill_manual("Etat",values = c("canceled" = "#737373", "successful" = "#77AB59", "failed" = "#C10000", 
                                          "suspended" = "#a64ca6")) 
    + scale_colour_manual("Etat",values = c("canceled" = "#737373", "successful" = "#77AB59", "failed" = "#C10000", 
                                            "suspended" = "#a64ca6"))
    + coord_flip()
    + labs(title = "Nombre de projets par catégories avec le pourcentage des différents \nétats de projet", 
         x = "Categorie", y = "Nombre de projets") 
    + theme_economist()
  )
  
  

###Résumé statistique###    
  
  
    
  output$summary <- renderPrint(
    ksprojects1 %>% filter(if(input$GlobalOrYear == 'per_year') (year == input$yearInput) else TRUE) 
    %>% filter(if(input$WorldOrCountry == 'per_country') (country == input$country) else TRUE) 
    %>% summarise_each(funs(mean,sum,max,min),-ID,-name,-category,-main_category,-currency,-deadline,
                       -launched,-state,-country,-year,-pledged,-goal)
  )

  output$maxPledged <- renderPrint(
    ksprojects1 %>% filter(if(input$GlobalOrYear == 'per_year') (year == input$yearInput) else TRUE) 
    %>% filter(if(input$WorldOrCountry == 'per_country') (country == input$country) else TRUE) 
    %>% select(-ID,-deadline,-launched,-pledged,-year,-currency)  
    %>% filter(usd_pledged_real == max(usd_pledged_real))
  )
  
  output$maxBckers <- renderPrint(
    ksprojects1 %>% filter(if(input$GlobalOrYear == 'per_year') (year == input$yearInput) else TRUE) 
    %>% filter(if(input$WorldOrCountry == 'per_country') (country == input$country) else TRUE) 
    %>% select(-ID,-deadline,-launched,-pledged,-year,-currency)  
    %>% filter(backers == max(backers))
  )
  
  output$maxAvrgBckers <- renderPrint(
    ksprojects1 %>% filter(if(input$GlobalOrYear == 'per_year') (year == input$yearInput) else TRUE) 
    %>% filter(if(input$WorldOrCountry == 'per_country') (country == input$country) else TRUE) 
    %>% select(-ID,-deadline,-launched,-pledged,-year,-currency) 
    %>% filter(avrg_per_bckers == max(avrg_per_bckers))
  )
  
  
  output$maxGoal <- renderPrint(
    ksprojects1 %>% filter(if(input$GlobalOrYear == 'per_year') (year == input$yearInput) else TRUE) 
    %>% filter(if(input$WorldOrCountry == 'per_country') (country == input$country) else TRUE) 
    %>% select(-ID,-deadline,-launched,-pledged,-year,-currency) 
    %>% filter(usd_goal_real == max(usd_goal_real))
  )
  
  ###
  output$meancat <- renderPrint(
    tapply(ksprojects1$days_to_complete, ksprojects1$main_category, mean)
  )
  ###
  
  output$backers <- renderPrint(
    ksprojects1 %>% filter(if(input$GlobalOrYear == 'per_year') (year == input$yearInput) else TRUE) 
    %>% filter(if(input$WorldOrCountry == 'per_country') (country == input$country) else TRUE) 
    #%>% quantile(.$backers, probs=seq(from=0, to=1,by=0.1))
    %>% do(data.frame(t(quantile(.$backers, probs=seq(from=.1,to=1,by =.1)))))
  )
  
  output$invest <- renderPrint(
    ksprojects1 %>% filter(if(input$GlobalOrYear == 'per_year') (year == input$yearInput) else TRUE) 
    %>% filter(if(input$WorldOrCountry == 'per_country') (country == input$country) else TRUE) 
    #%>% quantile(ksprojects1$usd_pledged_real, probs=seq(from=0,to=1,by =.1))
    %>% do(data.frame(t(quantile(.$usd_pledged_real, probs=seq(from=.1,to=1,by =.1)))))
  )
  
  


}

