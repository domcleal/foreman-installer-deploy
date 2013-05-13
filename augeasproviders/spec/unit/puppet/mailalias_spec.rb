#!/usr/bin/env rspec

require 'spec_helper'

provider_class = Puppet::Type.type(:mailalias).provider(:augeas)

describe provider_class do
  context "with empty file" do
    let(:tmptarget) { aug_fixture("empty") }
    let(:target) { tmptarget.path }

    it "should create simple new entry" do
      apply!(Puppet::Type.type(:mailalias).new(
        :name      => "foo",
        :recipient => "bar",
        :target    => target,
        :provider  => "augeas"
      ))

      aug_open(target, "Aliases.lns") do |aug|
        aug.get("./1/name").should == "foo"
        aug.get("./1/value").should == "bar"
      end
    end

    it "should create new entry" do
      apply!(Puppet::Type.type(:mailalias).new(
        :name      => "foo",
        :recipient => [ "foo-a", "foo-b" ],
        :target    => target,
        :provider  => "augeas"
      ))

      aug_open(target, "Aliases.lns") do |aug|
        aug.get("./1/name").should == "foo"
        aug.match("./1/value").size.should == 2
        aug.get("./1/value[1]").should == "foo-a"
        aug.get("./1/value[2]").should == "foo-b"
      end
    end
  end

  context "with full file" do
    let(:tmptarget) { aug_fixture("full") }
    let(:target) { tmptarget.path }

    it "should list instances" do
      provider_class.stubs(:file).returns(target)
      inst = provider_class.instances.map { |p|
        {
          :name => p.get(:name),
          :ensure => p.get(:ensure),
          :recipient => p.get(:recipient),
        }
      }

      inst.size.should == 3
      inst[0].should == {:name=>"mailer-daemon", :ensure=>:present, :recipient=>["postmaster"]}
      inst[1].should == {:name=>"postmaster", :ensure=>:present, :recipient=>["root"]}
      inst[2].should == {:name=>"test", :ensure=>:present, :recipient=>["user1", "user2"]}
    end

    it "should delete entries" do
      apply!(Puppet::Type.type(:mailalias).new(
        :name     => "mailer-daemon",
        :ensure   => "absent",
        :target   => target,
        :provider => "augeas"
      ))

      aug_open(target, "Aliases.lns") do |aug|
        aug.match("*[name = 'mailer-daemon']").should == []
      end
    end

    describe "when updating recipients" do
      it "should replace a recipients" do
        apply!(Puppet::Type.type(:mailalias).new(
          :name      => "mailer-daemon",
          :recipient => [ "test" ],
          :target    => target,
          :provider  => "augeas"
        ))

        aug_open(target, "Aliases.lns") do |aug|
          aug.get("./1/name").should == "mailer-daemon"
          aug.match("./1/value").size.should == 1
          aug.get("./1/value").should == "test"
        end
      end

      it "should add multiple recipients" do
        apply!(Puppet::Type.type(:mailalias).new(
          :name      => "mailer-daemon",
          :recipient => [ "test-a", "test-b" ],
          :target    => target,
          :provider  => "augeas"
        ))

        aug_open(target, "Aliases.lns") do |aug|
          aug.get("./1/name").should == "mailer-daemon"
          aug.match("./1/value").size.should == 2
          aug.get("./1/value[1]").should == "test-a"
          aug.get("./1/value[2]").should == "test-b"
        end
      end
    end
  end

  context "with broken file" do
    let(:tmptarget) { aug_fixture("broken") }
    let(:target) { tmptarget.path }

    it "should fail to load" do
      txn = apply(Puppet::Type.type(:mailalias).new(
        :name      => "foo",
        :recipient => "bar",
        :target    => target,
        :provider  => "augeas"
      ))

      txn.any_failed?.should_not == nil
      @logs.first.level.should == :err
      @logs.first.message.include?(target).should == true
    end
  end
end
