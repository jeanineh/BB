class Bin < ActiveRecord::Base

	filterrific(
	  default_settings: { sorted_by: 'checkout_date' },
	  available_filters: [
	    :sorted_by,
	    :search_by_agency,
	    :search_by_date
	  ]
	)

	# Relationships
	has_one :program
	has_many :bin_items
	has_many :items, through: :bin_items
	belongs_to :agency

	# Scopes
	scope :chronological, -> { order ("checkout_date DESC") }
	# scope :for_date, -> (d) { where ("checkout_date = ?", d) }
	scope :search_by_agency, -> (a){joins(:agency).where('agencies.name = ?', a)}
	scope :search_by_date, -> (d){where("checkout_date=?", d)}
	
	# Validations
	validates_date :checkout_date
	validates_numericality_of :num_of_bins, only_integer: true, greater_than_or_equal_to: 1

end
