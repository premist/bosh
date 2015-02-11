require 'spec_helper'

describe 'All OSes and Infrastructures', stemcell_image: true do
  describe 'sshd_config, set up by bosh_harden' do
    subject(:sshd_config) { file('/etc/ssh/sshd_config') }

    it 'is secure' do
      expect(sshd_config).to have_mode('600')
    end

    it 'disallows root login' do
      expect(sshd_config).to contain(/^PermitRootLogin no$/)
    end
  end
end