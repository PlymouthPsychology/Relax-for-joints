// Generated by CoffeeScript 1.9.3
(function() {
  var pc;

  pc = angular.module("pears.controllers", []);

  pc.directive("showTabs", function(ngIfDirective) {
    var ngIf;
    ngIf = ngIfDirective[0];
    return {
      transclude: ngIf.transclude,
      priority: ngIf.priority,
      terminal: ngIf.terminal,
      restrict: ngIf.restrict,
      link: function($scope, $element, $attr) {
        var tabs, value, yourCustomValue;
        value = $attr["showTabs"];
        yourCustomValue = $scope.$eval(value);
        tabs = document.querySelector(".tabs");
        console.log(tabs);
        console.log(yourCustomValue);
        $attr.ngIf = function() {
          return yourCustomValue;
        };
        return ngIf.link.apply(ngIf, arguments);
      }
    };
  });

  pc.controller("NavCtrl", function($scope, $ionicSideMenuDelegate) {
    return $scope.showMenu = function() {
      return $ionicSideMenuDelegate.toggleRight();
    };
  }).controller('HomeTabCtrl', function($scope, $rootScope, $q, $timeout, $cordovaFileTransfer, Recordings, $ionicPlatform) {
    var alertOnce, fileExists, getFile, getFileIfDoesNotExist;
    fileExists = function(path) {
      var deferred;
      console.log("checking if file exists: " + path);
      deferred = $q.defer();
      resolveLocalFileSystemURL(path, deferred.resolve, deferred.reject);
      return deferred.promise;
    };
    getFile = function(url, localpath) {
      console.log("getting file: " + url);
      return $cordovaFileTransfer.download(url, localpath, {}, true);
    };
    getFileIfDoesNotExist = function(url, localpath) {
      return fileExists(localpath).then(function() {
        return console.log(url + "  already available.");
      }, function() {
        return getFile(url, localpath).then(function() {
          return console.log("Downloaded: " + url);
        }, function() {
          return console.log("Error downloading: " + url);
        });
      });
    };
    alertOnce = function(key, message) {
      if (localStorage.getItem("dispOnce_" + key) === null && (navigator.notification != null)) {
        navigator.notification.alert(message, function() {
          return null;
        }, 'Rapid Recovery', 'OK');
        return localStorage.setItem("dispOnce_" + key, "0");
      }
    };
    return $ionicPlatform.ready(function() {
      var ddir, i, promises;
      if (typeof cordova !== "undefined" && cordova !== null) {
        alertOnce("downloainginbgmsg", "Audio files are downloading in the background. Recordings may not play until this is complete.");
        console.log("Checking assets are available.");
        ddir = cordova.file.dataDirectory;
        promises = (function() {
          var j, len, ref, results;
          ref = Recordings.all();
          results = [];
          for (j = 0, len = ref.length; j < len; j++) {
            i = ref[j];
            results.push(getFileIfDoesNotExist(i.remoteurl, ddir + i.filename));
          }
          return results;
        })();
        return $q.all(promises).then(function() {
          alertOnce("alldownloadednow", "All audio files have now been downloaded.");
          return localStorage.setItem('downloads_complete', '1');
        }, function(error) {
          return alertOnce("prblmdwnld", "There was a problem downloading the audio files.");
        });
      }
    });
  }).controller('SettingsCtrl', function($scope, $ionicPlatform, $localStorage) {
    return $scope.downloads_complete = localStorage.getItem('downloads_complete');
  });

  pc.controller("ContentPageCtrl", function($scope, Recordings, $ionicGesture) {
    var i;
    $scope.recordings = Recordings;
    $scope.recs = {};
    return [
      (function() {
        var j, len, ref, results;
        ref = Recordings.all();
        results = [];
        for (j = 0, len = ref.length; j < len; j++) {
          i = ref[j];
          results.push($scope.recs[i.id] = i);
        }
        return results;
      })()
    ];
  });

  pc.controller("RecordingDetailCtrl", function($scope, $rootScope, $state, $ionicViewSwitcher, $stateParams, Recordings, $location) {
    $scope.getContrastTextColor = function(bgcolor) {
      var Color;
      Color = net.brehaut.Color;
      return Color(bgcolor).getLightness() < .6 && "#FFF" || "#000";
      return console.log(Color(bgcolor).getLightness());
    };
    window.x = $rootScope.checkConnection;
    $scope.recordings = Recordings;
    return $scope.recording = Recordings.get($stateParams.recordingId);
  });

}).call(this);