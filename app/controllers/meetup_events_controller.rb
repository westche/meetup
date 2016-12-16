class MeetupEventsController < ApplicationController
  def index

  end

  def search
    if params[:filter_options][:zipcode] == '' || params[:filter_options][:radius] == ''
      return
    end

    zipcode = params[:filter_options][:zipcode]
    radius = params[:filter_options][:radius]

    if zipcode !~ /\A\d{5}-\d{4}|\A\d{5}\z/
      city = zipcode
      zipcode = ''
    else
      city = ''
    end

    meetup_api = MeetupApi.new
    p = {
        category: '9',
        format: 'json',
        page: '3',
        radius: radius,
        zip: zipcode,
        city: city
    }
    fitness_events = meetup_api.open_events(p)
    @fitness_events = fitness_events['results']

    if @fitness_events != nil
      @fitness_events.each do |event|
        event_param = {
            category: '9',
            format: 'json',
            page: '3',
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
    end

    p = {
        category: '23',
        format: 'json',
        page: '3',
        radius: radius,
        zip: zipcode,
        city: city
    }
    outdoor_events = meetup_api.open_events(p)
    @outdoor_events = outdoor_events['results']

    if @outdoor_events != nil
      @outdoor_events.each do |event|
        event_param = {
            category: '23',
            format: 'json',
            page: '3',
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
    end

    p = {
        category: '32',
        format: 'json',
        page: '3',
        radius: radius,
        zip: zipcode,
        city: city
    }
    sports_events = meetup_api.open_events(p)
    @sports_events = sports_events['results']

    if @outdoor_events != nil
      @sports_events.each do |event|
        event_param = {
            category: '32',
            format: 'json',
            page: '3',
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
