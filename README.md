# Ruboty::ArbeitAttendance

This ruboty plugin makes it easy for increments arbeits to submit attendance form.

## Usage

When you start to work, please enter `ruboty work start`.
When you end to work, please enter `ruboty work end`.

```
> ruboty work start
OK, your clock-in time is [current time].
> ruboty work end
つ [form page url]
```

Ruboty sends you attendance form url including your clock-in and clock-out time in response.

### Setup

To build form page url.
You have to register form information and your information.

#### Register the attendance form information.

To register the attendance form information.
First, you go to the attendance form page and download the web page as html.
Then, you run the scraping script `scripts/form_page_parser.rb`.

```
ruby ./scripts/form_page_parser.rb [form page source file]
```

This script prints the form information as json.
Then, you run this ruboty command to tell ruboty the form information.

```
ruboty register attendance_form [the form url] [the form information json]
```

#### Register your name and transportation cost

You can register your name or transportation cost.
Once you register, you do not have to input in the form manually.

```
ruboty attendance_form set default {name, transportation} [value]
```

## Development

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tomoasleep/ruboty-arbeit_attendance. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.
