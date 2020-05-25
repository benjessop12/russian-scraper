module RussianScraper
  BASE_URL = "http://www.ved.gov.ru/eng/companies/exporters/?action=companyinfo&id="
  SLEEP_TIME_BETWEEN_URL_REQUESTS = 2

  getter parser, utils

  class Runner
    def self.fetch_company_links
      Utils.setup_csv
      base_int = 1
      loop do
        puts base_int
        sleep(SLEEP_TIME_BETWEEN_URL_REQUESTS)
        Parser.process_page(Parser.get_page(BASE_URL + base_int.to_s))
        base_int += 1
      end
    end
  end
end
