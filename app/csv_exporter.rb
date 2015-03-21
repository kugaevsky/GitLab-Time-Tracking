# require 'mongo'
# require 'faster_csv'
# require 'awesome_print'

class CSVExporter
	def initialize(mongoConnection)
		@mongoConnection = mongoConnection
	end

	# include Mongo

	# def initialize(mongoConnection)
	# 	# MongoDB Database Connect
	# 	@client = MongoClient.new(url, port)

	# 	@db = @client[dbName]

	# 	@collTimeTracking = @db[collName]
	# end

	# def aggregate(input1)
		
	# 	@collTimeTracking.aggregate(input1)

	# end

	def generateCSV(data)

		csv_string = CSV.generate do |csv|
		  csv << data.first.keys
		  data.each do |hash|
		    csv << hash.values
		  end
		end

	end


	# Gets the number of time tracking records
	# to be used by the CSV download call to determine if there are any records to downloads
	def record_count
		# TODO
	end


	def get_all_issues_time
		# TODO add filtering and extra security around query
		totalIssueSpentHoursBreakdown = @mongoConnection.aggregate([
			# { "$match" => { project_id: projectID }},

			{ "$unwind" => "$comments" },
			{"$project" => {_id: 0,
							project_id: 1, 
							id: 1,
							iid: 1,
							issue_title: "$title",
							state: 1,
							issue_author: "$author.username",
							comment_id: "$comments.id",
							time_track_duration: "$comments.time_tracking_data.duration",
							time_track_non_billable: "$comments.time_tracking_data.non_billable",
							time_track_work_date: "$comments.time_tracking_data.work_date",
							time_track_time_comment: "$comments.time_tracking_data.time_comment",
							time_track_work_date_provided: "$comments.time_tracking_data.work_date_provided",
							time_track_work_logged_by: "$comments.time_tracking_data.work_logged_by" }},			
			# { "$unwind" => "$comments.time_tracking_data" },


			# { "$match" => { "comments.time_tracking_commits.type" => { "$in" => ["Issue Time"] }}},
			# { "$group" => { _id: {
			# 				project_id: "$project_id",
			# 				id: "$id",
			# 				iid: "$iid",
			# 				title: "$title",
			# 				state: "$state",
			# 				issue_author: "$author.username",
			# 				comment_id: "$comment.id",
			# 				comment_author: "$comment.author.username",
			# 				time_track_duration: "$comment.time_tracking_data.duration",
			# 				time_track_non_billable: "$comment.time_tracking_data.non_billable",
			# 				time_track_work_date: "$comment.time_tracking_data.work_date",
			# 				time_track_time_comment: "$comment.time_tracking_data.time_comment",
			# 				},

			# 				}}
							])
		# output = []
		# totalIssueSpentHoursBreakdown.each do |x|
		# 	x["_id"]["time_duration_sum"] = x["time_duration_sum"]
		# 	x["_id"]["time_comment_count"] = x["time_comment_count"]
		# 	output << x["_id"]
		# end
		# return output
	end
end



# Testing Code
# m = CSVExporter.new("localhost", 27017, "GitLab", "Issues_Time_Tracking")
# export = m.get_all_issues_time
# ap export

# CSV.open("data.csv", "wb") do |csv|
#   csv << export.first.keys # adds the attributes name on the first line
#   export.each do |hash|
#     csv << hash.values
#   end
# end