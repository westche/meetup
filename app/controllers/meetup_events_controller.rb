class MeetupEventsController < ApplicationController
  def index
    @radius_list = [ '10', '20', '30', '40', '50', '60', '70', '80', '90', '100' ]
  end

  def search
    @radius_list = [ '10', '20', '30', '40', '50', '60', '70', '80', '90', '100' ]
    if params[:filter_options].present?
      if params[:filter_options][:zipcode] == '' || params[:filter_options][:radius] == ''
        @message = 'Please full fill the search box!'
        render :index
        return
      end

      zipcode = params[:filter_options][:zipcode]
      radius = params[:filter_options][:radius]

      if zipcode !~ /\A\d{5}-\d{4}|\A\d{5}\z/
        @message = 'Please full fill the search box!'
        return
      else
        city = ''
      end
    else
      @message = 'Please full fill the search box!'
      return
    end

    meetup_api = MeetupApi.new
    p = {
        category: '9',
        format: 'json',
        page: '20',
        fields: 'group_photo,photo_count,photo_sample',
        radius: radius,
        zip: zipcode,
        city: city
    }
    fitness_events = meetup_api.open_events(p)
    @fitness_events = fitness_events['results']

    if @fitness_events != nil
      @fitness_events.each do |event|
        if event['photo_count'] > 0
          event['photo'] = event['photo_sample'][0]['photo_link']
        else
          if event['group']['group_photo'].present?
            event['photo'] = event['group']['group_photo']['photo_link']
          end
        end
      end
    end

    p = {
        category: '23',
        format: 'json',
        page: '20',
        fields: 'group_photo,photo_count,photo_sample',
        radius: radius,
        zip: zipcode,
        city: city
    }
    outdoor_events = meetup_api.open_events(p)
    @outdoor_events = outdoor_events['results']

    if @outdoor_events != nil
      @outdoor_events.each do |event|
        if event['photo_count'] > 0
          event['photo'] = event['photo_sample'][0]['photo_link']
        else
          if event['group']['group_photo'].present?
            event['photo'] = event['group']['group_photo']['photo_link']
          end
        end
      end
    end

    p = {
        category: '32',
        format: 'json',
        page: '20',
        fields: 'group_photo,photo_count,photo_sample',
        radius: radius,
        zip: zipcode,
        city: city
    }
    sports_events = meetup_api.open_events(p)
    @sports_events = sports_events['results']

    if @sports_events != nil
      @sports_events.each do |event|
        if event['photo_count'] > 0
          event['photo'] = event['photo_sample'][0]['photo_link']
        else
          if event['group']['group_photo'].present?
            event['photo'] = event['group']['group_photo']['photo_link']
          end
        end
      end
    end
  end

  # meetup_events/detailed_event/:id
  def detailed_event
    puts params[:event]
    event_id = params[:event]

    meetup_api = MeetupApi.new
    p = {
        format: 'json',
        fields: 'group_photo,photo_count,photo_sample',
        event_id: event_id
    }
    event = meetup_api.events(p)
    @detailed_event = event['results'][0]

    if @detailed_event != nil
      if @detailed_event['photo_count'] > 0
        @detailed_event['photo'] = @detailed_event['photo_sample'][0]['photo_link']
      else
        if @detailed_event['group']['group_photo'].present?
          @detailed_event['photo'] = @detailed_event['group']['group_photo']['photo_link']
        end
      end
    end
  end

  def join
    puts params[:event]
    selected_event = params[:event]
    redirect_to selected_event[:event_url]
  end
end
