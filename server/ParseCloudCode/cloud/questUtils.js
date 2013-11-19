/*
 * Get the daily quest
 */
exports.getDailyQuest = function(request, response) {
	var query = new Parse.Query("Quest");
	var forDate = request.params.forDate;
	
	query.equalTo("isDaily", true);
	query.equalTo("forDate", forDate);
	query.limit(1); // We only want to see the last date
	query.find({
		success: function(results) {
			if (results.length > 0) {
				response.success(results[0]);
			} else {
				response.error("We forgot to set a quest today...");
			}
		},
		error: function() {
			response.error("Couldn't perform the query");
		}
	});
};

/*
 * Replaces every (non-daily) quest in the table with information from the JSON file
 */ 
exports.uploadQuestJSON = function(request, response)  {

	// First remove all the current quests
	var query = new Parse.Query("Quest");
	query.equalTo("isDaily", false);

	query.find({
		success: function(results) {
			for (var i = 0; i < results.length; i++) {
				var Quest = Parse.Object.extend("Quest");
				var questObjQuery = new Parse.Query(Quest);
				questObjQuery.get(results[i].id, {
					  success: function(object) {
					    // The object was retrieved successfully.
					    object.destroy({});
					  },
					  error: function(object, error) {
					  	response.error("Failed to destroy a quest object");
					  }
				});
			}
		}, 
		error: function(object, error) {
			response.error("Errory querying for all quests")
		}
	});

	var quests = request.params.quests;
	for (var i = 0; i < quests.length; i++) {
		var questObj = quests[i];
		var questId = questObj.id;
		var questText = questObj.quest;
		var questXP = questObj.xp;

		console.log("Quest id: " + questId);

		var Quest = Parse.Object.extend("Quest");
		var newQuest = new Quest();

		newQuest.set("questId", questId);
		newQuest.set("text", questText);
		newQuest.set("xp", questXP);

		newQuest.save(null, {
			success: function(quest) {
				console.log("Added quest " + questId);
			},
			error: function(quest, error) {
				console.log("Failed to add quest " + questId);
				response.error("Failed to add quest " + questId);
			}
		});
	}
};
