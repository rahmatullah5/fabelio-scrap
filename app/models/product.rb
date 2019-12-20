class Product < ApplicationRecord
  has_many :product_image
  before_create :fetch_related_link_data, :initialize_product

  attr_accessor :temporary_document_container
  
  private
  def fetch_related_link_data
    require 'open-uri'
    self.temporary_document_container = Nokogiri::HTML(open(related_link.strip))
    # binding.pry
  end

  def initialize_product
    init_title
    init_sub_title
    init_current_price
    init_previous_price
    init_description
    init_product_images
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
    binding.pry
    self.product_images = temporary_document_container.search('.fotorama__wrap').to_html
  end

end
# a[0].children.children.children.children.children.to_a[0].text.gsub(/([^0-9])/, '')
# temporary_document_container.search '.product-options-bottom'