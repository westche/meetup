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
    events = meetup_api.open_events(params)
    @events = events['results']
  end
end
