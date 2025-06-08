class Post < ApplicationRecord
  has_many :post_categories, dependent: :destroy
  has_many :categories, through: :post_categories
  
  validates :title, presence: true, length: { maximum: 200 }
  validates :content, presence: true
  validates :author, presence: true, length: { maximum: 100 }
  validates :status, inclusion: { in: %w[draft published archived] }
  
  scope :published, -> { where(status: 'published').where('published_at <= ?', Time.current) }
  scope :recent, -> { order(published_at: :desc) }
  
  def published?
    status == 'published' && published_at.present? && published_at <= Time.current
  end
  
  def excerpt(limit = 150)
    content.truncate(limit)
  end
end
