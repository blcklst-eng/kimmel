require "rails_helper"

RSpec.describe Message, :active_storage, type: :model do
  context "validations" do
    it "is valid with valid attributes" do
      expect(build(:incoming_message)).to be_valid
      expect(build(:outgoing_message)).to be_valid
    end

    it "should validate_presence_of :body without :media" do
      expect(build(:incoming_message, body: "", media: nil)).not_to be_valid
    end

    it "should not validate_presence_of :body with :media" do
      expect(build(:incoming_message, body: "", media: create_file_blob)).to be_valid
    end
  end

  context "callbacks" do
    describe "after_commit" do
      it "broadcasts that a message has been received" do
        expect { create(:incoming_message) }.to have_enqueued_job(BroadcastMessageJob)
      end

      it "notifies walter of the message" do
        expect {
          create(:incoming_message)
        }.to have_enqueued_job(WalterMessageNotificationJob)
      end
    end
  end

  describe ".since" do
    it "filters to messages that were created since the provided date" do
      old_message = create(:incoming_message, created_at: 10.days.ago)
      new_message = create(:incoming_message, created_at: 3.days.ago)

      found_messages = described_class.since(5.days.ago)

      expect(found_messages).to include(new_message)
      expect(found_messages).not_to include(old_message)
    end
  end

  describe ".prior_to" do
    it "filters to messages that were created prior to the provided date" do
      old_message = create(:incoming_message, created_at: 10.days.ago)
      new_message = create(:incoming_message, created_at: 3.days.ago)

      found_messages = described_class.prior_to(5.days.ago)

      expect(found_messages).to include(old_message)
      expect(found_messages).not_to include(new_message)
    end
  end

  describe "#status_url" do
    it "returns the url that delivery status updates for this message will be recieved at" do
      message = build_stubbed(:message)

      url = message.status_url

      expect(url).to eq(RouteHelper.message_status_url(message))
    end
  end

  describe "#attach_remote_media" do
    it "attaches remote media" do
      message = create(:incoming_message)
      spy = spy(from_url: Result.success(
        file: open("./spec/fixtures/files/ruby.jpg"),
        extension: ".jpg"
      ))
      stub_const("DownloadFile", spy)

      message.attach_remote_media("https://kimmel.com/ruby.jpg")

      expect(message.media.count).to eq(1)
    end
  end
end
