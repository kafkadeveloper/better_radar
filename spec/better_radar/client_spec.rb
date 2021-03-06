require 'spec_helper'

RSpec.describe BetterRadar::Client do

  before do
    BetterRadar.configure do |config|
      config.username = "username"
      config.key = "123456"
      config.feed_name = "Fixtures"
    end
  end

  let!(:client) do
    BetterRadar::Client.new
  end

  let!(:xml_data) do
    VCR.use_cassette("fixtures_feed") do
      client.get_xml_feed
    end
  end

  describe '#get_xml_feed' do
    it "should return a File object with the saved data" do
      expect(xml_data.class).to eq Tempfile
    end

    it "should include bet radar data" do
      dom = Nokogiri::XML::Document.parse(xml_data.open.read)

      expect(dom.root.name).to eq("BetradarBetData")
      expect(dom.xpath("//Sports")).to_not be_empty
    end
  end
end
