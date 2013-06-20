module DatabaseCleaner
  module Mongo
    module StumpMixin
      def start
        @test_time = Time.now
      end

      def clean
        if @only
          collections.each { |c| c.remove(:updated_at => { "$gte" => @test_time}) if @only.include?(c.name) }
        else
          collections.each { |c| c.remove(:updated_at => { "$gte" => @test_time}) unless @tables_to_exclude.include?(c.name) }
        end
        true
      end

      private

      def collections
        database.collections.select { |c| c.name !~ /^system\./ }
      end
    end
  end
end
