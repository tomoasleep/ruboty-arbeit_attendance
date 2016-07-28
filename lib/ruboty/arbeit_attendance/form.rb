require 'uri'
require 'time'

module Ruboty
  module ArbeitAttendance
    class Form
      ATTRS = {
        name: {
          key: '氏名',
        },
        day: {
          key: '出勤日',
          value_type: :datetime,
          format: "%Y/%m/%d"
        },
        begin_time: {
          key: '出社時刻',
          form_type: :time,
        },
        end_time: {
          key: '退社時刻',
          form_type: :time,
        },
        transportation: {
          key: '交通費',
          default: '0',
        },
        rest_time: {
          key: '休憩時間',
          default: 'なし',
        },
        work_time: {
          key: '実働時間',
          value_type: :rational_time,
          format: "%k:%M"
        },
      }.freeze

      class Reader
        attr_reader :data
        def initialize
          @data = {}
        end

        def read(heading, input_names)
          key, matched_attr = Form::ATTRS.find { |key, attr| attr[:key] && heading.include?(attr[:key]) }
          return unless matched_attr

          case matched_attr[:form_type]
          when :time
            content = {
              hour: input_names.find { |name| name.include?('hour') },
              minute: input_names.find { |name| name.include?('minute') },
            }
          else
            content = input_names.first
          end

          @data[key] ||= {}
          @data[key][:form_name] = content
        end
      end

      class Prototype
        attr_reader :attributes
        def initialize(form_page_data)
          @attributes = deep_merge(ATTRS, symbolize_hash(form_page_data))
        end

        private

        def symbolize_hash(hash)
          return hash unless hash.is_a? Hash
          hash.each_with_object({}) do |(key, data), hash|
            hash[key.to_sym] = symbolize_hash(data)
          end
        end

        def deep_merge(one, another)
          another.each_with_object(one.dup) do |(key, data), hash|
            one_data = hash[key]
            if one_data.is_a?(Hash) && data.is_a?(Hash)
              hash[key] = deep_merge(one_data, data)
            else
              hash[key] = data
            end
          end
        end
      end

      attr_reader :prototype, :data
      def initialize(prototype)
        @prototype = prototype
        @data = { emailReceipt: true }
        prototype.attributes.each do |key, attr|
          self[key] = attr[:default] if attr[:default]
        end
      end

      def []=(key, value)
        attr = prototype.attributes[key.to_sym]
        case attr[:form_type]
        when :time
          @data[name_of(key)[:hour]] = value.hour
          @data[name_of(key)[:minute]] = value.min
        else
          @data[name_of(key)] = format_value(key, value)
        end
      end

      def to_query
        URI.encode_www_form(@data)
      end

      private

      def format_value(key, value)
        attr = prototype.attributes[key.to_sym]
        case attr[:value_type]
        when :datetime
          value.strftime(attr[:format])
        when :rational_time
          (Time.parse('1/1') + value.to_i).strftime(attr[:format]).gsub(/^\s*/, '')
        else
          value.to_s
        end
      end

      def name_of(key)
        prototype.attributes[key.to_sym][:form_name]
      end
    end
  end
end
