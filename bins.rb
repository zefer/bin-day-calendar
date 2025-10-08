# encoding: UTF-8

require 'net/http'
require 'nokogiri'
require 'pry'
require 'icalendar'

class Bins
  TYPES = {
    'Refuse' => '🗑 Black',
    'Green' => '🌿 Garden',
    'Paper' => '🗞 Paper/Card',
    'Recycling' => '🍾 Glass/Cans/Plastic'
  }.freeze

  def initialize
    # Visit the URL below, enter your postcode, copy the ID from the end of the
    # resulting URL (e.g. 10000123456).
    # https://www.cumberland.gov.uk/bins-recycling-and-street-cleaning/waste-collections/bin-collection-schedule
    @address_id = ENV.fetch('ADDRESS_ID')
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
    collections[collections.keys.last].unshift("⚠️ End of Bin Calendar")
    collections
  end

  def parse_html_to_collections(html)
    collections = {}
    doc = Nokogiri::HTML(html, nil, 'UTF-8')

    doc.css('.waste-collection__day').each do |row|
      date = Date.parse(row.css('time')[0].attributes['datetime'].value)
      collections[date] ||= []
      type = row.css('.waste-collection__day--colour')[0].inner_html.strip

      collections[date] << TYPES[type]
    end

    collections
  end

  def fetch_bins
    uri = URI("https://www.cumberland.gov.uk/bins-recycling-and-street-cleaning/waste-collections/bin-collection-schedule/view/#{@address_id}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri)

    http.request(request)
  end
end

Bins.new.run
