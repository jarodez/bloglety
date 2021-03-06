@ArticlesController = ($scope,Article,$rootScope,Comment,$location,$routeParams,$http) ->
    $scope.message = "Here is the ArticlesController"
    $scope.articles = $rootScope.articles
    $scope.index = 0
    $scope.article = $scope.articles[$scope.index]
    $scope.dones = {}
    $scope.errors = null
    $scope.selected_article_image = null




    # callbacks


    $scope.getAllSuccessCallback = (response) ->
        $scope.articles = response
        console.log("Fetched all articles successffully!")
        console.log("articles : #{$scope.articles}")

    $scope.getOneSuccessCallback = (response) ->
      $scope.article = null
      $scope.article = response
      console.log("Fetched one article successffully!")
      console.log("article: #{$scope.article}")
      console.log("#{$scope.article.id} #{$scope.article.title}  #{$scope.article.description}")




    $scope.createSuccessCallback = (response) ->
      console.log("article created successfully")
      article = {id: response.id, title: response.title, description: response.description, image: response.image created_at: response.created_at, updated_at: response.updated_at}
      $scope.article = article
      $scope.articles.unshift($scope.article)
      $scope.article_title =""
      $scope.article_description=""
      $scope.article_image=""
      $location.path("/")


    $scope.updateSuccessCallback = (response) ->
      console.log($scope.message)
      $location.path('/articles')

    $scope.deleteSuccessCallback = (response) ->
      console.log("article deleted sucessfully")
      $scope.setNextArticle()


    $scope.createErrorCallback = (errors) ->
      if errors
        console.log("server responded with status: #{errors.status}")
        title_errors          =  errors.data.title
        description_errors    =  errors.data.description
        image_errors          =  errors.data.image
        $scope.errors = {title_errors: title_errors,description_errors:description_errors,image_errors:image_errors}


    $scope.errorCallback = (errors) ->
      if errors?
        console.log("server responded with status: #{errors.status}")
        console.log($scope.errors)


    $scope.initialize = (successCallback,errorCallback) ->
      if((angular.isFunction(successCallback) ) and (angular.isFunction(errorCallback)))
        @articleService = new Article(successCallback,errorCallback)


    $scope.onFileSelect = ($files) ->
      $scope.selected_article_image = $files[0]



    $scope.addArticle =  ->
      $scope.initialize($scope.createSuccessCallback, $scope.createErrorCallback)
      article = {title: $scope.article_title, description: $scope.article_description, image: $scope.selected_article_image}
      @articleService.create(article)


    $scope.deleteArticle = ->
      unless !confirm "Êtves-vous sure de supprimer l'article n°#{$scope.article.id} ?"
        $scope.initialize($scope.deleteSuccessCallback,$scope.errorCallback)
        @articleService.delete($scope.article)
        $scope.articles.splice($scope.articles.indexOf($scope.article),1)
      else
        return



    $scope.getArticle = (id) ->
      $scope.initialize($scope.getOneSuccessCallback,$scope.errorCallback)
      @articleService.get(id)


    $scope.updateArticle = (article,data) ->
      $scope.initialize($scope.updateSuccessCallback,$scope.errorCallback)
      @articleService.update(article,data)
      $scope.message = "article updated successfully!"


    $scope.updateArticleForId =(id,data) ->
      article = _.findWhere($scope.articles,{id: id})
      $scope.updateArticle(article,data)


    $scope.updateSelectedArticle = ->
      #console.log($scope.article.id)
      data = {title: $rootScope.article_to_update.title, description: $rootScope.article_to_update.description}
      #console.log(data)
      $scope.updateArticle($scope.article,data)



   # $scope.updateArticleForId(5,{title: 'Juste un nouveau titre',description: 'Une petite description'})

    $scope.setNextArticle = ->

        $("img.article_image").fadeOut()
        $scope.tour = true
        while($scope.tour == true)
          if($scope.index == 0)
            $scope.index = $scope.articles.length-1
          else
            $scope.index -= 1
          $scope.tour = false
          $scope.article = $scope.articles[$scope.index]
         # $location.path('/articles/'+$scope.article.id)
          $("img.article_image").slideUp 'slow', ->
            $(this).fadeIn()




    $scope.setPrevArticle = ->

      $("img.article_image").fadeOut()
      $scope.tour = true
      while($scope.tour == true)
        if($scope.index == $scope.articles.length-1)
          $scope.index = 0
        else
          $scope.index += 1
        $scope.tour = false
        $scope.article = $scope.articles[$scope.index]
        #$location.path('/articles/'+$scope.article.id)
        $("img.article_image").slideUp 'slow', ->
          $(this).fadeIn()



    $scope.showEditArticleForm = (article) ->
      $rootScope.article_to_update = article
      $("span.tooltip").hide()
      $location.path("/articles/#{article.id}/edit")


    $scope.showNewArticleForm = ->
      #$("div.article").replaceWith("<h1>New article form</h1>")
      $("span.tooltip").hide()
      $location.path('/articles/new')



    $icon_plus = $("div.articles_browser").children("i.icon-plus-sign")
    $article_management = $("div.articles_management")
    $icon_plus.hover ->
      $(this).css({'visibility':'hidden'})
      $article_management.css({'visibility':'visible','marginLeft':'-32px'}).addClass("position_management_on_hover")

    $article_management.mouseleave ->
      $(this).css({'visibility':'hidden'})
      $icon_plus.css({'visibility':'visible'})

    $("img.article_image").hover ->
      $("div.articles_browser").css({'visibility':'visible'})

    $("div.articles_row").hover ->
      $("div.articles_browser").css({'visibility':'visible'})

