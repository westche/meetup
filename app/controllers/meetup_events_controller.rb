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

class Period < ApplicationController
  PERIOD = [
      ['This Week', 'this_week'],
      ['Next Week', 'next_week'],
      ['This Month', 'this_month'],
      ['All Events', 'all']
  ].freeze
end

class MeetupEventsController < ApplicationController
  def index
    @radius = 50
    @period = 'all'
  end

  def search
    @city = params[:city]
    @radius = params[:radius]
    @period = params[:period]
    @keyword = params[:keyword]

    # @message = ''

    @events = self.search_events(@city, @radius, @period, @keyword)

    if @events.empty?
      @recommended_events = self.search_events(@city, @radius, @period, '')
    end
  end

  # meetup_events/detailed_event/:id
  def detailed_event
    @radius = params[:radius]
    @city = params[:city]
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

  def search_events(cityname, radius, period, keyword)
    meetup_api = MeetupApi.new
    search_events = []
    zipcode = cityname

    if !is_number?( cityname )
      p = {
          country: 'US',
          query: cityname,
          page: '20'
      }

      cities = meetup_api.cities(p)
      cities_result = cities['results']

      if cities_result.any?
        city = cities_result[0]
        zipcode = city['zip']
      else
        @message = 'Please retype your city or zipcode'
        return search_events
      end
    end

    today = DateTime.now

    case period
      when 'this_week'
        first_day = Date.commercial(today.cwyear, today.cweek) - 1
        last_day = Date.commercial(today.cwyear, today.cweek, 6)
      when 'next_week'
        first_day = Date.commercial(today.cwyear, today.cweek + 1) - 1
        last_day = Date.commercial(today.cwyear, today.cweek + 1, 6)
      when 'this_month'
        first_day = Date.today.beginning_of_month
        last_day = Date.today.end_of_month
      when 'all'
        first_day = Date.today.beginning_of_year
        last_day = Date.today.end_of_year
      else
        first_day = Date.today.beginning_of_year
        last_day = Date.today.end_of_year
    end

    time = first_day.strftime('%Q') + ',' + last_day.strftime('%Q')

    p = {
        category: '9',
        format: 'json',
        page: '50',
        fields: 'group_photo,photo_count,photo_sample',
        text_format: 'plain',
        radius: radius,
        zip: zipcode,
        time: time
    }

    fitness_events = meetup_api.open_events(p)
    fitness_event_result = fitness_events['results']

    if fitness_event_result != nil
      fitness_event_result.each do |event|
        if event['photo_count'] > 0
          event['photo'] = event['photo_sample'][0]['highres_link']
        else
          if event['group']['group_photo'].present?
            event['photo'] = event['group']['group_photo']['highres_link']
          end
        end

        if event['description'] != nil
          if keyword != nil
            if (event['description'].include? keyword) || (event['name'].include? keyword) || (event['group']['name'].include? keyword)
              search_events.push(event)
            end
          else
            search_events.push(event)
          end

          length = event['description'].length

          if length > 120
            description = event['description']
            event['desc'] = description[0, 120] + '...'
          end
        end
      end
    end

    p = {
        category: '23',
        format: 'json',
        page: '20',
        fields: 'group_photo,photo_count,photo_sample',
        text_format: 'plain',
        radius: radius,
        zip: zipcode,
        time: time
    }
    outdoor_events = meetup_api.open_events(p)
    outdoor_event_result = outdoor_events['results']

    if outdoor_event_result != nil
      outdoor_event_result.each do |event|
        if event['photo_count'] > 0
          event['photo'] = event['photo_sample'][0]['highres_link']
        else
          if event['group']['group_photo'].present?
            event['photo'] = event['group']['group_photo']['highres_link']
          end
        end

        if event['description'] != nil
          if keyword != nil
            if (event['description'].include? keyword) || (event['name'].include? keyword) || (event['group']['name'].include? keyword)
              search_events.push(event)
            end
          else
            search_events.push(event)
          end
          length = event['description'].length

          if length > 120
            description = event['description']
            event['desc'] = description[0, 120] + '...'
          end
        end
      end
    end

    p = {
        category: '32',
        format: 'json',
        page: '50',
        fields: 'group_photo,photo_count,photo_sample',
        text_format: 'plain',
        radius: radius,
        zip: zipcode,
        time: time
    }
    sports_events = meetup_api.open_events(p)
    sports_event_result = sports_events['results']

    if sports_event_result != nil
      sports_event_result.each do |event|
        if event['photo_count'] > 0
          event['photo'] = event['photo_sample'][0]['highres_link']
        else
          if event['group']['group_photo'].present?
            event['photo'] = event['group']['group_photo']['highres_link']
          end
        end

        if event['description'] != nil
          if keyword != nil
            if (event['description'].include? keyword) || (event['name'].include? keyword) || (event['group']['name'].include? keyword)
              search_events.push(event)
            end
          else
            search_events.push(event)
          end
          length = event['description'].length

          if length > 120
            description = event['description']
            event['desc'] = description[0, 120] + '...'
          end
        end
      end
    end

    if search_events.empty?
      @message = 'There are currently not any "' + keyword + '"events in your area. Instead, check out some of these other awesome events. '
    end

    return search_events
  end

  def is_number? string
    true if Float(string) rescue false
  end
end
