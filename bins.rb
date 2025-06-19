# encoding: UTF-8

require 'net/http'
require 'nokogiri'
require 'pry'
require 'icalendar'

# Take the HTML from the Cumberland bin calendar and parse it into an ICS file
# which can be imported into a calendar.
# https://selfservice-cumberland.servicebuilder.co.uk/renderform?t=25&k=E43CEB1FB59F859833EF2D52B16F3F4EBE1CAB6A
class Bins
  TYPES = {
    'Refuse' => '🗑 Black',
    'Green' => '🌿 Garden',
    'Paper' => '🗞 Paper/Card',
    'Recycling' => '🍾 Glass/Cans/Plastic'
  }.freeze

  def initialize
    @session_id = ENV.fetch('COOKIE_ASPNET_SESSION_ID')
    @cookie_verification_token = ENV.fetch('COOKIE_VERIFICATION_TOKEN')
    @header_verification_token = ENV.fetch('HEADER_REQUEST_VERIFICATION_TOKEN')
    @form_post_code = ENV.fetch('FORM_POST_CODE')
    @form_selection_id = ENV.fetch('FORM_SELECTION_ID')
  end

  def run(from_cache: false)
    body = if from_cache
             File.read('response.cache')
           else
             fetch_bins.body.tap { |s| File.open('response.cache', 'w') { |f| f.write(s) } }
           end

    collections = parse_html_to_collections(body)
    collections = add_calendar_end_event(collections)
    calendar = collections_to_calendar(collections)
    File.open('bins.ics', 'w') { |f| f.write(calendar.to_ical) }
  end

  private

  def collections_to_calendar(collections)
    cal = Icalendar::Calendar.new

    collections.each_pair do |date, labels|
      event = Icalendar::Event.new
      event.dtstart = Icalendar::Values::Date.new(date)
      event.dtend = Icalendar::Values::Date.new(date + 1)
      event.summary = labels.join(' ')
      cal.add_event(event)
    end

    cal
  end

  def add_calendar_end_event(collections)
    collections[collections.keys.last] << "⚠️ End of Bin Calendar"
    collections
  end

  def parse_html_to_collections(html)
    collections = {}
    doc = Nokogiri::HTML(html, nil, 'UTF-8')

    doc.css('.resirow').each do |row|
      icon = row.css('.col')[0]
      date = Date.parse(row.css('.col')[1].text.strip)
      collections[date] ||= []
      type = (icon.attribute('class').value.split(' ') & TYPES.keys).first

      collections[date] << TYPES[type]
    end

    collections
  end

  def fetch_bins
    uri = URI('https://selfservice-cumberland.servicebuilder.co.uk/renderform/Form')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    cookie = "ASP.NET_SessionId=#{@session_id}; __RequestVerificationToken=#{@cookie_verification_token}"

    request = Net::HTTP::Post.new(uri)
    request['Cookie'] = cookie
    request.set_form_data(
      '__RequestVerificationToken': @header_verification_token,
      'FormGuid': '0762556a-22bf-4899-b80d-ef0ea01a444f',
      'ObjectTemplateID': '25',
      'Trigger': 'submit',
      'CurrentSectionID': @form_selection_id.to_s,
      'TriggerCtl': '',
      'FF265': 'U10000884980',
      'FF265lbltxt': 'Please select your address',
      'FF265-text': @form_post_code
    )

    http.request(request)
  end
end

Bins.new.run
