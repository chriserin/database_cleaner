module DatabaseCleaner
  module MongoSpecHelper
    def ensure_counts(expected_counts)
      # I had to add this sanity_check garbage because I was getting non-determinisc results from mongo at times..
      # very odd and disconcerting...
      expected_counts.each do |model_class, expected_count|
        model_class.count.should equal(expected_count), "#{model_class} expected to have a count of #{expected_count} but was #{model_class.count}"
      end
    end

    def create_widget(attrs={})
      MongoTest::Widget.new({:name => 'some widget', :updated_at => Time.now}.merge(attrs)).save!
    end

    def create_gadget(attrs={})
      MongoTest::Gadget.new({:name => 'some gadget', :updated_at => Time.now}.merge(attrs)).save!
    end

    def setup_db
      @connection = ::Mongo::Connection.new('127.0.0.1')
      @test_db = 'database_cleaner_specs'
      @db = @connection.db(@test_db)
    end

    def teardown_db
      @connection.drop_database(@test_db)
    end
  end
end
