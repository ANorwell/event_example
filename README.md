# Event Example

This repo contains example code that builds an Event data with several access patterns,
backed by Cassandra.

## Usage

Install and start a console:

```
bundle install
bundle exec rake console
```

Create an event:

```ruby
event = Event.new(user_id: 1, id: 'my_event', event_data: 'data', event_type: 'notification')
```

Get all events for a user:

```ruby
events, next_page_token = EventInterface.events_by_id(user_id)
```

Get all events for a user:

```ruby
events, next_page_token = EventInterface.events_by_type(user_id, 'notification')
```

Get a specific event for a user:

```ruby
events, next_page_token = EventInterface.find(user_id, event_id)
```
