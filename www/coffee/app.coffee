angular.module('pears', [
  'ionic'
  'pears.controllers'
  'pears.services'
  'hc.marked'
  'ngStorage'
  'ngCordova'
  'ionic-audio'
])

.run(($ionicPlatform, $state, $rootScope, $sce, $ionicHistory) ->

  # todo implement this with https://developers.google.com/youtube/iframe_api_reference#Operations
  # $rootScope.playStopVideoOnScroll = (e) -> console.log e.inViewTarget

  setupanalytics = ()->
    if window.analytics
      window.analytics.startTrackerWithId('UA-67495825-1');
      window.analytics.setUserId(device.uuid);
      window.analytics.trackEvent('UserAction', 'Session start')
      console.log "Tracking with userid " + device.uuid
    else
      console.log "No tracking code available. Not logging usage"
  
  document.addEventListener("deviceready", setupanalytics, false)

  # Track each state change in the app, including state params as url encoded string.
  $rootScope.$on('$stateChangeSuccess', 
    (event, toState, toParams, fromState, fromParams) ->
      url = toState.url + "?" + serialize(toParams)
      window.analytics? and window.analytics.trackView(url)
  )


  $rootScope.trustSrc = (src) ->
    # TODO should check these are safe when passed
    $sce.trustAsResourceUrl src

  pageorder = [
    "tabs.home"
    "tabs.aftersurgery"
    "tabs.recovering"
    "tabs.relaxation"
    "tabs.breathing"
    "tabs.pmr"
    "tabs.place"
    "tabs.suggestion"
    "tabs.recordings"
  ]

  $rootScope.turnpage = (direction) -> 
    direction = direction == "back" and -1 or 1
    currindex = pageorder.indexOf($state.$current.toString())
    next = currindex + direction
    if next > -1 and next < pageorder.length
      $state.go(pageorder[currindex+direction])

  $rootScope.checkConnection = () ->
    return  navigator?.connection?.type or false

  $ionicPlatform.ready ->
    # Hide the accessory bar by default (remove this to show the accessory bar above the keyboard
    # for form inputs)
    $rootScope.cordovaExists = window.cordova? and true or false
    if window.cordova and window.cordova.plugins and window.cordova.plugins.Keyboard
      cordova.plugins.Keyboard.hideKeyboardAccessoryBar true
      cordova.plugins.Keyboard.disableScroll true
    if window.StatusBar
      # org.apache.cordova.statusbar required
      StatusBar.styleLightContent()
    return
  return
)

.config ($stateProvider, $urlRouterProvider) ->

  $stateProvider

  .state('moreinformation',
    url: '/moreinformation'
    templateUrl: 'moreinformation.html')

  .state('settings',
    url: '/settings'
    templateUrl: 'templates/settings.html'
    controller: 'SettingsCtrl')

  .state('tabs',
    url: '/tab'
    abstract: true
    templateUrl: 'tabs.html')

  .state('tabs.home',
    url: '/home'
    views: 'home-tab':
      templateUrl: 'home.html'
      controller: 'HomeTabCtrl')

  .state('tabs.recovering',
    url: '/recovering'
    views: 'recovery-tab': 
      templateUrl: 'recovering.html'
      controller: 'ContentPageCtrl')

  .state('tabs.aftersurgery',
    url: '/aftersurgery'
    views: 'recovery-tab': 
      templateUrl: 'aftersurgery.html'
      controller: 'ContentPageCtrl')

  .state('tabs.relaxation',
    url: '/relaxation'
    views: 'recovery-tab':
      templateUrl: 'relaxation.html'
      controller: 'ContentPageCtrl')
      

  .state('tabs.suggestion',
    url: '/suggestion'
    views: 'recovery-tab':
      templateUrl: 'suggestion.html'
      controller: 'ContentPageCtrl')
      

  .state('tabs.breathing',
    url: '/relaxation/breathing/'
    views: 'recovery-tab':
      templateUrl: 'relaxation-breathing.html'
      controller: 'ContentPageCtrl')

  .state('tabs.pmr',
    url: '/relaxation/pmr/'
    views: 'recovery-tab':
      templateUrl: 'relaxation-pmr.html'
      controller: 'ContentPageCtrl')

  .state('tabs.place',
    url: '/relaxation/place/'
    views: 'recovery-tab':
      templateUrl: 'relaxation-place.html'
      controller: 'ContentPageCtrl')

  .state('tabs.recordings',
    url: '/recordings'
    views: 'recordings-tab':
      templateUrl: 'templates/recordings.html'
      controller: 'ContentPageCtrl')

  .state('tabs.recording-detail',
    url: '/recordings/:recordingId'
    views: 'recordings-tab':
      templateUrl: 'templates/recording-detail.html'
      controller: 'RecordingDetailCtrl')
  
  $urlRouterProvider.otherwise '/tab/home'
  


serialize = (obj) ->
  str = []
  for p of obj
    str.push encodeURIComponent(p) + '=' + encodeURIComponent(obj[p])
  str.join '&'

