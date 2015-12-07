require 'virtus'

class Event
  include Virtus.model
  attribute :id, String, :default => proc { SecureRandom.uuid }
  attribute :user_id, Integer
  attribute :event_type, String
  attribute :event_data, String
end
