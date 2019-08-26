# frozen_string_literal: true

class SwVersResolver < BaseResolver
  # ProductName
  # ProductVersion
  # BuildVersion

  class << self
    @@semaphore = Mutex.new
    @@fact_list ||= {}

    def resolve(fact_name)
      @@semaphore.synchronize do
        result ||= @@fact_list[fact_name]

        return result unless result.nil?

        output, _status = Open3.capture2('sw_vers')
        release_info = output.delete("\t").split("\n").map { |e| e.split(':') }

        @@fact_list = Hash[*release_info.flatten]

        return @@fact_list[fact_name]
      end
    end
  end
end