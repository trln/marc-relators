# What's here

## MARC_relators.rb

Gets relator data from id.loc.gov and produces two json maps and a more human-readable csv (details below).

I wrote this before I learned that MARC-to-Argot/Traject can directly use YAML files as lookup maps. 

For this reason we prefer to output YAML rather than JSON maps

In developing this, I'd probably focus on writing it to produce a Ruby Hash of the output we want. If you get that working right, there are built-in ways to turn a Hash object into YAML or JSON or whatever. 


## _relator_categories.csv
An easier to skim/sort version of the last generated _relator_categories.json data

I made this when I realized some terms/codes had been categorized in unexpected ways. 

## _relator_code_to_label.json

Mapping of relator code to preferred human readable label. 

For example:
"sad":"scientific advisor"


## _relator_categories.json

Mapping of each relator code AND human readable label to a relator category. 

Going forward I think it would be acceptable to create this mapping going only from label to category. The MARC processing code will need to expand any codes to labels first, then look up the labels to find the category.

The relator categories in which we are interested are listed below. All except 'uncategorized' are, at least on first pass, based on membership in one of RDA collection categories such as http://id.loc.gov/vocabulary/relators/collection_RDACreator.html . 'uncategorized' is all the stuff we can't figure out a category for: 

- creator
- contributor
- other
- publisher
- manufacturer
- owner
- distributor
- uncategorized

If/when doing subsequent passes or logic, focus mainly on getting uncategorized into a category.

What we don't want to ever do is move something initially categorized as 'creator' down to 'contributor', or something categorized as 'contributor' down to 'other'

### local overrides
Locally, we know we want to treat some relators differently than they are defined in the source vocabulary. The known examples are: 

| vocab category | relator | local category |
| -------------- | ------- | -------------- |
| contributor | editor | creator |
| contributor | dissertant | creator |
| contributor | originator | creator |
| contributor | author of dialog | creator |
| contributor | editor of compilation | creator |
| other | director | creator |
| other | film director | creator |
| other | radio director | creator |
| other | television director | creator |
| contributor | manufacturer | manufacturer |
| other | issuing body | publisher |
| uncategorized | provider | publisher |


# Not here
## RDA element code

I'd started some code to also pull in unconstrained elements from http://www.rdaregistry.info/Elements/u/ and do something with them. 

Except that code never got finished, and honestly I'm not sure what I thought I was going to add or do better by incorporating that stuff. I may have just been playing around with it out of curiosity, which could explain why I did NOTHING to make it make any sense to future me. :-) 

I mention this here only because I mentioned it to you but am not providing it. And just a placeholder of an idea for if/when there's a limitation in what we can do with the LC relator data.



