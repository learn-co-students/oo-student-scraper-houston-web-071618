require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper
  def self.scrape_index_page(index_url)
    arr = []
    doc = Nokogiri::HTML(open(index_url))
    doc.css('.student-card').each do |x|
      y = {
        name: x.css('h4').text,
        location: x.css('p').text,
        profile_url: x.css('a').attribute('href').to_s
      }
      arr << y
    end
    arr
  end

  def self.scrape_profile_page(profile_url)
    y = {}
    doc = Nokogiri::HTML(open(profile_url))
    main = doc.css('.main-wrapper')
    links = main.css('.social-icon-container')
    links.css('a').each do |x|
      str = x.attribute('href').to_s
      a = str.clone.split('//')
      a.shift
      a = a.first
      a.slice!(0..3) if a.include?('www')
      b = a.split('.').first
      c = b.to_sym
      c = :blog unless b == "github" || b == "twitter" || b == "linkedin"
      y[c] = str
    end
    quote = main.css('.profile-quote').text
    y[:profile_quote] = quote
    bio_container = main.css('.description-holder')
    y[:bio] = bio_container.css('p').text
    y
  end
end
