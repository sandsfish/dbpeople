class PeopleController < ApplicationController
	def index
		@influenced = Person.getInfluenced(params[:person_uri])
		@influencers = Person.getInfluencersOf(params[:person_uri])

		if params[:person_uri].nil? || params[:person_uri].empty?
			stats = Stats.first
			stats.hitcount = stats.hitcount + 1
			stats.save
		end
	end
end