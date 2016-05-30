require 'spec_helper'

describe 'fyber_aerospike::default' do
  describe service('amc') do
    it { should be_enabled }
  end
  # Aerospike rpm is for EL6, so it doesn't use systemd
  describe process('amc') do
    it { should be_running }
  end
  describe port(8081) do
    it { should be_listening }
  end
end
