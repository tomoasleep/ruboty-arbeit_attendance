require 'nokogiri'
require 'json'
require 'ruboty/arbeit_attendance'

class FormPageParser
  attr_reader :html

  def initialize(html)
    @html = html
  end

  def document
    @document ||= Nokogiri.parse(html)
  end

  def form_data
    @form_data ||= begin
      reader = Ruboty::ArbeitAttendance::Form::Reader.new
      list_item_els.each do |el, info|
        names = input_names(el)
        heading = heading(el)
        reader.read(heading, names) unless names.empty? || heading.empty?
      end
      reader.data
    end
  end

  private

  def list_item_els
    document.search('[role=listitem]')
  end

  def heading(list_item_el)
    list_item_el.search('[role=heading]').map(&:content).join('')
  end

  def input_names(list_item_el)
    list_item_el.search('input[name]').select { |el| el['name'].ascii_only? }.map { |el| el['name'] }
  end
end

puts JSON.generate(FormPageParser.new(File.read(ARGV[0])).form_data)
