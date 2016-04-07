class Item < ActiveRecord::Base

	# get an array of gender types
	GENDER_LIST = [['Neutral', 0], ['Girl', 1], ['Boy', 2]]
	# get an array of age category (in years)
	AGE_LIST = [['0-2', 0], ['3-10', 1], ['11-21', 2]]
	# Minimum number of items in stock = 10
	MINIMUM = 10

	filterrific(
	  default_settings: { sorted_by: 'name' },
	  available_filters: [
	    :sorted_by,
	    :search_by_name,
	    :search_by_barcode,
	    :by_gender,
	    :by_age_category,
	    :by_category,
	    :by_donation,
	    :by_self_bought
	  ]
	)
	
	# Relationships
	belongs_to :category
	has_many :bin_items
	has_many :bins, through: :bin_items

	# Scopes
	scope :sorted_by, lambda { order('name') }
	scope :alphabetical,  -> { order('name') }
	# by gender
	scope :by_gender, -> (g){ where(gender: g) }
	# by age
	scope :by_age_category, -> (c){ where("age && ARRAY[?]", c.to_i)}
	# by category
	scope :by_category, -> (c) {joins(:category).where("categories.name = ?", c)}
	# by name
	scope :search_by_name, -> (name) { where("name LIKE ? OR notes LIKE ?", "%" + name + "%", "%"+name+"%") }
	# by barcode
	scope :search_by_barcode, -> (b) { where("barcode = ? ", b.to_s)}
	# stock
	scope :by_asc_count, -> { order("quantity ASC")}
	scope :by_desc_count, -> { order("quantity DESC")}
	scope :for_low_stock, -> { where("quantity <= ?", MINIMUM)}
	scope :not_in_stock, -> { where("quantity = ?", 0)}
	scope :in_stock, -> { where("quantity > ?", 0)}
	# donations vs. self-bought
	scope :by_donation, -> { where(donated: true)} # donation = True
	scope :by_self_bought, -> { where(donated: false)} # Self_bought = False

	# Validations
	validates_presence_of :name, :quantity, :category_id
	validates_inclusion_of :gender, in: GENDER_LIST.to_h.values, message: "is not an option"
	# validates_inclusion_of :age, in: AGE_LIST.to_h.values, message: "is not an option"
	validates_numericality_of :quantity, only_integer: true, greater_than_or_equal_to: 1, on: :create
	validates_numericality_of :quantity, only_integer: true, greater_than_or_equal_to: 0, on: :update
	validate :age_is_in_list

	# Other methods
	def increase_quantity (incr)
		self.quantity += incr
	end

	private
	def age_is_in_list
		if self.age.nil?
			errors.add(:age, "can't be blank")
		else
			age_values_list = []
			# get integer values for all age groups
			for age_group in AGE_LIST
				age_values_list+=[age_group[1]]
			end
			# check if age value entered is in age group list
			for i in self.age
				if age_values_list.include?(i) == false
					return false
				end
			end
			return true
		end
	end

end
