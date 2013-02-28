class PeopleController < ApplicationController
	def index
		@influenced = Person.getInfluenced #('http://dbpedia.org/resource/WhoEver')
	end
end