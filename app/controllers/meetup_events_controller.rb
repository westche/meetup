class Radius < ApplicationController
  RADIUS = [
      ['Radius : 10 miles', '10'],
      ['Radius : 20 miles', '20'],
      ['Radius : 30 miles', '30'],
      ['Radius : 40 miles', '40'],
      ['Radius : 50 miles', '50'],
      ['Radius : 60 miles', '60'],
      ['Radius : 70 miles', '70'],
      ['Radius : 80 miles', '80'],
      ['Radius : 90 miles', '90'],
      ['Radius : 100 miles', '100']
  ].freeze
end

class MeetupEventsController < ApplicationController
  def index
    @radius = 50
  end

  def search
    @zipcode = params[:zipcode]
    @radius = params[:radius]
    @keyword = params[:keyword]

    meetup_api = MeetupApi.new
    # p = {
    #     category: '9',
    #     format: 'json',
    #     page: '20',
    #     fields: 'group_photo,photo_count,photo_sample',
    #     radius: @radius,
    #     zip: @zipcode,
    #     text: @keyword
    # }

    p = {
        category: '9',
        format: 'json',
        page: '20',
        fields: 'group_photo,photo_count,photo_sample',
        radius: @radius,
        zip: @zipcode
    }

    fitness_events = meetup_api.open_events(p)
    @fitness_events = fitness_events['results']

    if @fitness_events != nil
      @fitness_events.each do |event|
        if event['photo_count'] > 0
          event['photo'] = event['photo_sample'][0]['highres_link']
        else
          if event['group']['group_photo'].present?
            event['photo'] = event['group']['group_photo']['highres_link']
          end
        end
      end
    end

    # p = {
    #     category: '23',
    #     format: 'json',
    #     page: '20',
    #     fields: 'group_photo,photo_count,photo_sample',
    #     radius: @radius,
    #     zip: @zipcode,
    #     text: @keyword
    # }

    p = {
        category: '23',
        format: 'json',
        page: '20',
        fields: 'group_photo,photo_count,photo_sample',
        radius: @radius,
        zip: @zipcode
    }
    outdoor_events = meetup_api.open_events(p)
    @outdoor_events = outdoor_events['results']

    if @outdoor_events != nil
      @outdoor_events.each do |event|
        if event['photo_count'] > 0
          event['photo'] = event['photo_sample'][0]['highres_link']
        else
          if event['group']['group_photo'].present?
            event['photo'] = event['group']['group_photo']['highres_link']
          end
        end
      end
    end

    # p = {
    #     category: '32',
    #     format: 'json',
    #     page: '20',
    #     fields: 'group_photo,photo_count,photo_sample',
    #     radius: @radius,
    #     zip: @zipcode,
    #     text: @keyword
    # }

    p = {
        category: '32',
        format: 'json',
        page: '20',
        fields: 'group_photo,photo_count,photo_sample',
        radius: @radius,
        zip: @zipcode
    }
    sports_events = meetup_api.open_events(p)
    @sports_events = sports_events['results']

    if @sports_events != nil
      @sports_events.each do |event|
        if event['photo_count'] > 0
          event['photo'] = event['photo_sample'][0]['highres_link']
        else
          if event['group']['group_photo'].present?
            event['photo'] = event['group']['group_photo']['highres_link']
          end
        end
      end
    end
  end

  # meetup_events/detailed_event/:id
  def detailed_event
    @radius = 50
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
        @detailed_event['photo'] = @detailed_event['photo_sample'][0]['highres_link']
      else
        if @detailed_event['group']['group_photo'].present?
          @detailed_event['photo'] = @detailed_event['group']['group_photo']['highres_link']
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
