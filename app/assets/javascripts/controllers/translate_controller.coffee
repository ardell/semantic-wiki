controller = ($http, $scope) ->
  # Load words from the server
  $http({
    method: 'GET',
    url:    '/words'
  }).success (response) ->
    $scope.words = response
  
  $scope.definitionSuggestions = [
    {"id":1,"title":"man","description":"generic male human"},
    {"id":2,"title":"man","description":"emphasized grown male"},
    {"id":3,"title":"man","description":"exclamation - man, I'm tired!"},
  ]
  
  $scope.definition = { id: null }
  $scope.propertyIsCompleted = ->
    return $scope.definition.id != null and $scope.definition.id != 'other'
  
  $scope.startWordIndex = null
  $scope.startWith = (word, $event) ->
    $scope.startWordIndex = $scope.words.indexOf(word)
    $scope.endWordIndex = $scope.startWordIndex
    $event.stopPropagation()

  $scope.endWordIndex = null
  $scope.endWith = (word, $event) ->
    # Don't change end word if mouse isn't pressed
    return unless $event.which == 1
    $scope.endWordIndex = $scope.words.indexOf(word)
    $event.stopPropagation()

  $scope.indexIsHighlighted = (index) ->
    return false if $scope.startWordIndex == null or $scope.endWordIndex == null
    min = Math.min($scope.startWordIndex, $scope.endWordIndex)
    max = Math.max($scope.startWordIndex, $scope.endWordIndex)
    index >= min and index <= max

  $scope.clearHighlight = ->
    $scope.startWordIndex = null
    $scope.endWordIndex = null

  $scope.stopPropagation = ($event) ->
    $event.stopPropagation()
    $scope.selectionDidChange()

  $scope.definitionOptions = []
  $scope.selectionDidChange = ->
    min = Math.min($scope.startWordIndex, $scope.endWordIndex)
    max = Math.max($scope.startWordIndex, $scope.endWordIndex)

    # If the user selected a single word then refresh definition options
    if min == max
      selectedWord = $scope.words[min]
      loadDefinitionsForWord(selectedWord)
    else
      $scope.definitionOptions = []

  loadDefinitionsForWord = (word) ->
    console.log "fetching definitions for #{word.word}"
    $http({
      method: 'GET',
      url:    '/concepts'
      params: { q: word.word }
    }).success (response) ->
      $scope.definitionOptions = response

angular
  .module 'translateAssistant'
  .controller 'TranslateController', [
    '$http'
    '$scope'
    controller
  ]

