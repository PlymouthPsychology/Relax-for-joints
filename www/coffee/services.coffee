angular.module('pears.services', [])

.factory 'Recordings', ($ionicPlatform, $window) ->

      recordings = [
        
        { 
          id: "expectations_video",
          title: "Expectations for surgery",
          remoteurl: "http://plymouth-pears.s3.amazonaws.com/expectations.mp4",
          filename: "expectations.mp4",
          description: "",
          category: "video",
        },
        { 
          id: 0,
          title: "Preparing to relax",
          remoteurl: "http://plymouth-pears.s3.amazonaws.com/preparation.mp3",
          filename: "preparation.mp3",
          description: "An introduction to all of the relaxation recordings",
          category: "relax",
          color: "#F2AC29",
        },
        { 
            id: 1,
            title: "A peaceful place",
            instructions: "",
            remoteurl: "http://plymouth-pears.s3.amazonaws.com/Peaceful_Place.mp3",
            filename: "Peaceful_Place.mp3",
            description: "A simple exercise, imagining a calm and peaceful place.",
            category: "relax",
            color: "#D96A29",
        },
        { 
            id: 2,
            title: "Progressive muscle relaxation",
            instructions: "If tensing your muscles causes discomfort or pain you might like to skip that par of your body.",
            remoteurl: "http://plymouth-pears.s3.amazonaws.com/Progressive_Muscle_Relaxation.mp3",
            filename: "Progressive_Muscle_Relaxation.mp3",
            description: "Tensing and releasing each part of the body in turn to relax.",
            category: "relax",
            color: "#FF3971",
        },
        { 
            id: 3,
            title: "Deliberate, relaxed breathing",
            instructions: "",
            remoteurl: "http://plymouth-pears.s3.amazonaws.com/Relaxed_Breathing.mp3",
            filename: "Relaxed_Breathing.mp3",
            description: "A simple breathing exercise to use at any time.",
            category: "relax",
            color: "#1D732A",
        },
        { 
            id: 4,
            title: "Combined relaxation.",
            instructions: "",
            remoteurl: "http://plymouth-pears.s3.amazonaws.com/Combined_Relaxation_Exercise.mp3",
            filename: "Combined_Relaxation_Exercise.mp3",
            description: "All of the relaxation exercises combined (40 mins).",
            category: "relax",
            color: "#E81A2E",
        },

        {
            id: 5,
            title: "Getting ready for positive suggestions",
            instructions: "",
            remoteurl: "http://plymouth-pears.s3.amazonaws.com/suggestion-introduction-knee.mp3",
            filename: "suggestion-introduction-knee.mp3",
            description: "An introduction to using positive suggestions during recovery.",
            category: "suggest",
            color: "#BF212E",
        },

        {
            id: 6,
            title: "Make your knee more comfortable",
            instructions: "",
            remoteurl: "http://plymouth-pears.s3.amazonaws.com/a-more-comfortable-knee.mp3",
            filename: "a-more-comfortable-knee.mp3",
            description: "Positive suggestions and breathing exercises to reduce pain and discomfort.",
            category: "suggest",
            color: "#739CBF",
        },

        { 
          id: "relax_example_peaceful",
          title: "Example: Imagining a safe and peaceful place",
          remoteurl: "http://plymouth-pears.s3.amazonaws.com/peaceful-place-clip.mp3",
          filename: "peaceful-place-clip.mp3",
          description: "",
          category: "example",
          color: "#F2AC29",
        },
        { 
          id: "relax_example_pmr",
          title: "Example: Progressive muscle relaxation",
          remoteurl: "http://plymouth-pears.s3.amazonaws.com/pmr-clip.mp3",
          filename: "pmr-clip.mp3",
          description: "",
          category: "example",
          color: "#F2AC29",
        },
        { 
          id: "relax_example_breath",
          title: "Example: A breathing exercise",
          remoteurl: "http://plymouth-pears.s3.amazonaws.com/relaxed-breath-clip.mp3",
          filename: "relaxed-breath-clip.mp3",
          description: "",
          category: "example",
          color: "#F2AC29",
        },

        { 
          id: "suggestion_example",
          title: "A simple suggestion for a comfortable knee",
          remoteurl: "http://plymouth-pears.s3.amazonaws.com/breathe-out-swelling.mp3",
          filename: "breathe-out-swelling.mp3",
          description: "",
          category: "example",
          color: "#339966",
        }
        ,

        { 
          id: "audiobook",
          title: "Relaxation for rapid recovery: The audiobook",
          remoteurl: "http://plymouth-pears.s3.amazonaws.com/audiobook.mp3",
          filename: "breathe-out-swelling.mp3",
          description: "An audiobook version of this app. This might be helpful if you find reading on screen hard, or are feeling tired.",
          category: "audiobook",
          color: "#ff0033",
        }
      ];

      $ionicPlatform.ready ->
          # make the paths work in both app and browser
          # (when remote assets are served separately on port 8000)
          # note 'url' attribute is required for ionic audio plugin
          localpath = cordova?.file.dataDirectory or "http://127.0.0.1:8000/";
          recordings.forEach (x,i) ->
            recordings[i].url = localpath + x.filename;

      servicemethods =
        all: -> recordings

        category: (categorylist) -> 
          categories = categorylist.split " "
          recordings.filter (val) -> return val.category in categories

        get: (recordingId) ->
          [firstmatch, others...] = recordings.filter (val) ->
            val.id == parseInt(recordingId) or val.id == recordingId
          return firstmatch
 

      return servicemethods
          