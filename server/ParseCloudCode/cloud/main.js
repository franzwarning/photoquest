var questUtils = require('cloud/questUtils.js');
var photoUtils = require('cloud/photoUtils.js');

// Quest Utils
Parse.Cloud.define("getDailyQuest", function (request, response) {
  questUtils.getDailyQuest(request, response);
});

Parse.Cloud.define("uploadQuestJSON", function(request, response) {
  questUtils.uploadQuestJSON(request, response);
});

Parse.Cloud.define("getStatsForQuest", function(request, response) {
  questUtils.getStatsForQuest(request, response);
});

// Photo Utils
Parse.Cloud.define("uploadQuestPhoto", function(request, response) {
  photoUtils.uploadQuestPhoto(request, response);
});