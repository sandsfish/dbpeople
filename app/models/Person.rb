include RDF

class Person
	endpoint = 'http://dbpedia.org/sparql'

	def self.getInfluenced(personURI)
		#['sands fish']
		query = "SELECT * WHERE { <#{personURI}> a <http://dbpedia.org/ontology/Person> . <#{personURI}> <http://dbpedia.org/ontology/influenced> ?influenced. }"
		peopleInfluenced = queryEndpoint('http://dbpedia.org/sparql', query, "csv")
		# ActiveRecord::Base.logger.info peopleInfluenced
		
		# Parse CSV into components, remove empty elements due to splitting on quotes (fix this) and 
		# removing the first element, because it is the column name.
		peopleInfluenced.split("\"").delete_if { |v| v.strip.empty? }[1,peopleInfluenced.length]

	end

	# TODO:   Move this into its own helper or gem (is there a dbpedia gem?)
	# FIXME:  Rescue & handle "Request Timeout" situation
	def self.queryEndpoint(endpoint, query, format = "xml")
		# output options: "xml" (default), "json", "js", "n3", "csv"
		return RestClient.post endpoint, :query => query, :output => format
	end
end