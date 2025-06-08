class Category < ApplicationRecord
  has_many :post_categories, dependent: :destroy
  has_many :posts, through: :post_categories
  
  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
  
  scope :with_posts, -> { joins(:posts).distinct }
end
