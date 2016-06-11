require 'spec_helper'

describe ApiConstraints do
  let(:api_constraints_v1) { ApiConstraints.new(version: 1) }
  let(:api_constraints_v2) { ApiConstraints.new(version: 2, default: true) }

  describe 'matches?' do

    it "should returns true when the version matches the 'Accept' header" do
      request = double(host: 'market_place_api.dev', headers: { "Accept" => 'application/vnd.marketplace.v1' })

      api_constraints_v1.matches?(request).should be_truthy
    end

    it "should returns the default version when 'default' option is specified" do
      request = double(host: 'market_place_api.dev')

      api_constraints_v2.matches?(request).should be_truthy
    end

  end

end