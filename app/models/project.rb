class Project < ActiveRecord::Base
  belongs_to :vacant

  def self.search(params)
    search_params = get_search_params(params)

    if search_params.empty?
      Project.all
    else
      projects = Project.by_title(search_params[:title])
                        .by_stage(search_params[:stage])
                        .by_description(search_params[:description])
    end
  end

  private

  # Expose incoming search parameters

  def self.get_search_params(params)
    sliced = params.compact.slice(:title, :stage, :description)
		sliced.delete_if { |k, v| v.blank? }
  end

  # Validate incoming search paramters

	def self.by_title(title)
		return Project.all unless title.present?
		Project.where('title ILIKE ?', "%#{title}%")
	end

  def self.by_stage(stage)
		return Project.all unless stage.present?
		Project.where('stage = ?', stage)
	end

  def self.by_description(description)
		return Project.all unless description.present?
		Project.where('description ILIKE ?', "%#{description}%")
	end

end
