require File.dirname(__FILE__) + "/spec_helper"

describe "query_trace" do
  before(:each) do
    @connection = ActiveRecord::Base.connection
    @logger = mock 'logger', :debug => true, :debug? => false
    @connection.instance_variable_set(:@logger, @logger) # Gross
  end

  describe "tracing queries" do
    it "should be off by default" do
      QueryTrace.trace_queries.should be_false
      QueryTrace.trace_queries.should equal(false)
    end

    it "should be settable to true" do
      QueryTrace.trace_queries = true
      QueryTrace.trace_queries.should be_true
    end
  end

  describe "logging with tracing on" do
    before(:each) do
      QueryTrace.trace_queries = true

      @a_name = mock 'a name'
      @a_runtime = mock 'a runtime'
    end

    it "should log the info without the trace" do
      @connection.should_receive(:log_info_without_trace).with("SELECT * FROM `foo`", @a_name, @a_runtime)
      @connection.log_info_with_trace("SELECT * FROM `foo`", @a_name, @a_runtime)
    end

    it "should log the trace" do
      @logger.should_receive(:debug)
      @connection.log_info_with_trace("SELECT * FROM `foo`", @a_name, @a_runtime)
    end
  end

  describe "logging with tracing off" do
    before(:each) do
      QueryTrace.trace_queries = false

      @a_name = mock 'a name'
      @a_runtime = mock 'a runtime'
    end

    it "should not log the trace" do
      @logger.should_not_receive(:debug)
      @connection.log_info_with_trace("SELECT * FROM `foo`", @a_name, @a_runtime)
    end
  end

  describe "logging with both on, but name =~ /Columns/" do
    before(:each) do
      QueryTrace.trace_queries = true

      @a_name = mock 'a name'
      @a_runtime = mock 'a runtime'
    end

    it "should not log the trace" do
      @logger.should_not_receive(:debug)
      @connection.log_info_with_trace("SHOW CREATE TABLE `users`", "User Columns", @a_runtime)
    end
  end
end
