# encoding: UTF-8

require 'nokogiri'
require 'open-uri'
require 'pry'
require 'icalendar'

# Take the HTML from the Allerdale bin calendar (link below) and parse it into
# an ICS file which can be imported into a calendar.
# TODO: Consider getting the data directly from an HTTP GET or POST.
# https://www.allerdale.gov.uk/en/bincollections/
class Bins
  TYPES = {
    '.fa-trash-alt': '🗑 Black',
    '.fa-leaf': '🌿 Garden',
    '.fa-newspaper': '🗞 Paper/Card',
    '.fa-wine-bottle': '🍾 Glass/Cans/Plastic'
  }.freeze

  def run
    collections = parse_html_to_collections(DATA)
    calendar = collections_to_calendar(collections)

    File.open('bins.ics', 'w') { |f| f.write(calendar.to_ical) }
  end

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

  def parse_html_to_collections(html)
    collections = {}
    doc = Nokogiri::HTML(html, nil, 'UTF-8')

    doc.css('table.month').each do |month|
      my = month.text.strip.scan(/^\w*\s\d*/).first
      days = month.css('td.collection-day')
      days.each do |collection|
        d = collection.text.strip
        date = Date.parse("#{d} #{my}")
        bins = []

        TYPES.each_pair do |css, label|
          next if collection.css(css).empty?

          bins << label
        end

        collections[date] = bins
      end
    end

    collections
  end
end

Bins.new.run

