var questUtils = require('cloud/questUtils.js');

Parse.Cloud.define("getDailyQuest", function (request, response) {
  questUtils.getDailyQuest(request, response);
});