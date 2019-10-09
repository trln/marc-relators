## requires ruby 2.5 or above for .transform_keys method

# import libraries
require 'rdf'
require 'linkeddata'
require 'yaml'
require 'rest-client'

####
# load all the data

## load initial graph that lists all the relator URIs
graph = RDF::Graph.load("http://id.loc.gov/vocabulary/relators")

## set up a query to grab relator URIs
query = RDF::Query.new({
  :relators => {
    RDF::URI("http://www.loc.gov/mads/rdf/v1#hasMADSSchemeMember") => :schemeMember
  }
  })

## execute the query on the loaded graph
lc_relators = query.execute(graph)
## load each relator URI into the graph
 lc_relators.each do |relator|
   graph.load(relator[:schemeMember].to_s)
 end

## set up a query to grab relator code and collection URIs for each relator
query = RDF::Query.new({
  :relator => {
    RDF::URI("http://www.loc.gov/mads/rdf/v1#code") => :code,
    RDF::URI("http://www.loc.gov/mads/rdf/v1#authoritativeLabel") => :label,
    RDF::URI("http://www.loc.gov/mads/rdf/v1#isMemberOfMADSCollection") => :collection
  }
  })

## execute the query on the updated graph
lc_relators = query.execute(graph)

## load categories_to_uri.yaml
categories_to_uri = YAML.load_file "categories_to_uri.yaml"

## load relator_code_to_term_override.yaml
relator_code_to_term_override = YAML.load_file "relator_code_to_term_override.yaml"

## load relator_categories_override.yaml
relator_categories_override = YAML.load_file "relator_categories_override.yaml"

####
# all the match logic

## set up hash for code:label from relator
loc_codes = {}

## set up hash for label:collection from relator
loc_categories = {}

lc_relators.each do |relator_stuff|
  loc_codes[relator_stuff[:code].to_s] = relator_stuff[:label].to_s
  loc_categories[relator_stuff[:label].to_s] = "uncategorized"
end

lc_relators.each do |relator_stuff|
  if categories_to_uri.values.include? relator_stuff[:collection].to_s
    loc_categories[relator_stuff[:label].to_s] = relator_stuff[:collection].to_s
  end
end

## set up label:category hash from loc_categories
categories_matched = {}

## match loc_categories uris to categories_to_uri uris. if matched, create new hash with label:category
loc_categories.each do |loc_categories_label, loc_categories_uri|
  categories_to_uri.each do |categories_to_uri_label, categories_to_uri_uri|
    if categories_to_uri_uri == loc_categories_uri
    categories_matched[loc_categories_label] = categories_to_uri_label
    end
  end
end

## if the loc_categories uri isn't in the categories_to_uri uri list, mark as "uncategorized"
loc_categories.each do |loc_categories_label, loc_categories_uri|
  unless categories_to_uri.values.include? loc_categories_uri
    categories_matched[loc_categories_label] = "uncategorized"
  end
end

## incorporate overrides to relator_code_to_term after rebuild
relator_code_to_term_override.each do |relator_code, relator_term|
  loc_codes[relator_code] = relator_term
end

## incorporate overrides to relator_categories after rebuild
relator_categories_override.each do |relator_term, relator_category|
  # loc_categories[relator_term] = relator_category
  categories_matched[relator_term] = relator_category
end

## lowercase loc_codes keys and values; sort alphabetically
loc_codes = loc_codes.sort_by { |key| key }.to_h
loc_codes = loc_codes.transform_keys(&:downcase).transform_values(&:downcase)

## lowercase categories_matched keys and value; sort alphabetically
categories_matched = categories_matched.sort_by { |key| key }.to_h
categories_matched = categories_matched.transform_keys(&:downcase).transform_values(&:downcase)

####
# create new yaml files

## create backup of relator_code_to_term.yaml
File.rename("relator_code_to_term.yaml", "relator_code_to_term_backup.yaml")

##create backup of relator_categories.yaml
File.rename("relator_categories.yaml", "relator_categories_backup.yaml")

## load updated data into relator_code_to_term.yaml
File.open("relator_code_to_term.yaml", 'w') { |f| YAML.dump(loc_codes, f) }

## load updated data into relator_categories.yaml
File.open("relator_categories.yaml", 'w') { |f| YAML.dump(categories_matched, f) }
