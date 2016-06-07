require 'spec_helper'

describe 'fyber_aerospike::default' do
  describe service('aerospike') do
    it { should be_enabled }
    it { should be_running }
  end
  %w(3000 3001 3003).each do |port|
    describe port(port) do
      it { should be_listening.with('tcp') }
    end
  end
  describe port(3002) do
    it { should be_listening.with('udp') }
  end
  describe command('asinfo -v statistics -l | grep cluster_size') do
    its(:stdout) { should match(/cluster_size=2/) }
  end
end
