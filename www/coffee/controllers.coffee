pc = angular.module("pears.controllers", [])

pc.directive("showTabs", (ngIfDirective) ->
  ngIf = ngIfDirective[0]
  transclude: ngIf.transclude
  priority: ngIf.priority
  terminal: ngIf.terminal
  restrict: ngIf.restrict
  link: ($scope, $element, $attr) ->
    value = $attr["showTabs"]
    yourCustomValue = $scope.$eval(value)
    tabs = document.querySelector(".tabs")
    console.log tabs
    console.log yourCustomValue
    $attr.ngIf = ->
      yourCustomValue
    ngIf.link.apply ngIf, arguments
)

pc.controller("NavCtrl", ($scope, $ionicSideMenuDelegate) ->
  $scope.showMenu = ->
    $ionicSideMenuDelegate.toggleRight()
)

.controller 'HomeTabCtrl', ($scope,
                            $rootScope
                            $q, 
                            $timeout, 
                            $cordovaFileTransfer, 
                            Recordings,
                            $ionicPlatform) ->  

  fileExists = (path) -> 
    console.log "checking if file exists: " +  path
    deferred = $q.defer()
    resolveLocalFileSystemURL(path, deferred.resolve, deferred.reject)
    return deferred.promise

  getFile = (url, localpath) ->
    console.log "getting file: " + url
    return $cordovaFileTransfer.download(url,localpath, {}, true)
  
  getFileIfDoesNotExist = (url, localpath) ->
    fileExists(localpath).then(
      -> 
        console.log url + "  already available."
      -> getFile(url, localpath).then(
        ->
          console.log "Downloaded: " + url
        -> 
          console.log "Error downloading: " + url
        )
      )

  alertOnce = (key, message) ->
    # Function uses local storage to only ever display an alert a single time.
    if localStorage.getItem("dispOnce_" + key) == null and navigator.notification?
      navigator.notification.alert(
        message                 # message
        -> null                 # callback
        'Rapid Recovery',       # title
        'OK'                    # buttonName
      )

      localStorage.setItem("dispOnce_" + key, "0")

  $ionicPlatform.ready ->

    if cordova?
      alertOnce "downloainginbgmsg", "Audio files are downloading in the background. Recordings may not play until this is complete."
      console.log "Checking assets are available."
      ddir = cordova.file.dataDirectory
      promises = (getFileIfDoesNotExist(i.remoteurl, ddir + i.filename) for i in Recordings.all())
      $q.all(promises).then(
        -> 
          alertOnce "alldownloadednow", "All audio files have now been downloaded."
          localStorage.setItem('downloads_complete', '1')
        (error) -> alertOnce "prblmdwnld", "There was a problem downloading the audio files."
      )
    

.controller 'SettingsCtrl', ($scope, $ionicPlatform, $localStorage) ->
  $scope.downloads_complete = localStorage.getItem('downloads_complete')

pc.controller "ContentPageCtrl", ($scope, Recordings, $ionicGesture) ->
  
  $scope.recordings = Recordings
  $scope.recs = {}
  [$scope.recs[i.id] = i for i in Recordings.all()]

pc.controller "RecordingDetailCtrl", ($scope, $rootScope, $state, $ionicViewSwitcher, $stateParams, Recordings, $location) ->
  $scope.getContrastTextColor = (bgcolor) ->
    # pick a contrasting text color
    Color = net.brehaut.Color
    return Color(bgcolor).getLightness() < .6 and "#FFF" or "#000"
    console.log Color(bgcolor).getLightness()
  
  
  window.x = $rootScope.checkConnection

  $scope.recordings = Recordings
  $scope.recording = Recordings.get($stateParams.recordingId)

 
  

