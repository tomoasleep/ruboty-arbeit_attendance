require 'json'

module Ruboty
  module ArbeitAttendance
    module Actions
      class ArbeitAttendance < Ruboty::Actions::Base
        NAMESPACE = 'arbeit_attendance'

        def work_start
          time = Time.now
          user_data[:start_time] = time
          message.reply("OK, your clock-in time is #{time.strftime("%r")}.")
        end

        def work_end
          today = end_time = Time.now
          start_time = user_data[:start_time]

          url = url_builder.build(today, start_time, end_time)
          message.reply("つ #{url}")
        end

        def register_form
          page_url = message['page_url']
          form_data = JSON.parse(message['form_page_data'])

          namespace[:page_url] = page_url
          namespace[:form_page_data] = form_data

          message.reply("Registered form data.")
        end

        def set_default
          user_data[:defaults][message['key']] = message['value']
          message.reply("OK, Set #{message['key']} as #{message['value']}.")
        end

        private

        def url_builder
          UrlBuilder.new(namespace[:page_url], namespace[:form_page_data], user_data[:defaults])
        end

        def user_data
          namespace[:user_data] ||= {}
          namespace[message.from_name] ||= { defaults: {} }
        end

        def namespace
          message.robot.brain.data[NAMESPACE] ||= {}
        end

        class UrlBuilder
          def initialize(page_url, form_info, defaults)
            @page_url = page_url
            @form_info = Form::Prototype.new(form_info)
            @defaults = defaults
          end

          def build(day, begin_time, end_time)
            uri = URI.parse(@page_url)
            form = Form.new(@form_info)
            @defaults.each { |key, value| form[key] = value }

            form[:day] = day
            form[:begin_time] = begin_time
            form[:end_time] = end_time
            form[:work_time] = end_time - begin_time

            uri.query = form.to_query
            uri.to_s
          end
        end
      end
    end
  end
end
