require 'vcr'
VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.default_cassette_options = {:record => :once}
  c.configure_rspec_metadata!
   #c.debug_logger = File.open('vcr_log.log', 'w')
end

Rspec.configure do |c|
  c.treat_symbols_as_metadata_keys_with_true_values = true
end
