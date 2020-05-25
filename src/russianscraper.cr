require "./app/*"
require "csv"
require "uri"
require "xml"
require "http/client"

module RussianScraper
  getter runner

  class RussianScraper
    Runner.fetch_company_links
  end
end
