require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))

    pages_array = []

    doc.css(".student-card").each do |element|
      temp_hash = {}

      temp_hash[:name] = element.css(".student-name").text
      temp_hash[:location] = element.css(".student-location").text
      temp_hash[:profile_url] = element.css('a').attribute('href').value

      pages_array << temp_hash
    end

    pages_array
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))

    temp_hash = {}

    links = doc.css(".social-icon-container").children.css("a").map do |the|
      the.attribute('href').value
    end

    links.each do |link|
      if link.include?("twitter")
        temp_hash[:twitter] = link
      elsif link.include?("linkedin")
        temp_hash[:linkedin] = link
      elsif link.include?("github")
        temp_hash[:github] = link
      else
        temp_hash[:blog] = link
      end
    end

    temp_hash[:profile_quote] = doc.css(".profile-quote").text.chomp
    temp_hash[:bio] = doc.css(".description-holder p").text.gsub!(/(\n*)$/, '')

    temp_hash
  end

end
