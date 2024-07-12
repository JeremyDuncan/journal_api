class Tag < ApplicationRecord
  belongs_to :tag_type, optional: true
  has_many :post_tags
  has_many :posts, through: :post_tags

  before_create :set_default_tag_type

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :tag_type, presence: true

  private

  def set_default_tag_type
    self.tag_type ||= TagType.find_or_create_by(name: 'default')
  end
end
