class Job < ApplicationRecord
  validates :title, presence: true
  validates :wage_lower_bound, presence: true
  validates :wage_upper_bound, presence: true
  validates :wage_lower_bound, numericality: {greater_than: 0}
  has_many :resumes
  has_many :job_favorites
  has_many :collectors, :through => :job_favorites, :source => :user

  def publish!
    self.is_hidden = false
    self.save

  end

  def hide!
    self.is_hidden = true
    self.save

  end

  scope :published, -> { where(is_hidden: false) }
  scope :recent, -> { order('created_at DESC') }
end
