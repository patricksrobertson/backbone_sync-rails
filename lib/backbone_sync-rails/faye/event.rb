require 'net/http'

module BackboneSync
  module Rails
    module Faye
      class Event
        def initialize(model, event, subchannel=nil)
          @model = model
          @event = event
          @subchannel = subchannel
        end

        def broadcast
          Net::HTTP.post_form(uri, :message => message)
        end

        private

        def uri
          URI.parse("#{BackboneSync::Rails::Faye.root_address}/faye")
        end

        def message
          { :channel => channel, :data => data }.to_json
        end

        def channel
          subchannel = @subchannel || @model.class.try(:faye_channel) || @model.class.table_name
          "/sync/#{subchannel}"
        end

        def data
          { @event => { @model.id => @model.as_json } }
        end
      end
    end
  end
end
