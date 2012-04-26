require 'omniauth-oauth'
require 'multi_json'

module OmniAuth
  module Strategies
    class Skyrock < OmniAuth::Strategies::OAuth
      option :name, 'skyrock'
      option :client_options, {:authorize_path => '/oauth/authenticate',
                               :site => 'https://api.skyrock.com/v2'}

      uid { access_token.params[:id_user] }

      info do
        {
          :nickname => raw_info['username'],
          :name => raw_info['username'],
          :location => raw_info['city'],
          :image => raw_info['avatar_big_url'],
          :description => '',
          :urls => {
            'Skyrock' => raw_info['user_url'],
          }
        }
      end

      extra do
        { :raw_info => raw_info }
      end

      def raw_info
        @raw_info ||= MultiJson.load(access_token.get('/user/get.json').body)
      rescue ::Errno::ETIMEDOUT
        raise ::Timeout::Error
      end

      alias :old_request_phase :request_phase

      def request_phase
        screen_name = session['omniauth.params'] ? session['omniauth.params']['screen_name'] : nil
        if screen_name && !screen_name.empty?
          options[:authorize_params] ||= {}
          options[:authorize_params].merge!(:force_login => 'true', :screen_name => screen_name)
        end
        old_request_phase
      end

    end
  end
end
