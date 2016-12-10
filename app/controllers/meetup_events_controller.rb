class MeetupEventsController < ApplicationController
  def index
    meetup_api = MeetupApi.new
    result = meetup_api.categories({})
    @categories = result['results']
  end

  def list
    zipcode = 0
    radius = 50
    if params[:filter_options].present?
      zipcode = params[:filter_options][:zipcode]
      radius = params[:filter_options][:radius]
    end

    meetup_api = MeetupApi.new
    params = {
        category: '9',
        format: 'json',
        page: '30',
        radius: radius,
        zip: zipcode
    }
    fitness_events = meetup_api.open_events(params)
    @fitness_events = fitness_events['results']

    params = {
        category: '23',
        format: 'json',
        page: '30',
        radius: radius,
        zip: zipcode
    }
    outdoor_events = meetup_api.open_events(params)
    @outdoor_events = outdoor_events['results']

    params = {
        category: '32',
        format: 'json',
        page: '30',
        radius: radius,
        zip: zipcode
    }
    sports_events = meetup_api.open_events(params)
    @sports_events = sports_events['results']
  end
end
