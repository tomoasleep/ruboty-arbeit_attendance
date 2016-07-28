module Ruboty
  module Handlers
    class ArbeitAttendance < Base
      on /work start/, name: :work_start, description: 'memorize work start time'
      on /work end/, name: :work_end, description: 'create url for attendance form'
      on /register attendance_form (?<page_url>\S+) (?<form_page_data>.+)\z/, name: :register_form, description: 'register form data'
      on /attendance_form set default (?<key>\S+) (?<value>.+)\z/, name: :set_default, description: 'register form data'

      def work_start(message)
        Ruboty::ArbeitAttendance::Actions::ArbeitAttendance.new(message).work_start
      end

      def work_end(message)
        Ruboty::ArbeitAttendance::Actions::ArbeitAttendance.new(message).work_end
      end

      def register_form(message)
        Ruboty::ArbeitAttendance::Actions::ArbeitAttendance.new(message).register_form
      end

      def set_default(message)
        Ruboty::ArbeitAttendance::Actions::ArbeitAttendance.new(message).set_default
      end
    end
  end
end
