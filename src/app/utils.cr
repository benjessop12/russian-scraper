require "csv"

module RussianScraper

  FILE_DIR = "tmp"
  FILE_NAME = "#{FILE_DIR}/output.csv"

  class Utils
    def self.get_request(url) : HTTP::Client::Response
      context = url.includes?("https://") ? OpenSSL::SSL::Context::Client.insecure : nil
      response = HTTP::Client.get(url, tls: context)
      if (300..399).includes?(response.status_code)
        url = response.headers["Location"]
        response = get_request(url)
      end
      response
    end

    def self.setup_csv
      Dir.mkdir(FILE_DIR) unless File.directory?(FILE_DIR)
      File.delete(FILE_NAME) if File.file?(FILE_NAME)
      hash_to_csv(MAPPING)
    end

    def self.hash_to_csv(arr_for_csv)
      return if arr_for_csv.compact.empty?

      result = CSV.build do |csv|
        csv.row arr_for_csv
      end
      File.write(FILE_NAME, result, mode: "a")
    end

    def self.array_for_csv
      row_vals = [] of String | Nil
      MAPPING.each do |value|
        row_vals << search(value)
      end
      row_vals
    end

    def self.search(value)
      begin
        return VALUES[value]
      rescue
        return nil
      end
    end
  end
end
