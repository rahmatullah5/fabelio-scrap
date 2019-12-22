class Product < ApplicationRecord
  has_many :product_images
  before_create :initialize_product
  validate :fetch_related_link_data
  validates :related_link, presence: true, format: { with: /(https?:\/\/(.+?\.)?fabelio\.com(\/[A-Za-z0-9\-\._~:\/\?#\[\]@!$&'\(\)\*\+,;\=]*)?)/i, message: "please enter keywords in correct format"}
  attr_accessor :temporary_document_container
  validates :title, :current_price, presence: true
  
  private
  def fetch_related_link_data
    begin
      require 'open-uri'
      self.temporary_document_container = Nokogiri::HTML(open(related_link.strip))
    rescue => exception
      errors.add(:related_link, 'cannot be fetched')
    end
  end

  def initialize_product
    ActiveRecord::Base.transaction do
      init_title
      init_sub_title
      init_current_price
      init_previous_price
      init_description
      init_product_images
    end
  end

  def init_title
    self.title = temporary_document_container.search('.product-info-main .page-title-wrapper .page-title .base').text
  end

  def init_sub_title
    self.sub_title = temporary_document_container.search('.product-info-main .page-title-wrapper .page-title__secondary').text
  end
  
  def init_current_price
    self.current_price = temporary_document_container.search('.product-options-bottom div.price-box.price-final_price span.special-price span.price-container.price-final_price .price-wrapper .price').text.gsub(/([^0-9])/, '')
  end

  def init_previous_price
    self.previous_price =  temporary_document_container.search('.product-options-bottom div.price-box.price-final_price span.old-price span.price-container.price-final_price .price-wrapper .price').text.gsub(/([^0-9])/, '')
  end

  def init_description
    self.description = temporary_document_container.search('.product-info__description div#description').to_html
  end

  def init_product_images
    self.product_images.new(url: temporary_document_container.search('.loader img')[0].try(:values).try([0]))
  end

end
