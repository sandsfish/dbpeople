class PeopleController < ApplicationController
	def index
		unless params[:person_uri].nil?
			@influenced = Person.getInfluenced(params[:person_uri])
			@influencers = Person.getInfluencersOf(params[:person_uri])
			
			# FIXME: Do this in the model and return a hash with influenced, 
			# influencers, and counts.  Better yet, do this all as a JSON
			# web-service / AJAX call.
			@forward_count = @influenced.count
			@backward_count = @influencers.count

		# Only do handling in rescue block, instead of doing these checks
		# that are almost guaranteed to work
		if params[:person_uri].nil? || params[:person_uri].empty?
			# TODO: Create a Stats.increment_hitcount method to do this
			stats = Stats.first
			stats.hitcount = stats.hitcount + 1
			stats.save
		end

		end
	end
end