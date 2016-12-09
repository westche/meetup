class MeetupEventsController < ApplicationController
  def index
    meetup_api = MeetupApi.new
    result = meetup_api.categories({})
    @categories = result['results']
  end

  def list
    meetup_api = MeetupApi.new
    params = { category: '9',
               format: 'json',
               page: '50'}
    fitness_events = meetup_api.open_events(params)
    @fitness_events = fitness_events['results']

    params = { category: '23',
               format: 'json',
               page: '50'}
    outdoor_events = meetup_api.open_events(params)
    @outdoor_events = outdoor_events['results']

    params = { category: '32',
               format: 'json',
               page: '50'}
    sports_events = meetup_api.open_events(params)
    @sports_events = sports_events['results']
  end
end
