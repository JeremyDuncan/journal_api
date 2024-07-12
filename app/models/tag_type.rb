class TagType < ApplicationRecord
  has_many :tags

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
