class Filter < ApplicationRecord
  has_many :appartments

  def get_appartments_urls
    resp = Faraday.get(self.url)

    regexp = /padding-default"><a href="(https:\/\/www\.portalinmobiliario\.com\/[^"]*)"/
    body = resp.body.force_encoding("utf-8")

    return body.scan(regexp).map{|e| e[0]}
  end
end
