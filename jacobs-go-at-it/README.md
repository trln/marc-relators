# What's here

## relators_refresh.rb

This script pulls the list of LC relators and individual relator datasets from <http://id.loc.gov/vocabulary/relators> as a graph of data using [ruby-rdf/linkeddata](https://github.com/ruby-rdf/linkeddata). It then pulls out labels (terms), codes, and categories and splits those out into paired hashes. Then, it updates the relator_categories and relator-code-to-term YAML mapping files, after creating a backup of the previous mapping files.

## relator_categories.yaml

Relator terms to categories mapping in YAML.

## relator_code_to_term.yaml

Relator codes to terms mapping in YAML.

## categories_to_uri.yaml

This is a manual mapping from category labels to their associated URIs. This manual mapping is needed to filter out excess term-category mappings that LC does that we're not interested in. For example, LC maps *Engraver* to *Relators Past/Present Collection*, *RDA Collection*, and *RDA Manifestation Collection*, in addition to *RDA Manufacturer Collection* (manufacturer), which is the only category we're interested in for this term. Also, as you can tell, the LC label is not super useful.

## relator_categories_override.yaml

A list of local overrides for relator terms to categories mappings. The script uses this to override the listed mappings after it regenerates the full list of mappings.

## relator_code_to_term_override.yaml

A list of local overrides for relator codes to terms mappings. The script uses this to override the listed mappings after it regenerates the full list of mappings.
