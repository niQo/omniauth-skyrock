require 'spec_helper'

describe OmniAuth::Strategies::Skyrock do
  subject do
    OmniAuth::Strategies::Skyrock.new({})
  end

  context "client options" do
    it 'should have correct name' do
      subject.options.name.should eq("skyrock")
    end

    it 'should have correct site' do
      subject.options.client_options.site.should eq('https://api.skyrock.com/v2')
    end

    it 'should have correct authorize url' do
      subject.options.client_options.authorize_path.should eq('/oauth/authenticate')
    end
  end
end
