class Task < ActiveRecord::Base
  belongs_to :author
  belongs_to :category

  validates :description, :presence => true
  validates :status, :presence => true
  validates :author, :presence => true
  validates :category, :presence => true

end
