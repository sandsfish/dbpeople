class PeopleController < ApplicationController
	def index
		@influenced = Person.getInfluenced(params[:person_uri])  # e.g. "http://dbpedia.org/resource/Heraclitus"
	end
end