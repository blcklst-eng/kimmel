require "rails_helper"

RSpec.describe Voicemail, type: :model do
  context "validation" do
    it "is valid with valid attributes" do
      expect(create(:voicemail)).to be_valid
    end

    it { should validate_presence_of(:sid) }

    it "is not valid without an audio file" do
      voicemail = build(:voicemail, audio: nil)

      expect(voicemail).not_to be_valid
    end
  end

  describe ".not_viewed" do
    it "returns voicemails not viewed" do
      voicemail = create(:voicemail, :not_viewed)

      result = described_class.not_viewed

      expect(result.first).to eq(voicemail)
    end
  end

  describe ".expired" do
    it "returns voicemails that are expired and not archived" do
      voicemail = create(:voicemail, :expired)
      create(:voicemail, :archived, :expired)
      create(:voicemail)

      result = described_class.expired

      expect(result.first).to eq(voicemail)
      expect(result.count).to eq(1)
    end
  end

  describe ".archived" do
    it "returns voicemails that are archived" do
      archived_voicemail = create(:voicemail, :archived)
      unarchived_voicemail = create(:voicemail, archived: false)

      result = described_class.archived

      expect(result).to include(archived_voicemail)
      expect(result).not_to include(unarchived_voicemail)
    end

    it "returns voicemails that are not archived" do
      unarchived_voicemail = create(:voicemail, archived: false)
      archived_voicemail = create(:voicemail, :archived)

      result = described_class.archived(false)

      expect(result).to include(unarchived_voicemail)
      expect(result).not_to include(archived_voicemail)
    end
  end

  describe "#view" do
    it "marks the voicemail as viewed" do
      voicemail = create(:voicemail, :not_viewed)

      result = voicemail.view

      voicemail.reload
      expect(result).to be(true)
      expect(voicemail.viewed?).to be(true)
    end

    it "queues broadcast counts job" do
      voicemail = create(:voicemail, :not_viewed)

      expect {
        voicemail.view
      }.to have_enqueued_job(BroadcastCountsJob)
    end
  end

  describe "after_commit" do
    it "broadcasts counts when a new voicemail is created" do
      expect {
        create(:voicemail)
      }.to have_enqueued_job(BroadcastCountsJob)
    end
  end

  describe "#delete_expired" do
    it "does not delete new voicemails" do
      create(:voicemail)

      described_class.delete_expired

      expect(Voicemail.count).to eq(1)
    end

    it "does not delete archived voicemails" do
      create(:voicemail, :archived, :expired)

      described_class.delete_expired

      expect(Voicemail.count).to eq(1)
    end

    it "deletes expired voicemails that are not archived" do
      create(:voicemail, :expired)

      described_class.delete_expired

      expect(Voicemail.count).to eq(0)
    end
  end

  describe ".expiration" do
    it "returns nil for archived voicemails" do
      voicemail = create(:voicemail)

      result = voicemail.expiration

      expect(result).to eq(voicemail.created_at + Voicemail::EXPIRES)
    end

    it "returns a expiration date for voicemails that are not acrchived" do
      voicemail = create(:voicemail, :archived)

      result = voicemail.expiration

      expect(result).to be(nil)
    end
  end
end
