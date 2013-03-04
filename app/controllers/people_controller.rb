class PeopleController < ApplicationController
	def index
		@influenced = Person.getInfluenced(params[:person_uri])
		@influencers = Person.getInfluencersOf(params[:person_uri])
	end
end