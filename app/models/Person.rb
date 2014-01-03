include RDF

class Person
	endpoint = 'http://dbpedia.org/sparql'

	# TODO:  IMPORTANT: Need to UNION with influencedBy property!

	# FIXME:  DEPRECATED
	def self.getInfluenced(personURI, depth=1)
		# Note: this query excludes other values in DBPedia that define influenced groups by subsetting to the dbpedia:Person class.
		query = "SELECT * WHERE { 
					<#{personURI}> <http://dbpedia.org/ontology/influenced> ?influenced . 
					?influenced a <http://dbpedia.org/ontology/Person> . }"

		peopleInfluenced = queryEndpoint('http://dbpedia.org/sparql', query, "csv")
		
		# Parse CSV into components, remove empty elements due to splitting on quotes (fix this) and 
		# removing the first element, because it is the column name.
		peopleInfluenced.split("\"").delete_if { |v| v.strip.empty? }[1,peopleInfluenced.length]
	end

	# FIXME:  DEPRECATED
	def self.getInfluencersOf(personURI, depth=1)
		
		query = "SELECT * WHERE { 
					?influencer <http://dbpedia.org/ontology/influenced> <#{personURI}> . 
					?influencer a <http://dbpedia.org/ontology/Person> . }"
		
		influencers = queryEndpoint('http://dbpedia.org/sparql', query, "csv")
		influencers.split("\"").delete_if { |v| v.strip.empty? }[1,influencers.length]

	end

	def self.getInfluencedJSON(personURI, depth=1)
		
		# TODO: Some entities use either birthDate or birthYear property.  Doing a JOIN will get both of these, but duplicates
		#       for all that have both.  DBpedia does not implement SPARQL 1.1 and so cannot do inner LIMITs on UNIONs.
		#       The following query will net duplicates, and could be deduplicated post-query.
		#  { ?influence <http://dbpedia.org/ontology/birthDate> ?influenceBirth } UNION { ?influence <http://dbpedia.org/ontology/birthYear> ?influenceBirth } .
		#       For now, choose the property most frequently used:
		#        count(?personA_birthYear):  4,321; count(?personA_birthDate):  13,870

		# Note: this query excludes other values in DBPedia that define influenced groups by subsetting to the dbpedia:Person class.
		query = "SELECT ?influence ?influenceName ?influenceBirth WHERE { 
					<#{personURI}> <http://dbpedia.org/ontology/influenced> ?influence . 
					?influence a <http://dbpedia.org/ontology/Person> . 
					?influence <http://xmlns.com/foaf/0.1/name> ?influenceName . 
					?influence <http://dbpedia.org/ontology/birthDate> ?influenceBirth .
				}"
		
		peopleInfluenced = queryEndpoint('http://dbpedia.org/sparql', query, "json")

		# Extract / Transcode JSON result
		ActiveSupport::JSON.decode(peopleInfluenced)['results']['bindings'].each do |record|
			puts "#{record['influence']['value']}"
			puts "#{record['influenceName']['value']}"
			puts "#{record['influenceBirth']['value']}"
		end

		puts peopleInfluenced
		
		return peopleInfluenced
	end

	def self.getInfluencersOfJSON(personURI, depth=1)
		
		# Note: this query excludes other values in DBPedia that define influenced groups by subsetting to the dbpedia:Person class.
		query = "SELECT ?influence ?influenceName ?influenceBirth WHERE { 
					?influence <http://dbpedia.org/ontology/influenced> <#{personURI}> . 
					?influence a <http://dbpedia.org/ontology/Person> . 
					?influence <http://xmlns.com/foaf/0.1/name> ?influenceName . 
					?influence <http://dbpedia.org/ontology/birthDate> ?influenceBirth .
		}"
		
		influencers = queryEndpoint('http://dbpedia.org/sparql', query, "json")
		
		puts influencers
		return influencers
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