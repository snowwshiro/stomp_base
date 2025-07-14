# frozen_string_literal: true

require "spec_helper"

RSpec.describe StompBase::Console::TerminalComponent do
  let(:component) { described_class.new }
  
  describe "#initialize" do
    it "generates a session_id if none provided" do
      expect(component.send(:session_id)).to be_present
      expect(component.send(:session_id)).to be_a(String)
    end
    
    it "uses provided session_id" do
      custom_session_id = "custom_session_123"
      component = described_class.new(session_id: custom_session_id)
      expect(component.send(:session_id)).to eq(custom_session_id)
    end
  end
  
  describe "#initial_prompt" do
    it "returns IRB-style prompt" do
      expect(component.send(:initial_prompt)).to eq("irb(main):001:0> ")
    end
  end
  
  describe "#welcome_message" do
    it "returns welcome message" do
      message = component.send(:welcome_message)
      expect(message).to include("Welcome to StompBase Rails Console")
      expect(message).to include("Type 'help' for available commands")
    end
  end
end