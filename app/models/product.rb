class Product < ApplicationRecord
  has_many_attached :images
  has_rich_text :details

  attribute :sold, :boolean, default: false
  validates :name, presence: true
  validates :price, presence: true
end
