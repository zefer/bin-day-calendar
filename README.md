# Bin Day Calendar

Parse Allerdale (Cumberland) bin day HTML and generate an ICS calendar file so
you can import and display your bin days on your calendar.

A quick and rough implementation!

## Will it work for me?

Probably not, unless you live in Allerdale, UK, or unless other UK councils
have the same bin day listings on their websites.

## Usage

Firstly, clone the repo then `bundle install`.

1. Visit https://www.allerdale.gov.uk/en/bincollections/, enter your address
   and display your bin day calendar.
2. Copy the HTML from the calendar grid start. You can use the dev tools
   inspector, select node `<div class="row year row-equal-height">` and copy
   outer HTML.
3. Paste the HTML into the bottom of `bins.rb` immediately after `__END__`.
4. Run `ruby bins.rb` which will generate `bins.ics`.
5. Import `bins.ics` into your calendar.
