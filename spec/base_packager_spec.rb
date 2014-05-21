require 'spec_helper'

describe BasePackager do
  subject { BasePackager.new("ruby", :online) }


  before do
    subject.stub(:system).and_return(true)
    Zip::File.stub(:open)
  end

  context "#excluded_files" do
    it "raises a NotImplementedError when #excluded_files is not redefined" do
      subject.stub(:package)

      expect do
        subject.excluded_files
      end.to raise_error(NotImplementedError)
    end
  end

  it 'exits when a system call fails' do
    subject.stub(:system).and_return false

    expect do
      subject.package
    end.to raise_error(RuntimeError, /There was an error running command cp/)
  end

  context "offline mode only" do
    subject { BasePackager.new("ruby", :offline) }

    it "makes a system call" do
      subject.stub(:excluded_files).and_return([])
      subject.stub(:dependencies).and_return([])

      subject.should_receive(:system)

      subject.package
    end

    context "#dependencies" do
      it "raises a NotImplementedError when #dependencies is not redefined" do
        subject.stub(:excluded_files).and_return([])


        expect do
          subject.package
        end.to raise_error(NotImplementedError)
      end
    end
  end
end