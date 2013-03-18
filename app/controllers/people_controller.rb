class PeopleController < ApplicationController
	def index
		unless params[:person_uri].nil?
			@influenced = Person.getInfluenced(params[:person_uri])
			@influencers = Person.getInfluencersOf(params[:person_uri])
		

		# Only do handling in rescue block, instead of doing these checks
		# that are almost guaranteed to work
		if params[:person_uri].nil? || params[:person_uri].empty?
			stats = Stats.first
			stats.hitcount = stats.hitcount + 1
			stats.save
		end

		end
	end
end