__END__
<div class="row year row-equal-height">
	<div class="col-xs-12 col-sm-6 col-md-4" style="height: 371px;">
		<table class="table month" cellspacing="0" cellpadding="0" border="0">
			<tbody>
				<tr>
					<th class="month" colspan="7">April 2022</th>
				</tr>
				<tr>
					<th class="mon">Mon</th>
					<th class="tue">Tue</th>
					<th class="wed">Wed</th>
					<th class="thu">Thu</th>
					<th class="fri">Fri</th>
					<th class="sat">Sat</th>
					<th class="sun">Sun</th>
				</tr>
				<tr>
					<td class="noday">&nbsp;</td>
					<td class="noday">&nbsp;</td>
					<td class="noday">&nbsp;</td>
					<td class="noday">&nbsp;</td>
					<td class="fri">1
						<div class="no-collections"></div>
					</td>
					<td class="sat">2
						<div class="no-collections"></div>
					</td>
					<td class="sun">3
						<div class="no-collections"></div>
					</td>
				</tr>
				<tr>
					<td class="mon">4
						<div class="no-collections"></div>
					</td>
					<td class="tue">5
						<div class="no-collections"></div>
					</td>
					<td class="wed">6
						<div class="no-collections"></div>
					</td>
					<td class="thu collection-day">7
						<div class="collections">
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#666666"></i>
								<i class="fas fa-trash-alt fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#32cd32"></i>
								<i class="fas fa-leaf fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#0000ff"></i>
								<i class="fas fa-newspaper fa-stack-1x fa-inverse"></i>
							</span>
						</div>
					</td>
					<td class="fri">8
						<div class="no-collections"></div>
					</td>
					<td class="sat">9
						<div class="no-collections"></div>
					</td>
					<td class="sun">10
						<div class="no-collections"></div>
					</td>
				</tr>
				<tr>
					<td class="mon">11
						<div class="no-collections"></div>
					</td>
					<td class="tue">12
						<div class="no-collections"></div>
					</td>
					<td class="wed">13
						<div class="no-collections"></div>
					</td>
					<td class="thu collection-day">14
						<div class="collections">
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#666666"></i>
								<i class="fas fa-trash-alt fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#ff8c00"></i>
								<i class="fas fa-wine-bottle fa-stack-1x fa-inverse"></i>
							</span>
						</div>
					</td>
					<td class="fri">15
						<div class="no-collections"></div>
					</td>
					<td class="sat">16
						<div class="no-collections"></div>
					</td>
					<td class="sun">17
						<div class="no-collections"></div>
					</td>
				</tr>
				<tr>
					<td class="mon">18
						<div class="no-collections"></div>
					</td>
					<td class="tue">19
						<div class="no-collections"></div>
					</td>
					<td class="wed">20
						<div class="no-collections"></div>
					</td>
					<td class="thu">21
						<div class="no-collections"></div>
					</td>
					<td class="fri collection-day">22
						<div class="collections">
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#666666"></i>
								<i class="fas fa-trash-alt fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#32cd32"></i>
								<i class="fas fa-leaf fa-stack-1x fa-inverse"></i>
							</span>
						</div>
					</td>
					<td class="sat">23
						<div class="no-collections"></div>
					</td>
					<td class="sun">24
						<div class="no-collections"></div>
					</td>
				</tr>
				<tr>
					<td class="mon">25
						<div class="no-collections"></div>
					</td>
					<td class="tue">26
						<div class="no-collections"></div>
					</td>
					<td class="wed">27
						<div class="no-collections"></div>
					</td>
					<td class="thu collection-day">28
						<div class="collections">
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#666666"></i>
								<i class="fas fa-trash-alt fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#ff8c00"></i>
								<i class="fas fa-wine-bottle fa-stack-1x fa-inverse"></i>
							</span>
						</div>
					</td>
					<td class="fri">29
						<div class="no-collections"></div>
					</td>
					<td class="sat">30
						<div class="no-collections"></div>
					</td>
					<td class="noday">&nbsp;</td>
				</tr>
			</tbody>
		</table>
	</div>
	<div class="col-xs-12 col-sm-6 col-md-4" style="height: 371px;">
		<table class="table month" cellspacing="0" cellpadding="0" border="0">
			<tbody>
				<tr>
					<th class="month" colspan="7">May 2022</th>
				</tr>
				<tr>
					<th class="mon">Mon</th>
					<th class="tue">Tue</th>
					<th class="wed">Wed</th>
					<th class="thu">Thu</th>
					<th class="fri">Fri</th>
					<th class="sat">Sat</th>
					<th class="sun">Sun</th>
				</tr>
				<tr>
					<td class="noday">&nbsp;</td>
					<td class="noday">&nbsp;</td>
					<td class="noday">&nbsp;</td>
					<td class="noday">&nbsp;</td>
					<td class="noday">&nbsp;</td>
					<td class="noday">&nbsp;</td>
					<td class="sun">1
						<div class="no-collections"></div>
					</td>
				</tr>
				<tr>
					<td class="mon">2
						<div class="no-collections"></div>
					</td>
					<td class="tue">3
						<div class="no-collections"></div>
					</td>
					<td class="wed">4
						<div class="no-collections"></div>
					</td>
					<td class="thu">5
						<div class="no-collections"></div>
					</td>
					<td class="fri collection-day">6
						<div class="collections">
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#666666"></i>
								<i class="fas fa-trash-alt fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#32cd32"></i>
								<i class="fas fa-leaf fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#0000ff"></i>
								<i class="fas fa-newspaper fa-stack-1x fa-inverse"></i>
							</span>
						</div>
					</td>
					<td class="sat">7
						<div class="no-collections"></div>
					</td>
					<td class="sun">8
						<div class="no-collections"></div>
					</td>
				</tr>
				<tr>
					<td class="mon">9
						<div class="no-collections"></div>
					</td>
					<td class="tue">10
						<div class="no-collections"></div>
					</td>
					<td class="wed">11
						<div class="no-collections"></div>
					</td>
					<td class="thu collection-day">12
						<div class="collections">
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#666666"></i>
								<i class="fas fa-trash-alt fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#ff8c00"></i>
								<i class="fas fa-wine-bottle fa-stack-1x fa-inverse"></i>
							</span>
						</div>
					</td>
					<td class="fri">13
						<div class="no-collections"></div>
					</td>
					<td class="sat">14
						<div class="no-collections"></div>
					</td>
					<td class="sun">15
						<div class="no-collections"></div>
					</td>
				</tr>
				<tr>
					<td class="mon">16
						<div class="no-collections"></div>
					</td>
					<td class="tue">17
						<div class="no-collections"></div>
					</td>
					<td class="wed">18
						<div class="no-collections"></div>
					</td>
					<td class="thu collection-day">19
						<div class="collections">
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#666666"></i>
								<i class="fas fa-trash-alt fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#32cd32"></i>
								<i class="fas fa-leaf fa-stack-1x fa-inverse"></i>
							</span>
						</div>
					</td>
					<td class="fri">20
						<div class="no-collections"></div>
					</td>
					<td class="sat">21
						<div class="no-collections"></div>
					</td>
					<td class="sun">22
						<div class="no-collections"></div>
					</td>
				</tr>
				<tr>
					<td class="mon">23
						<div class="no-collections"></div>
					</td>
					<td class="tue">24
						<div class="no-collections"></div>
					</td>
					<td class="wed">25
						<div class="no-collections"></div>
					</td>
					<td class="thu collection-day">26
						<div class="collections">
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#666666"></i>
								<i class="fas fa-trash-alt fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#ff8c00"></i>
								<i class="fas fa-wine-bottle fa-stack-1x fa-inverse"></i>
							</span>
						</div>
					</td>
					<td class="fri">27
						<div class="no-collections"></div>
					</td>
					<td class="sat">28
						<div class="no-collections"></div>
					</td>
					<td class="sun">29
						<div class="no-collections"></div>
					</td>
				</tr>
				<tr>
					<td class="mon">30
						<div class="no-collections"></div>
					</td>
					<td class="tue">31
						<div class="no-collections"></div>
					</td>
					<td class="noday">&nbsp;</td>
					<td class="noday">&nbsp;</td>
					<td class="noday">&nbsp;</td>
					<td class="noday">&nbsp;</td>
					<td class="noday">&nbsp;</td>
				</tr>
			</tbody>
		</table>
	</div>
	<div class="col-xs-12 col-sm-6 col-md-4" style="height: 371px;">
		<table class="table month" cellspacing="0" cellpadding="0" border="0">
			<tbody>
				<tr>
					<th class="month" colspan="7">June 2022</th>
				</tr>
				<tr>
					<th class="mon">Mon</th>
					<th class="tue">Tue</th>
					<th class="wed">Wed</th>
					<th class="thu">Thu</th>
					<th class="fri">Fri</th>
					<th class="sat">Sat</th>
					<th class="sun">Sun</th>
				</tr>
				<tr>
					<td class="noday">&nbsp;</td>
					<td class="noday">&nbsp;</td>
					<td class="wed">1
						<div class="no-collections"></div>
					</td>
					<td class="thu collection-day">2
						<div class="collections">
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#666666"></i>
								<i class="fas fa-trash-alt fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#32cd32"></i>
								<i class="fas fa-leaf fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#0000ff"></i>
								<i class="fas fa-newspaper fa-stack-1x fa-inverse"></i>
							</span>
						</div>
					</td>
					<td class="fri">3
						<div class="no-collections"></div>
					</td>
					<td class="sat">4
						<div class="no-collections"></div>
					</td>
					<td class="sun">5
						<div class="no-collections"></div>
					</td>
				</tr>
				<tr>
					<td class="mon">6
						<div class="no-collections"></div>
					</td>
					<td class="tue">7
						<div class="no-collections"></div>
					</td>
					<td class="wed">8
						<div class="no-collections"></div>
					</td>
					<td class="thu collection-day">9
						<div class="collections">
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#666666"></i>
								<i class="fas fa-trash-alt fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#ff8c00"></i>
								<i class="fas fa-wine-bottle fa-stack-1x fa-inverse"></i>
							</span>
						</div>
					</td>
					<td class="fri">10
						<div class="no-collections"></div>
					</td>
					<td class="sat">11
						<div class="no-collections"></div>
					</td>
					<td class="sun">12
						<div class="no-collections"></div>
					</td>
				</tr>
				<tr>
					<td class="mon">13
						<div class="no-collections"></div>
					</td>
					<td class="tue">14
						<div class="no-collections"></div>
					</td>
					<td class="wed">15
						<div class="no-collections"></div>
					</td>
					<td class="thu collection-day">16
						<div class="collections">
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#666666"></i>
								<i class="fas fa-trash-alt fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#32cd32"></i>
								<i class="fas fa-leaf fa-stack-1x fa-inverse"></i>
							</span>
						</div>
					</td>
					<td class="fri">17
						<div class="no-collections"></div>
					</td>
					<td class="sat">18
						<div class="no-collections"></div>
					</td>
					<td class="sun">19
						<div class="no-collections"></div>
					</td>
				</tr>
				<tr>
					<td class="mon">20
						<div class="no-collections"></div>
					</td>
					<td class="tue">21
						<div class="no-collections"></div>
					</td>
					<td class="wed">22
						<div class="no-collections"></div>
					</td>
					<td class="thu collection-day">23
						<div class="collections">
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#666666"></i>
								<i class="fas fa-trash-alt fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#ff8c00"></i>
								<i class="fas fa-wine-bottle fa-stack-1x fa-inverse"></i>
							</span>
						</div>
					</td>
					<td class="fri">24
						<div class="no-collections"></div>
					</td>
					<td class="sat">25
						<div class="no-collections"></div>
					</td>
					<td class="sun">26
						<div class="no-collections"></div>
					</td>
				</tr>
				<tr>
					<td class="mon">27
						<div class="no-collections"></div>
					</td>
					<td class="tue">28
						<div class="no-collections"></div>
					</td>
					<td class="wed">29
						<div class="no-collections"></div>
					</td>
					<td class="thu collection-day">30
						<div class="collections">
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#666666"></i>
								<i class="fas fa-trash-alt fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#32cd32"></i>
								<i class="fas fa-leaf fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#0000ff"></i>
								<i class="fas fa-newspaper fa-stack-1x fa-inverse"></i>
							</span>
						</div>
					</td>
					<td class="noday">&nbsp;</td>
					<td class="noday">&nbsp;</td>
					<td class="noday">&nbsp;</td>
				</tr>
			</tbody>
		</table>
	</div>
	<div class="col-xs-12 col-sm-6 col-md-4" style="height: 326px;">
		<table class="table month" cellspacing="0" cellpadding="0" border="0">
			<tbody>
				<tr>
					<th class="month" colspan="7">July 2022</th>
				</tr>
				<tr>
					<th class="mon">Mon</th>
					<th class="tue">Tue</th>
					<th class="wed">Wed</th>
					<th class="thu">Thu</th>
					<th class="fri">Fri</th>
					<th class="sat">Sat</th>
					<th class="sun">Sun</th>
				</tr>
				<tr>
					<td class="noday">&nbsp;</td>
					<td class="noday">&nbsp;</td>
					<td class="noday">&nbsp;</td>
					<td class="noday">&nbsp;</td>
					<td class="fri">1
						<div class="no-collections"></div>
					</td>
					<td class="sat">2
						<div class="no-collections"></div>
					</td>
					<td class="sun">3
						<div class="no-collections"></div>
					</td>
				</tr>
				<tr>
					<td class="mon">4
						<div class="no-collections"></div>
					</td>
					<td class="tue">5
						<div class="no-collections"></div>
					</td>
					<td class="wed">6
						<div class="no-collections"></div>
					</td>
					<td class="thu collection-day">7
						<div class="collections">
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#666666"></i>
								<i class="fas fa-trash-alt fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#ff8c00"></i>
								<i class="fas fa-wine-bottle fa-stack-1x fa-inverse"></i>
							</span>
						</div>
					</td>
					<td class="fri">8
						<div class="no-collections"></div>
					</td>
					<td class="sat">9
						<div class="no-collections"></div>
					</td>
					<td class="sun">10
						<div class="no-collections"></div>
					</td>
				</tr>
				<tr>
					<td class="mon">11
						<div class="no-collections"></div>
					</td>
					<td class="tue">12
						<div class="no-collections"></div>
					</td>
					<td class="wed">13
						<div class="no-collections"></div>
					</td>
					<td class="thu collection-day">14
						<div class="collections">
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#666666"></i>
								<i class="fas fa-trash-alt fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#32cd32"></i>
								<i class="fas fa-leaf fa-stack-1x fa-inverse"></i>
							</span>
						</div>
					</td>
					<td class="fri">15
						<div class="no-collections"></div>
					</td>
					<td class="sat">16
						<div class="no-collections"></div>
					</td>
					<td class="sun">17
						<div class="no-collections"></div>
					</td>
				</tr>
				<tr>
					<td class="mon">18
						<div class="no-collections"></div>
					</td>
					<td class="tue">19
						<div class="no-collections"></div>
					</td>
					<td class="wed">20
						<div class="no-collections"></div>
					</td>
					<td class="thu collection-day">21
						<div class="collections">
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#666666"></i>
								<i class="fas fa-trash-alt fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#ff8c00"></i>
								<i class="fas fa-wine-bottle fa-stack-1x fa-inverse"></i>
							</span>
						</div>
					</td>
					<td class="fri">22
						<div class="no-collections"></div>
					</td>
					<td class="sat">23
						<div class="no-collections"></div>
					</td>
					<td class="sun">24
						<div class="no-collections"></div>
					</td>
				</tr>
				<tr>
					<td class="mon">25
						<div class="no-collections"></div>
					</td>
					<td class="tue">26
						<div class="no-collections"></div>
					</td>
					<td class="wed">27
						<div class="no-collections"></div>
					</td>
					<td class="thu collection-day">28
						<div class="collections">
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#666666"></i>
								<i class="fas fa-trash-alt fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#32cd32"></i>
								<i class="fas fa-leaf fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#0000ff"></i>
								<i class="fas fa-newspaper fa-stack-1x fa-inverse"></i>
							</span>
						</div>
					</td>
					<td class="fri">29
						<div class="no-collections"></div>
					</td>
					<td class="sat">30
						<div class="no-collections"></div>
					</td>
					<td class="sun">31
						<div class="no-collections"></div>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
	<div class="col-xs-12 col-sm-6 col-md-4" style="height: 326px;">
		<table class="table month" cellspacing="0" cellpadding="0" border="0">
			<tbody>
				<tr>
					<th class="month" colspan="7">August 2022</th>
				</tr>
				<tr>
					<th class="mon">Mon</th>
					<th class="tue">Tue</th>
					<th class="wed">Wed</th>
					<th class="thu">Thu</th>
					<th class="fri">Fri</th>
					<th class="sat">Sat</th>
					<th class="sun">Sun</th>
				</tr>
				<tr>
					<td class="mon">1
						<div class="no-collections"></div>
					</td>
					<td class="tue">2
						<div class="no-collections"></div>
					</td>
					<td class="wed">3
						<div class="no-collections"></div>
					</td>
					<td class="thu collection-day">4
						<div class="collections">
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#666666"></i>
								<i class="fas fa-trash-alt fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#ff8c00"></i>
								<i class="fas fa-wine-bottle fa-stack-1x fa-inverse"></i>
							</span>
						</div>
					</td>
					<td class="fri">5
						<div class="no-collections"></div>
					</td>
					<td class="sat">6
						<div class="no-collections"></div>
					</td>
					<td class="sun">7
						<div class="no-collections"></div>
					</td>
				</tr>
				<tr>
					<td class="mon">8
						<div class="no-collections"></div>
					</td>
					<td class="tue">9
						<div class="no-collections"></div>
					</td>
					<td class="wed">10
						<div class="no-collections"></div>
					</td>
					<td class="thu collection-day">11
						<div class="collections">
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#666666"></i>
								<i class="fas fa-trash-alt fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#32cd32"></i>
								<i class="fas fa-leaf fa-stack-1x fa-inverse"></i>
							</span>
						</div>
					</td>
					<td class="fri">12
						<div class="no-collections"></div>
					</td>
					<td class="sat">13
						<div class="no-collections"></div>
					</td>
					<td class="sun">14
						<div class="no-collections"></div>
					</td>
				</tr>
				<tr>
					<td class="mon">15
						<div class="no-collections"></div>
					</td>
					<td class="tue">16
						<div class="no-collections"></div>
					</td>
					<td class="wed">17
						<div class="no-collections"></div>
					</td>
					<td class="thu collection-day">18
						<div class="collections">
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#666666"></i>
								<i class="fas fa-trash-alt fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#ff8c00"></i>
								<i class="fas fa-wine-bottle fa-stack-1x fa-inverse"></i>
							</span>
						</div>
					</td>
					<td class="fri">19
						<div class="no-collections"></div>
					</td>
					<td class="sat">20
						<div class="no-collections"></div>
					</td>
					<td class="sun">21
						<div class="no-collections"></div>
					</td>
				</tr>
				<tr>
					<td class="mon">22
						<div class="no-collections"></div>
					</td>
					<td class="tue">23
						<div class="no-collections"></div>
					</td>
					<td class="wed">24
						<div class="no-collections"></div>
					</td>
					<td class="thu collection-day">25
						<div class="collections">
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#666666"></i>
								<i class="fas fa-trash-alt fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#32cd32"></i>
								<i class="fas fa-leaf fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#0000ff"></i>
								<i class="fas fa-newspaper fa-stack-1x fa-inverse"></i>
							</span>
						</div>
					</td>
					<td class="fri">26
						<div class="no-collections"></div>
					</td>
					<td class="sat">27
						<div class="no-collections"></div>
					</td>
					<td class="sun">28
						<div class="no-collections"></div>
					</td>
				</tr>
				<tr>
					<td class="mon">29
						<div class="no-collections"></div>
					</td>
					<td class="tue">30
						<div class="no-collections"></div>
					</td>
					<td class="wed">31
						<div class="no-collections"></div>
					</td>
					<td class="noday">&nbsp;</td>
					<td class="noday">&nbsp;</td>
					<td class="noday">&nbsp;</td>
					<td class="noday">&nbsp;</td>
				</tr>
			</tbody>
		</table>
	</div>
	<div class="col-xs-12 col-sm-6 col-md-4" style="height: 326px;">
		<table class="table month" cellspacing="0" cellpadding="0" border="0">
			<tbody>
				<tr>
					<th class="month" colspan="7">September 2022</th>
				</tr>
				<tr>
					<th class="mon">Mon</th>
					<th class="tue">Tue</th>
					<th class="wed">Wed</th>
					<th class="thu">Thu</th>
					<th class="fri">Fri</th>
					<th class="sat">Sat</th>
					<th class="sun">Sun</th>
				</tr>
				<tr>
					<td class="noday">&nbsp;</td>
					<td class="noday">&nbsp;</td>
					<td class="noday">&nbsp;</td>
					<td class="thu">1
						<div class="no-collections"></div>
					</td>
					<td class="fri collection-day">2
						<div class="collections">
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#666666"></i>
								<i class="fas fa-trash-alt fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#ff8c00"></i>
								<i class="fas fa-wine-bottle fa-stack-1x fa-inverse"></i>
							</span>
						</div>
					</td>
					<td class="sat">3
						<div class="no-collections"></div>
					</td>
					<td class="sun">4
						<div class="no-collections"></div>
					</td>
				</tr>
				<tr>
					<td class="mon">5
						<div class="no-collections"></div>
					</td>
					<td class="tue">6
						<div class="no-collections"></div>
					</td>
					<td class="wed">7
						<div class="no-collections"></div>
					</td>
					<td class="thu collection-day">8
						<div class="collections">
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#666666"></i>
								<i class="fas fa-trash-alt fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#32cd32"></i>
								<i class="fas fa-leaf fa-stack-1x fa-inverse"></i>
							</span>
						</div>
					</td>
					<td class="fri">9
						<div class="no-collections"></div>
					</td>
					<td class="sat">10
						<div class="no-collections"></div>
					</td>
					<td class="sun">11
						<div class="no-collections"></div>
					</td>
				</tr>
				<tr>
					<td class="mon">12
						<div class="no-collections"></div>
					</td>
					<td class="tue">13
						<div class="no-collections"></div>
					</td>
					<td class="wed">14
						<div class="no-collections"></div>
					</td>
					<td class="thu collection-day">15
						<div class="collections">
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#666666"></i>
								<i class="fas fa-trash-alt fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#ff8c00"></i>
								<i class="fas fa-wine-bottle fa-stack-1x fa-inverse"></i>
							</span>
						</div>
					</td>
					<td class="fri">16
						<div class="no-collections"></div>
					</td>
					<td class="sat">17
						<div class="no-collections"></div>
					</td>
					<td class="sun">18
						<div class="no-collections"></div>
					</td>
				</tr>
				<tr>
					<td class="mon">19
						<div class="no-collections"></div>
					</td>
					<td class="tue">20
						<div class="no-collections"></div>
					</td>
					<td class="wed">21
						<div class="no-collections"></div>
					</td>
					<td class="thu collection-day">22
						<div class="collections">
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#666666"></i>
								<i class="fas fa-trash-alt fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#32cd32"></i>
								<i class="fas fa-leaf fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#0000ff"></i>
								<i class="fas fa-newspaper fa-stack-1x fa-inverse"></i>
							</span>
						</div>
					</td>
					<td class="fri">23
						<div class="no-collections"></div>
					</td>
					<td class="sat">24
						<div class="no-collections"></div>
					</td>
					<td class="sun">25
						<div class="no-collections"></div>
					</td>
				</tr>
				<tr>
					<td class="mon">26
						<div class="no-collections"></div>
					</td>
					<td class="tue">27
						<div class="no-collections"></div>
					</td>
					<td class="wed">28
						<div class="no-collections"></div>
					</td>
					<td class="thu collection-day">29
						<div class="collections">
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#666666"></i>
								<i class="fas fa-trash-alt fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#ff8c00"></i>
								<i class="fas fa-wine-bottle fa-stack-1x fa-inverse"></i>
							</span>
						</div>
					</td>
					<td class="fri">30
						<div class="no-collections"></div>
					</td>
					<td class="noday">&nbsp;</td>
					<td class="noday">&nbsp;</td>
				</tr>
			</tbody>
		</table>
	</div>
	<div class="col-xs-12 col-sm-6 col-md-4" style="height: 371px;">
		<table class="table month" cellspacing="0" cellpadding="0" border="0">
			<tbody>
				<tr>
					<th class="month" colspan="7">October 2022</th>
				</tr>
				<tr>
					<th class="mon">Mon</th>
					<th class="tue">Tue</th>
					<th class="wed">Wed</th>
					<th class="thu">Thu</th>
					<th class="fri">Fri</th>
					<th class="sat">Sat</th>
					<th class="sun">Sun</th>
				</tr>
				<tr>
					<td class="noday">&nbsp;</td>
					<td class="noday">&nbsp;</td>
					<td class="noday">&nbsp;</td>
					<td class="noday">&nbsp;</td>
					<td class="noday">&nbsp;</td>
					<td class="sat">1
						<div class="no-collections"></div>
					</td>
					<td class="sun">2
						<div class="no-collections"></div>
					</td>
				</tr>
				<tr>
					<td class="mon">3
						<div class="no-collections"></div>
					</td>
					<td class="tue">4
						<div class="no-collections"></div>
					</td>
					<td class="wed">5
						<div class="no-collections"></div>
					</td>
					<td class="thu collection-day">6
						<div class="collections">
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#666666"></i>
								<i class="fas fa-trash-alt fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#32cd32"></i>
								<i class="fas fa-leaf fa-stack-1x fa-inverse"></i>
							</span>
						</div>
					</td>
					<td class="fri">7
						<div class="no-collections"></div>
					</td>
					<td class="sat">8
						<div class="no-collections"></div>
					</td>
					<td class="sun">9
						<div class="no-collections"></div>
					</td>
				</tr>
				<tr>
					<td class="mon">10
						<div class="no-collections"></div>
					</td>
					<td class="tue">11
						<div class="no-collections"></div>
					</td>
					<td class="wed">12
						<div class="no-collections"></div>
					</td>
					<td class="thu collection-day">13
						<div class="collections">
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#666666"></i>
								<i class="fas fa-trash-alt fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#ff8c00"></i>
								<i class="fas fa-wine-bottle fa-stack-1x fa-inverse"></i>
							</span>
						</div>
					</td>
					<td class="fri">14
						<div class="no-collections"></div>
					</td>
					<td class="sat">15
						<div class="no-collections"></div>
					</td>
					<td class="sun">16
						<div class="no-collections"></div>
					</td>
				</tr>
				<tr>
					<td class="mon">17
						<div class="no-collections"></div>
					</td>
					<td class="tue">18
						<div class="no-collections"></div>
					</td>
					<td class="wed">19
						<div class="no-collections"></div>
					</td>
					<td class="thu collection-day">20
						<div class="collections">
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#666666"></i>
								<i class="fas fa-trash-alt fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#32cd32"></i>
								<i class="fas fa-leaf fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#0000ff"></i>
								<i class="fas fa-newspaper fa-stack-1x fa-inverse"></i>
							</span>
						</div>
					</td>
					<td class="fri">21
						<div class="no-collections"></div>
					</td>
					<td class="sat">22
						<div class="no-collections"></div>
					</td>
					<td class="sun">23
						<div class="no-collections"></div>
					</td>
				</tr>
				<tr>
					<td class="mon">24
						<div class="no-collections"></div>
					</td>
					<td class="tue">25
						<div class="no-collections"></div>
					</td>
					<td class="wed">26
						<div class="no-collections"></div>
					</td>
					<td class="thu collection-day">27
						<div class="collections">
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#666666"></i>
								<i class="fas fa-trash-alt fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#ff8c00"></i>
								<i class="fas fa-wine-bottle fa-stack-1x fa-inverse"></i>
							</span>
						</div>
					</td>
					<td class="fri">28
						<div class="no-collections"></div>
					</td>
					<td class="sat">29
						<div class="no-collections"></div>
					</td>
					<td class="sun">30
						<div class="no-collections"></div>
					</td>
				</tr>
				<tr>
					<td class="mon">31
						<div class="no-collections"></div>
					</td>
					<td class="noday">&nbsp;</td>
					<td class="noday">&nbsp;</td>
					<td class="noday">&nbsp;</td>
					<td class="noday">&nbsp;</td>
					<td class="noday">&nbsp;</td>
					<td class="noday">&nbsp;</td>
				</tr>
			</tbody>
		</table>
	</div>
	<div class="col-xs-12 col-sm-6 col-md-4" style="height: 371px;">
		<table class="table month" cellspacing="0" cellpadding="0" border="0">
			<tbody>
				<tr>
					<th class="month" colspan="7">November 2022</th>
				</tr>
				<tr>
					<th class="mon">Mon</th>
					<th class="tue">Tue</th>
					<th class="wed">Wed</th>
					<th class="thu">Thu</th>
					<th class="fri">Fri</th>
					<th class="sat">Sat</th>
					<th class="sun">Sun</th>
				</tr>
				<tr>
					<td class="noday">&nbsp;</td>
					<td class="tue">1
						<div class="no-collections"></div>
					</td>
					<td class="wed">2
						<div class="no-collections"></div>
					</td>
					<td class="thu collection-day">3
						<div class="collections">
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#666666"></i>
								<i class="fas fa-trash-alt fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#32cd32"></i>
								<i class="fas fa-leaf fa-stack-1x fa-inverse"></i>
							</span>
						</div>
					</td>
					<td class="fri">4
						<div class="no-collections"></div>
					</td>
					<td class="sat">5
						<div class="no-collections"></div>
					</td>
					<td class="sun">6
						<div class="no-collections"></div>
					</td>
				</tr>
				<tr>
					<td class="mon">7
						<div class="no-collections"></div>
					</td>
					<td class="tue">8
						<div class="no-collections"></div>
					</td>
					<td class="wed">9
						<div class="no-collections"></div>
					</td>
					<td class="thu collection-day">10
						<div class="collections">
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#666666"></i>
								<i class="fas fa-trash-alt fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#ff8c00"></i>
								<i class="fas fa-wine-bottle fa-stack-1x fa-inverse"></i>
							</span>
						</div>
					</td>
					<td class="fri">11
						<div class="no-collections"></div>
					</td>
					<td class="sat">12
						<div class="no-collections"></div>
					</td>
					<td class="sun">13
						<div class="no-collections"></div>
					</td>
				</tr>
				<tr>
					<td class="mon">14
						<div class="no-collections"></div>
					</td>
					<td class="tue">15
						<div class="no-collections"></div>
					</td>
					<td class="wed">16
						<div class="no-collections"></div>
					</td>
					<td class="thu collection-day">17
						<div class="collections">
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#666666"></i>
								<i class="fas fa-trash-alt fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#32cd32"></i>
								<i class="fas fa-leaf fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#0000ff"></i>
								<i class="fas fa-newspaper fa-stack-1x fa-inverse"></i>
							</span>
						</div>
					</td>
					<td class="fri">18
						<div class="no-collections"></div>
					</td>
					<td class="sat">19
						<div class="no-collections"></div>
					</td>
					<td class="sun">20
						<div class="no-collections"></div>
					</td>
				</tr>
				<tr>
					<td class="mon">21
						<div class="no-collections"></div>
					</td>
					<td class="tue">22
						<div class="no-collections"></div>
					</td>
					<td class="wed">23
						<div class="no-collections"></div>
					</td>
					<td class="thu collection-day">24
						<div class="collections">
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#666666"></i>
								<i class="fas fa-trash-alt fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#ff8c00"></i>
								<i class="fas fa-wine-bottle fa-stack-1x fa-inverse"></i>
							</span>
						</div>
					</td>
					<td class="fri">25
						<div class="no-collections"></div>
					</td>
					<td class="sat">26
						<div class="no-collections"></div>
					</td>
					<td class="sun">27
						<div class="no-collections"></div>
					</td>
				</tr>
				<tr>
					<td class="mon">28
						<div class="no-collections"></div>
					</td>
					<td class="tue">29
						<div class="no-collections"></div>
					</td>
					<td class="wed">30
						<div class="no-collections"></div>
					</td>
					<td class="noday">&nbsp;</td>
					<td class="noday">&nbsp;</td>
					<td class="noday">&nbsp;</td>
					<td class="noday">&nbsp;</td>
				</tr>
			</tbody>
		</table>
	</div>
	<div class="col-xs-12 col-sm-6 col-md-4" style="height: 371px;">
		<table class="table month" cellspacing="0" cellpadding="0" border="0">
			<tbody>
				<tr>
					<th class="month" colspan="7">December 2022</th>
				</tr>
				<tr>
					<th class="mon">Mon</th>
					<th class="tue">Tue</th>
					<th class="wed">Wed</th>
					<th class="thu">Thu</th>
					<th class="fri">Fri</th>
					<th class="sat">Sat</th>
					<th class="sun">Sun</th>
				</tr>
				<tr>
					<td class="noday">&nbsp;</td>
					<td class="noday">&nbsp;</td>
					<td class="noday">&nbsp;</td>
					<td class="thu collection-day">1
						<div class="collections">
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#666666"></i>
								<i class="fas fa-trash-alt fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#32cd32"></i>
								<i class="fas fa-leaf fa-stack-1x fa-inverse"></i>
							</span>
						</div>
					</td>
					<td class="fri">2
						<div class="no-collections"></div>
					</td>
					<td class="sat">3
						<div class="no-collections"></div>
					</td>
					<td class="sun">4
						<div class="no-collections"></div>
					</td>
				</tr>
				<tr>
					<td class="mon">5
						<div class="no-collections"></div>
					</td>
					<td class="tue">6
						<div class="no-collections"></div>
					</td>
					<td class="wed">7
						<div class="no-collections"></div>
					</td>
					<td class="thu collection-day">8
						<div class="collections">
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#666666"></i>
								<i class="fas fa-trash-alt fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#ff8c00"></i>
								<i class="fas fa-wine-bottle fa-stack-1x fa-inverse"></i>
							</span>
						</div>
					</td>
					<td class="fri">9
						<div class="no-collections"></div>
					</td>
					<td class="sat">10
						<div class="no-collections"></div>
					</td>
					<td class="sun">11
						<div class="no-collections"></div>
					</td>
				</tr>
				<tr>
					<td class="mon">12
						<div class="no-collections"></div>
					</td>
					<td class="tue">13
						<div class="no-collections"></div>
					</td>
					<td class="wed">14
						<div class="no-collections"></div>
					</td>
					<td class="thu collection-day">15
						<div class="collections">
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#666666"></i>
								<i class="fas fa-trash-alt fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#32cd32"></i>
								<i class="fas fa-leaf fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#0000ff"></i>
								<i class="fas fa-newspaper fa-stack-1x fa-inverse"></i>
							</span>
						</div>
					</td>
					<td class="fri">16
						<div class="no-collections"></div>
					</td>
					<td class="sat">17
						<div class="no-collections"></div>
					</td>
					<td class="sun">18
						<div class="no-collections"></div>
					</td>
				</tr>
				<tr>
					<td class="mon">19
						<div class="no-collections"></div>
					</td>
					<td class="tue">20
						<div class="no-collections"></div>
					</td>
					<td class="wed">21
						<div class="no-collections"></div>
					</td>
					<td class="thu collection-day">22
						<div class="collections">
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#666666"></i>
								<i class="fas fa-trash-alt fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#ff8c00"></i>
								<i class="fas fa-wine-bottle fa-stack-1x fa-inverse"></i>
							</span>
						</div>
					</td>
					<td class="fri">23
						<div class="no-collections"></div>
					</td>
					<td class="sat">24
						<div class="no-collections"></div>
					</td>
					<td class="sun">25
						<div class="no-collections"></div>
					</td>
				</tr>
				<tr>
					<td class="mon">26
						<div class="no-collections"></div>
					</td>
					<td class="tue">27
						<div class="no-collections"></div>
					</td>
					<td class="wed">28
						<div class="no-collections"></div>
					</td>
					<td class="thu">29
						<div class="no-collections"></div>
					</td>
					<td class="fri collection-day">30
						<div class="collections">
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#666666"></i>
								<i class="fas fa-trash-alt fa-stack-1x fa-inverse"></i>
							</span>
						</div>
					</td>
					<td class="sat">31
						<div class="no-collections"></div>
					</td>
					<td class="noday">&nbsp;</td>
				</tr>
			</tbody>
		</table>
	</div>
	<div class="col-xs-12 col-sm-6 col-md-4" style="height: 355px;">
		<table class="table month" cellspacing="0" cellpadding="0" border="0">
			<tbody>
				<tr>
					<th class="month" colspan="7">January 2023</th>
				</tr>
				<tr>
					<th class="mon">Mon</th>
					<th class="tue">Tue</th>
					<th class="wed">Wed</th>
					<th class="thu">Thu</th>
					<th class="fri">Fri</th>
					<th class="sat">Sat</th>
					<th class="sun">Sun</th>
				</tr>
				<tr>
					<td class="noday">&nbsp;</td>
					<td class="noday">&nbsp;</td>
					<td class="noday">&nbsp;</td>
					<td class="noday">&nbsp;</td>
					<td class="noday">&nbsp;</td>
					<td class="noday">&nbsp;</td>
					<td class="sun">1
						<div class="no-collections"></div>
					</td>
				</tr>
				<tr>
					<td class="mon">2
						<div class="no-collections"></div>
					</td>
					<td class="tue">3
						<div class="no-collections"></div>
					</td>
					<td class="wed">4
						<div class="no-collections"></div>
					</td>
					<td class="thu">5
						<div class="no-collections"></div>
					</td>
					<td class="fri collection-day">6
						<div class="collections">
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#666666"></i>
								<i class="fas fa-trash-alt fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#ff8c00"></i>
								<i class="fas fa-wine-bottle fa-stack-1x fa-inverse"></i>
							</span>
						</div>
					</td>
					<td class="sat">7
						<div class="no-collections"></div>
					</td>
					<td class="sun">8
						<div class="no-collections"></div>
					</td>
				</tr>
				<tr>
					<td class="mon">9
						<div class="no-collections"></div>
					</td>
					<td class="tue">10
						<div class="no-collections"></div>
					</td>
					<td class="wed">11
						<div class="no-collections"></div>
					</td>
					<td class="thu collection-day">12
						<div class="collections">
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#666666"></i>
								<i class="fas fa-trash-alt fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#0000ff"></i>
								<i class="fas fa-newspaper fa-stack-1x fa-inverse"></i>
							</span>
						</div>
					</td>
					<td class="fri">13
						<div class="no-collections"></div>
					</td>
					<td class="sat">14
						<div class="no-collections"></div>
					</td>
					<td class="sun">15
						<div class="no-collections"></div>
					</td>
				</tr>
				<tr>
					<td class="mon">16
						<div class="no-collections"></div>
					</td>
					<td class="tue">17
						<div class="no-collections"></div>
					</td>
					<td class="wed">18
						<div class="no-collections"></div>
					</td>
					<td class="thu collection-day">19
						<div class="collections">
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#666666"></i>
								<i class="fas fa-trash-alt fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#ff8c00"></i>
								<i class="fas fa-wine-bottle fa-stack-1x fa-inverse"></i>
							</span>
						</div>
					</td>
					<td class="fri">20
						<div class="no-collections"></div>
					</td>
					<td class="sat">21
						<div class="no-collections"></div>
					</td>
					<td class="sun">22
						<div class="no-collections"></div>
					</td>
				</tr>
				<tr>
					<td class="mon">23
						<div class="no-collections"></div>
					</td>
					<td class="tue">24
						<div class="no-collections"></div>
					</td>
					<td class="wed">25
						<div class="no-collections"></div>
					</td>
					<td class="thu collection-day">26
						<div class="collections">
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#666666"></i>
								<i class="fas fa-trash-alt fa-stack-1x fa-inverse"></i>
							</span>
						</div>
					</td>
					<td class="fri">27
						<div class="no-collections"></div>
					</td>
					<td class="sat">28
						<div class="no-collections"></div>
					</td>
					<td class="sun">29
						<div class="no-collections"></div>
					</td>
				</tr>
				<tr>
					<td class="mon">30
						<div class="no-collections"></div>
					</td>
					<td class="tue">31
						<div class="no-collections"></div>
					</td>
					<td class="noday">&nbsp;</td>
					<td class="noday">&nbsp;</td>
					<td class="noday">&nbsp;</td>
					<td class="noday">&nbsp;</td>
					<td class="noday">&nbsp;</td>
				</tr>
			</tbody>
		</table>
	</div>
	<div class="col-xs-12 col-sm-6 col-md-4" style="height: 355px;">
		<table class="table month" cellspacing="0" cellpadding="0" border="0">
			<tbody>
				<tr>
					<th class="month" colspan="7">February 2023</th>
				</tr>
				<tr>
					<th class="mon">Mon</th>
					<th class="tue">Tue</th>
					<th class="wed">Wed</th>
					<th class="thu">Thu</th>
					<th class="fri">Fri</th>
					<th class="sat">Sat</th>
					<th class="sun">Sun</th>
				</tr>
				<tr>
					<td class="noday">&nbsp;</td>
					<td class="noday">&nbsp;</td>
					<td class="wed">1
						<div class="no-collections"></div>
					</td>
					<td class="thu collection-day">2
						<div class="collections">
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#666666"></i>
								<i class="fas fa-trash-alt fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#ff8c00"></i>
								<i class="fas fa-wine-bottle fa-stack-1x fa-inverse"></i>
							</span>
						</div>
					</td>
					<td class="fri">3
						<div class="no-collections"></div>
					</td>
					<td class="sat">4
						<div class="no-collections"></div>
					</td>
					<td class="sun">5
						<div class="no-collections"></div>
					</td>
				</tr>
				<tr>
					<td class="mon">6
						<div class="no-collections"></div>
					</td>
					<td class="tue">7
						<div class="no-collections"></div>
					</td>
					<td class="wed">8
						<div class="no-collections"></div>
					</td>
					<td class="thu collection-day">9
						<div class="collections">
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#666666"></i>
								<i class="fas fa-trash-alt fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#0000ff"></i>
								<i class="fas fa-newspaper fa-stack-1x fa-inverse"></i>
							</span>
						</div>
					</td>
					<td class="fri">10
						<div class="no-collections"></div>
					</td>
					<td class="sat">11
						<div class="no-collections"></div>
					</td>
					<td class="sun">12
						<div class="no-collections"></div>
					</td>
				</tr>
				<tr>
					<td class="mon">13
						<div class="no-collections"></div>
					</td>
					<td class="tue">14
						<div class="no-collections"></div>
					</td>
					<td class="wed">15
						<div class="no-collections"></div>
					</td>
					<td class="thu collection-day">16
						<div class="collections">
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#666666"></i>
								<i class="fas fa-trash-alt fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#ff8c00"></i>
								<i class="fas fa-wine-bottle fa-stack-1x fa-inverse"></i>
							</span>
						</div>
					</td>
					<td class="fri">17
						<div class="no-collections"></div>
					</td>
					<td class="sat">18
						<div class="no-collections"></div>
					</td>
					<td class="sun">19
						<div class="no-collections"></div>
					</td>
				</tr>
				<tr>
					<td class="mon">20
						<div class="no-collections"></div>
					</td>
					<td class="tue">21
						<div class="no-collections"></div>
					</td>
					<td class="wed">22
						<div class="no-collections"></div>
					</td>
					<td class="thu collection-day">23
						<div class="collections">
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#666666"></i>
								<i class="fas fa-trash-alt fa-stack-1x fa-inverse"></i>
							</span>
						</div>
					</td>
					<td class="fri">24
						<div class="no-collections"></div>
					</td>
					<td class="sat">25
						<div class="no-collections"></div>
					</td>
					<td class="sun">26
						<div class="no-collections"></div>
					</td>
				</tr>
				<tr>
					<td class="mon">27
						<div class="no-collections"></div>
					</td>
					<td class="tue">28
						<div class="no-collections"></div>
					</td>
					<td class="noday">&nbsp;</td>
					<td class="noday">&nbsp;</td>
					<td class="noday">&nbsp;</td>
					<td class="noday">&nbsp;</td>
					<td class="noday">&nbsp;</td>
				</tr>
			</tbody>
		</table>
	</div>
	<div class="col-xs-12 col-sm-6 col-md-4" style="height: 355px;">
		<table class="table month" cellspacing="0" cellpadding="0" border="0">
			<tbody>
				<tr>
					<th class="month" colspan="7">March 2023</th>
				</tr>
				<tr>
					<th class="mon">Mon</th>
					<th class="tue">Tue</th>
					<th class="wed">Wed</th>
					<th class="thu">Thu</th>
					<th class="fri">Fri</th>
					<th class="sat">Sat</th>
					<th class="sun">Sun</th>
				</tr>
				<tr>
					<td class="noday">&nbsp;</td>
					<td class="noday">&nbsp;</td>
					<td class="wed">1
						<div class="no-collections"></div>
					</td>
					<td class="thu collection-day">2
						<div class="collections">
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#666666"></i>
								<i class="fas fa-trash-alt fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#ff8c00"></i>
								<i class="fas fa-wine-bottle fa-stack-1x fa-inverse"></i>
							</span>
						</div>
					</td>
					<td class="fri">3
						<div class="no-collections"></div>
					</td>
					<td class="sat">4
						<div class="no-collections"></div>
					</td>
					<td class="sun">5
						<div class="no-collections"></div>
					</td>
				</tr>
				<tr>
					<td class="mon">6
						<div class="no-collections"></div>
					</td>
					<td class="tue">7
						<div class="no-collections"></div>
					</td>
					<td class="wed">8
						<div class="no-collections"></div>
					</td>
					<td class="thu collection-day">9
						<div class="collections">
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#666666"></i>
								<i class="fas fa-trash-alt fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#32cd32"></i>
								<i class="fas fa-leaf fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#0000ff"></i>
								<i class="fas fa-newspaper fa-stack-1x fa-inverse"></i>
							</span>
						</div>
					</td>
					<td class="fri">10
						<div class="no-collections"></div>
					</td>
					<td class="sat">11
						<div class="no-collections"></div>
					</td>
					<td class="sun">12
						<div class="no-collections"></div>
					</td>
				</tr>
				<tr>
					<td class="mon">13
						<div class="no-collections"></div>
					</td>
					<td class="tue">14
						<div class="no-collections"></div>
					</td>
					<td class="wed">15
						<div class="no-collections"></div>
					</td>
					<td class="thu collection-day">16
						<div class="collections">
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#666666"></i>
								<i class="fas fa-trash-alt fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#ff8c00"></i>
								<i class="fas fa-wine-bottle fa-stack-1x fa-inverse"></i>
							</span>
						</div>
					</td>
					<td class="fri">17
						<div class="no-collections"></div>
					</td>
					<td class="sat">18
						<div class="no-collections"></div>
					</td>
					<td class="sun">19
						<div class="no-collections"></div>
					</td>
				</tr>
				<tr>
					<td class="mon">20
						<div class="no-collections"></div>
					</td>
					<td class="tue">21
						<div class="no-collections"></div>
					</td>
					<td class="wed">22
						<div class="no-collections"></div>
					</td>
					<td class="thu collection-day">23
						<div class="collections">
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#666666"></i>
								<i class="fas fa-trash-alt fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#32cd32"></i>
								<i class="fas fa-leaf fa-stack-1x fa-inverse"></i>
							</span>
						</div>
					</td>
					<td class="fri">24
						<div class="no-collections"></div>
					</td>
					<td class="sat">25
						<div class="no-collections"></div>
					</td>
					<td class="sun">26
						<div class="no-collections"></div>
					</td>
				</tr>
				<tr>
					<td class="mon">27
						<div class="no-collections"></div>
					</td>
					<td class="tue">28
						<div class="no-collections"></div>
					</td>
					<td class="wed">29
						<div class="no-collections"></div>
					</td>
					<td class="thu collection-day">30
						<div class="collections">
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#666666"></i>
								<i class="fas fa-trash-alt fa-stack-1x fa-inverse"></i>
							</span>
							<span class="fa-stack None">
								<i class="fas fa-circle fa-stack-2x" style="color:#ff8c00"></i>
								<i class="fas fa-wine-bottle fa-stack-1x fa-inverse"></i>
							</span>
						</div>
					</td>
					<td class="fri">31
						<div class="no-collections"></div>
					</td>
					<td class="noday">&nbsp;</td>
					<td class="noday">&nbsp;</td>
				</tr>
			</tbody>
		</table>
	</div>
</div>
