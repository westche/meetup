class MeetupEventsController < ApplicationController
  def index
    # meetup_api = MeetupApi.new
    # result = meetup_api.categories({})
    # @categories = result['results']

    zipcode = 90001
    radius = 50
    if params[:filter_options].present?
      zipcode = params[:filter_options][:zipcode]
      radius = params[:filter_options][:radius]
    end

    meetup_api = MeetupApi.new
    params = {
        category: '9',
        format: 'json',
        page: '5',
        radius: radius,
        zip: zipcode
    }
    fitness_events = meetup_api.open_events(params)
    @fitness_events = fitness_events['results']

    params = {
        category: '23',
        format: 'json',
        page: '5',
        radius: radius,
        zip: zipcode
    }
    outdoor_events = meetup_api.open_events(params)
    @outdoor_events = outdoor_events['results']

    params = {
        category: '32',
        format: 'json',
        page: '5',
        radius: radius,
        zip: zipcode
    }
    sports_events = meetup_api.open_events(params)
    @sports_events = sports_events['results']
  end

  # meetup_events/join/:id
  def join
    # redirect_to "https://secure.meetup.com/oauth2/authorize?client_id=#{"9euj39oigrspm6l83m6iaj2rf2"}&response_type=code&redirect_uri=#{meetup_events_join_callback_url}"
    meetup_api = MeetupApi.new
    puts params[:id]
    p = {
        event_id: params[:id],
        format: 'json',
        page: '30'
    }
    detail_event = meetup_api.events(p)
    @detail_event = detail_event['results']
  end

  def join_callback
    meetup_api = MeetupApi.new
    puts params[:id]
    p = {
        event_id: params[:id],
        format: 'json',
        page: '30'
    }
    detail_event = meetup_api.events(p)
    @detail_event = detail_event['results']
  end
end
