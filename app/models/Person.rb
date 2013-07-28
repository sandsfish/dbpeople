include RDF

class Person
	endpoint = 'http://dbpedia.org/sparql'

	# TODO:  IMPORTANT: Need to UNION with influencedBy property!

	def self.getInfluenced(personURI, depth=1)
		# Note: this query excludes other values in DBPedia that define influenced groups by subsetting to the dbpedia:Person class.
		query = "SELECT * WHERE { <#{personURI}> <http://dbpedia.org/ontology/influenced> ?influenced . ?influenced a <http://dbpedia.org/ontology/Person> . }"
		peopleInfluenced = queryEndpoint('http://dbpedia.org/sparql', query, "csv")
		
		# Parse CSV into components, remove empty elements due to splitting on quotes (fix this) and 
		# removing the first element, because it is the column name.
		peopleInfluenced.split("\"").delete_if { |v| v.strip.empty? }[1,peopleInfluenced.length]
	end

	def self.getInfluencersOf(personURI, depth=1)
		query = "SELECT * WHERE { ?influencer <http://dbpedia.org/ontology/influenced> <#{personURI}> . ?influencer a <http://dbpedia.org/ontology/Person> . }"
		influencers = queryEndpoint('http://dbpedia.org/sparql', query, "csv")
		influencers.split("\"").delete_if { |v| v.strip.empty? }[1,influencers.length]
	end

	# TODO:   Move this into its own helper or gem (is there a dbpedia gem?)
	# FIXME:  Rescue & handle "Request Timeout" situation
	# => 2013-02-28T08:14:53+00:00 app[web.1]: RestClient::RequestTimeout (Request Timeout):
	# => 2013-02-28T08:14:53+00:00 app[web.1]:   app/models/Person.rb:22:in `queryEndpoint'
	# => 2013-02-28T08:14:53+00:00 app[web.1]:   app/models/Person.rb:9:in `getInfluenced'
	# => 2013-02-28T08:14:53+00:00 app[web.1]:   app/controllers/people_controller.rb:3:in `index'
	def self.queryEndpoint(endpoint, query, format = "xml")
		# output options: "xml" (default), "json", "js", "n3", "csv"
		return RestClient.post endpoint, :query => query, :output => format
	end
end