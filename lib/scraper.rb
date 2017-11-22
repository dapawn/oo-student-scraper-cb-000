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
    @@students = {}

    roster.css("div.student-card a").each do |student|
      name = roster.css("div h4").text
      profile_url = index_url.sub(/index\.html/,"") + student.attribute("href").value
      @@students[name.to_sym] = {
        :name => name,
        :location => student.css("div p").text,
        :profile_url => profile_url
      }
      self.scrape_profile_page(profile_url)

    end

    @@students
  end


  def self.scrape_profile_page(profile_url)
    html = File.read(profile_url)
    profile = Nokogiri::HTML(html)
    name = profile.css("h1").text
    @@students[name.to_sym] = {
      :profile_quote => profile.css("div.profile-quote").text,
      :bio => profile.css("div.description-holder p").text
    }
    profile.css("div.social-icon-container a").each do |link|
      social = link.attribute("href").value
      if social.match(/twitter/)
        @@students[name.to_sym][:twitter] = social
      elsif social.match(/linkedin/)
        @@students[name.to_sym][:linkedin] = social
      elsif social.match(/github/)
        @@students[name.to_sym][:github] = social
      else
        @@students[name.to_sym][:blog] = social
      end
    end
  end

end
