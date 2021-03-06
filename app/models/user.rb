class User < ActiveRecord::Base
	has_secure_password
	validates :firstname, :lastname, :email, :password, presence: true
 	validates :password, confirmation: true
 	validates :password_confirmation, presence: true
 	before_create :confirmation_token

 	def email_activate
 		self.email_confirmed = true
 		self_confirm_token = nil
 		save!(:validate => false)
 	end

	def self.search(params)
    search_params = get_search_params(params)

		if search_params.empty?
      users = User.all
		else
			users = User.by_firstname(search_params[:firstname])
									.by_lastname(search_params[:lastname])
									.by_isadmin(search_params[:isadmin])
		end

		users
  end

 private

 	def confirmation_token
 		if self.confirm_token.blank?
 			self.confirm_token = SecureRandom.urlsafe_base64.to_s
 		end
 	end

	# Expose incoming search parameters

	def self.get_search_params(params)
    sliced = params.compact.slice(:firstname, :lastname, :isadmin)
		sliced.delete_if { |k, v| v.blank? }
  end

	# Validate incoming search paramters

	def self.by_firstname(firstname)
		return User.all unless firstname.present?
		User.where('firstname ILIKE ?', "%#{firstname}%")
	end

	def self.by_lastname(lastname)
		return User.all unless lastname.present?
		User.where('lastname ILIKE ?', "%#{lastname}%")
	end

	def self.by_isadmin(isadmin)
		return User.all unless isadmin.present?
		User.where('isadmin = ?', isadmin)
	end

end
