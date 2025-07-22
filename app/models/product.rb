class Product < ApplicationRecord
  has_many_attached :images
  has_rich_text :details

  attribute :sold, :boolean, default: false
  validates :name, presence: true
  validates :price, presence: true
  validate :images_count_within_limit
  validate :images_type_and_size

  private

  def images_count_within_limit
    if images.attached? && images.count > 20
      errors.add(:images, 'Máximo de 20 imagens por item.')
    end
  end

  def images_type_and_size
    return unless images.attached?
    images.each do |img|
      if img.blob.byte_size > 10.megabytes
        errors.add(:images, 'Cada imagem deve ter no máximo 10MB.')
      end
      unless img.blob.content_type.start_with?('image/')
        errors.add(:images, 'Apenas arquivos de imagem são permitidos.')
      end
    end
  end
end
