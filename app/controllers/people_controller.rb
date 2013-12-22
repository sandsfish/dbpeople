class PeopleController < ApplicationController
	def index

		# Only do handling in rescue block, instead of doing these checks
		# that are almost guaranteed to work
		if params[:person_uri].nil? || params[:person_uri].empty?
			# TODO: Create a Stats.increment_hitcount method to do this
			stats = Stats.first
			stats.hitcount = stats.hitcount + 1
			stats.save
		end

		unless params[:person_uri].nil?
			if params[:person_uri].starts_with? 'http://dbpedia.org'
				begin
				
					@influenced = Person.getInfluenced(params[:person_uri])
					@influencers = Person.getInfluencersOf(params[:person_uri])

					@influencedJSON = Person.getInfluencedJSON(params[:person_uri])
					@influencersJSON = Person.getInfluencersOfJSON(params[:person_uri])

					# FIXME: Do this in the model and return a hash with influenced, 
					# influencers, and counts.  Better yet, do this all as a JSON
					# web-service / AJAX call.
					@forward_count = @influenced.count
					@backward_count = @influencers.count
				
				rescue RestClient::BadRequest
					puts @influencedJSON
					redirect_to '/', :notice => "DBPedia doesn't like this request.  :("
				end
			else
				redirect_to '/', :notice => "Currently, you must enter a valid DBPedia URI. Text search coming soon!"
			end
		end
	end
end