require 'nokogiri'
require 'pry'

class Scraper
#index_url = "./fixtures/student-site/index.html"
  def self.scrape_index_page(index_url)
    html = File.read(index_url)
    roster = Nokogiri::HTML(html)
#    profile_url = index_url.sub(/index\.html/,"") + roster.css("div.student-card a").attribute("href").value
#    name = roster.css("div.student-card a div h4").first.text
#    location = roster.css("div.student-card a div p").first.text
    @@students = []

    roster.css("div.student-card a").each do |student|
      profile_url = student.attribute("href").value
      @@students << {
        :name => student.css("div h4").text,
        :location => student.css("div p").text,
        :profile_url => profile_url
      }#.merge(self.scrape_profile_page(index_url.sub(/index\.html/,"") + profile_url))
    end

    @@students
  end


  def self.scrape_profile_page(profile_url)
    html = File.read(profile_url)
    profile = Nokogiri::HTML(html)

    attributes = {
  #    :name => profile.css("h1").text,          # This would have been
  #    :location => profile.css("h2").text,      # a better solution, but
  #    :profile_url => profile_url,              # its not allowed by tests
      :profile_quote => profile.css("div.profile-quote").text,
      :bio => profile.css("div.description-holder p").text
    }
    profile.css("div.social-icon-container a").each do |link|
      social = link.attribute("href").value
      if social.match(/twitter/)
        attributes[:twitter] = social
      elsif social.match(/linkedin/)
        attributes[:linkedin] = social
      elsif social.match(/github/)
        attributes[:github] = social
      else
        attributes[:blog] = social
      end
    end

    attributes
  end

end
