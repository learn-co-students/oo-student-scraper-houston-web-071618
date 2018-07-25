require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
    html = File.read(index_url)
    scrapped_info = Nokogiri::HTML(html)
    student_class = scrapped_info.css(".roster-cards-container div.student-card")

    all_scraped = []
    student_class.each do |student_info|
      scraped = {}
      scraped[:name] = student_info.css("div.card-text-container h4").text
      scraped[:location] = student_info.css("div.card-text-container p").text
      scraped[:profile_url] = student_info.css("a").attribute("href").value
      all_scraped << scraped
    end

    all_scraped
  end

  def self.scrape_profile_page(profile_url)
    html = File.read(profile_url)
    scrapped_info = Nokogiri::HTML(html)


    scraped = {}
    social_media_links = scrapped_info.css("div.social-icon-container a").map { |link| link['href'] }

    social_media_links.each do |link|
      if link.include?("twitter")
        scraped[:twitter] = link
      elsif link.include?("github")
        scraped[:github] = link
      elsif link.include?("linkedin")
        scraped[:linkedin] = link
      else
        scraped[:blog] = link
      end
    end

    scraped[:profile_quote] = scrapped_info.css("div.profile-quote").text
    scraped[:bio] = scrapped_info.css("div.description-holder p").text

    scraped
  end

end
