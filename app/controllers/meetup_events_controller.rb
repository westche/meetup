class MeetupEventsController < ApplicationController
  def index
    zipcode = 0
    radius = 50
    city = ''
    if params[:filter_options].present?
      zipcode = params[:filter_options][:zipcode]
      radius = params[:filter_options][:radius]
    end

    @fitness_events = []
    @outdoor_events = []
    @sports_events = []

    if zipcode !~ /\A\d{5}-\d{4}|\A\d{5}\z/
      city = zipcode
      zipcode = 0
    else
      city = ''
    end

    if radius == ''
      radius = 50
    end

    meetup_api = MeetupApi.new
    params = {
        category: '9',
        format: 'json',
        page: '5',
        radius: radius,
        zip: zipcode,
        city: city
    }
    fitness_events = meetup_api.open_events(params)
    @fitness_events = fitness_events['results']

    params = {
        category: '23',
        format: 'json',
        page: '5',
        radius: radius,
        zip: zipcode,
        city: city
    }
    outdoor_events = meetup_api.open_events(params)
    @outdoor_events = outdoor_events['results']

    params = {
        category: '32',
        format: 'json',
        page: '5',
        radius: radius,
        zip: zipcode,
        city: city
    }
    sports_events = meetup_api.open_events(params)
    @sports_events = sports_events['results']

    render :index
  end

  def search
    zipcode = 0
    radius = 50
    city = ''
    if params[:filter_options].present?
      zipcode = params[:filter_options][:zipcode]
      radius = params[:filter_options][:radius]
    end

    @fitness_events = []
    @outdoor_events = []
    @sports_events = []

    if zipcode !~ /\A\d{5}-\d{4}|\A\d{5}\z/
      city = zipcode
      zipcode = 0
    else
      city = ''
    end

    if radius == ''
      radius = 50
    end

    meetup_api = MeetupApi.new
    params = {
        category: '9',
        format: 'json',
        page: '5',
        radius: radius,
        zip: zipcode,
        city: city
    }
    fitness_events = meetup_api.open_events(params)
    @fitness_events = fitness_events['results']

    params = {
        category: '23',
        format: 'json',
        page: '5',
        radius: radius,
        zip: zipcode,
        city: city
    }
    outdoor_events = meetup_api.open_events(params)
    @outdoor_events = outdoor_events['results']

    params = {
        category: '32',
        format: 'json',
        page: '5',
        radius: radius,
        zip: zipcode,
        city: city
    }
    sports_events = meetup_api.open_events(params)
    @sports_events = sports_events['results']

    render :index
  end

  # meetup_events/join/:id
  def join
    puts params[:event]
    selected_event = params[:event]
    redirect_to selected_event[:event_url]
  end
end
