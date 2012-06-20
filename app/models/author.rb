class Author < ActiveRecord::Base
  has_many :tasks

  validates_presence_of :name
end