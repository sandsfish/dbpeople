class PeopleController < ApplicationController
	def index
		@influenced = Person.getInfluenced(params[:person_uri])  # e.g. "http://dbpedia.org/resource/Heraclitus"
		@influencers = Person.getInfluencersOf(params[:person_uri])
	end
end