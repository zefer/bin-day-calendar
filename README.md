# Bin Day Calendar

Parse Allerdale (Cumberland) bin day HTML and generate an ICS calendar file so
you can import and display your bin days on your calendar.

A quick and rough implementation!

## Will it work for me?

Probably not, unless you live in Allerdale, UK, or unless other UK councils
have the same bin day listings on their websites.

## Usage

Firstly, clone the repo then `bundle install`.

1. Visit https://www.cumberland.gov.uk/bins-recycling-and-street-cleaning/waste-collections/bin-collection-schedule
2. Enter your address then copy the address ID from the resulting URL (the last
   part of the URL e.g. 10000123456
3. Set an environment variable ADDRESS_ID=your-address-id
4. Run `ruby bins.rb` which will generate `bins.ics`
5. Import `bins.ics` into your calendar
