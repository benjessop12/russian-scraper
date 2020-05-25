module RussianScraper

  MAPPING = %w[Name Country General Director Description Source\ information Zip\ Code Address Phone/fax Web]
  VALUES = {} of String => String

  class Parser
    getter utils

    def self.get_page(url : String)
      response_body = Utils.get_request(url).as(HTTP::Client::Response).body
      XML.parse_html(response_body).as(XML::Node)
    end

    def self.process_page(document : XML::Node)
      VALUES.clear
      document.xpath_nodes("//td").each do |node|
        process_block(node)
      end
      Utils.hash_to_csv(Utils.array_for_csv)
    end

    def self.process_block(block : XML::Node)
      process_parent(block.parent.as(XML::Node).inner_text.strip.chomp) if MAPPING.includes? block.text
    end

    def self.process_parent(parent : String)
      key = parent.split("\n")
      VALUES.merge!({key.first => key.last})
    end
  end
end
