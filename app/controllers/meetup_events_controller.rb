class MeetupEventsController < ApplicationController
  def index
    zipcode = 0
    radius = 25
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
      zipcode = ''
    else
      city = ''
    end

    if radius == ''
      radius = 25
    end

    meetup_api = MeetupApi.new
    p = {
        category: '9',
        format: 'json',
        page: '20',
        radius: radius,
        zip: zipcode,
        city: city
    }
    fitness_events = meetup_api.open_events(p)
    @fitness_events = fitness_events['results']

    @fitness_events.each do |event|
      event_param = {
          category: '9',
          format: 'json',
          event_id: event['id']
      }
      event_info = meetup_api.events(event_param)
      photo_info = meetup_api.photos(event_param)
      event['members'] = event_info['results'][0]['headcount']
      length = photo_info['results'].length

      if length > 0
        event['photo'] = photo_info['results'][0]['highres_link']
      end
    end

    p = {
        category: '23',
        format: 'json',
        page: '5',
        radius: radius,
        zip: zipcode,
        city: city
    }
    outdoor_events = meetup_api.open_events(p)
    @outdoor_events = outdoor_events['results']

    @outdoor_events.each do |event|
      event_param = {
          category: '23',
          format: 'json',
          event_id: event['id']
      }
      event_info = meetup_api.events(event_param)
      photo_info = meetup_api.photos(event_param)
      event['members'] = event_info['results'][0]['headcount']
      length = photo_info['results'].length

      if length > 0
        event['photo'] = photo_info['results'][0]['highres_link']
      end
    end

    p = {
        category: '32',
        format: 'json',
        page: '5',
        radius: radius,
        zip: zipcode,
        city: city
    }
    sports_events = meetup_api.open_events(p)
    @sports_events = sports_events['results']

    @sports_events.each do |event|
      event_param = {
          category: '32',
          format: 'json',
          event_id: event['id']
      }
      event_info = meetup_api.events(event_param)
      photo_info = meetup_api.photos(event_param)
      event['members'] = event_info['results'][0]['headcount']
      length = photo_info['results'].length

      if length > 0
        event['photo'] = photo_info['results'][0]['highres_link']
      end
    end

    render :index
  end

  def search
    zipcode = 0
    radius = 25
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
      zipcode = ''
    else
      city = ''
    end

    if radius == ''
      radius = 25
    end

    meetup_api = MeetupApi.new
    p = {
        category: '9',
        format: 'json',
        page: '20',
        radius: radius,
        zip: zipcode,
        city: city
    }
    fitness_events = meetup_api.open_events(p)
    @fitness_events = fitness_events['results']

    @fitness_events.each do |event|
      event_param = {
          category: '9',
          format: 'json',
          event_id: event['id']
      }
      event_info = meetup_api.events(event_param)
      event['members'] = event_info['results'][0]['headcount']
    end

    p = {
        category: '23',
        format: 'json',
        page: '5',
        radius: radius,
        zip: zipcode,
        city: city
    }
    outdoor_events = meetup_api.open_events(p)
    @outdoor_events = outdoor_events['results']

    @outdoor_events.each do |event|
      event_param = {
          category: '9',
          format: 'json',
          event_id: event['id']
      }
      event_info = meetup_api.events(event_param)
      event['members'] = event_info['results'][0]['headcount']
    end

    p = {
        category: '32',
        format: 'json',
        page: '5',
        radius: radius,
        zip: zipcode,
        city: city
    }
    sports_events = meetup_api.open_events(p)
    @sports_events = sports_events['results']

    @sports_events.each do |event|
      event_param = {
          category: '9',
          format: 'json',
          event_id: event['id']
      }
      event_info = meetup_api.events(event_param)
      event['members'] = event_info['results'][0]['headcount']
    end

    render :index
  end

  # meetup_events/join/:id
  def join
    puts params[:event]
    selected_event = params[:event]
    redirect_to selected_event[:event_url]
  end
end
