require 'rspec'

require_relative '../lib/mission_control_command'

describe MissionControlCommand do
  it 'has a check in path' do
    expect(MissionControlCommand.check_in_path).to include('check_in')
  end

  context 'checking in' do
    it 'acknowledges my check in' do
      cmd = MissionControlCommand.new('in')
      expect(cmd.output).to include('You are')
    end

    it 'creates a check in file' do
      cmd = MissionControlCommand.new('in')
      check_in_path = cmd.class.check_in_path
      if FileTest.exists?(check_in_path)
        FileUtils.rm(check_in_path)
      end

      cmd.output
      expect(check_in_path).to be_true
    end

    it 'timestamps the checkin file at the time of checkin' do
      cmd = MissionControlCommand.new('in')
      cmd.output
      time = File.read(cmd.class.check_in_path).chomp
      expect(time).to eql((Time.now).to_s)
    end

    it 'throws a checkin error if you try to checkin twice' do
      cmd = MissionControlCommand.new('in')
      cmd2 = MissionControlCommand.new('in')
      cmd.output
      cmd2.output
      expect(cmd2.output).to include('You are already checked in.')
    end

    it 'does not change the timestamp if you try to check in again' do

    end
  end

  context 'checking out' do
    it 'acknowledges my check out' do
      cmd = MissionControlCommand.new('out')
      expect(cmd.output).to include('You are checked out')
    end

    it 'deletes the check in file' do
      cmd = MissionControlCommand.new('out')
      check_in_path = cmd.class.check_in_path
      expect(FileTest.exists?(check_in_path)).to eql(false)
    end

    it 'throws a checkout error if you try to checkout twice' do
      cmd = MissionControlCommand.new('out')
      cmd2 = MissionControlCommand.new('out')
      cmd.output
      cmd2.output
      expect(cmd2.output).to include('You are already checked out.')
    end
  end

end
