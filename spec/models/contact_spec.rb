require "rails_helper"

RSpec.describe Contact, type: :model do
  context "validations" do
    it "is valid with valid attributes" do
      expect(build(:contact)).to be_valid
    end

    it { should validate_presence_of(:phone_number) }

    it "is not valid with a non-unique phone number for the user" do
      user = create(:user)
      contact = create(:contact, user: user)
      duplicate_contact = build(:contact, user: user, phone_number: contact.phone_number)

      expect(duplicate_contact).not_to be_valid
    end
  end

  describe ".for_user" do
    it "finds contacts for the specified user" do
      user = create(:user)
      contact = create(:contact, user: user)

      result = described_class.for_user(user).first

      expect(result).to eq(contact)
    end

    it "does not find saved users" do
      user = create(:user)
      create(:contact)

      result = described_class.for_user(user).first

      expect(result).to be(nil)
    end
  end

  describe ".saved" do
    it "finds contacts that are saved" do
      contact = create(:contact, :saved)

      result = described_class.saved.first

      expect(result).to eq(contact)
    end

    it "does not find unsaved contacts" do
      create(:contact, :unsaved)

      result = described_class.saved.first

      expect(result).to be(nil)
    end
  end

  describe ".order_by_name" do
    it "orders by last name in alphabetical order" do
      second_contact = create(:contact, last_name: "Smith")
      first_contact = create(:contact, last_name: "Doe")

      result = described_class.order_by_name

      expect(result.first).to eq(first_contact)
      expect(result.second).to eq(second_contact)
    end

    it "orders by first name when last names are the same" do
      second_contact = create(:contact, last_name: "Doe", first_name: "Martha")
      first_contact = create(:contact, last_name: "Doe", first_name: "Alan")

      result = described_class.order_by_name

      expect(result.first).to eq(first_contact)
      expect(result.second).to eq(second_contact)
    end

    it "orders by first name if last name is not set" do
      second_contact = create(:contact, last_name: nil, first_name: "Dave")
      first_contact = create(:contact, last_name: "Doe", first_name: "John")

      result = described_class.order_by_name

      expect(result.first).to eq(second_contact)
      expect(result.second).to eq(first_contact)
    end
  end

  describe ".from" do
    it "finds an existing contact" do
      contact = create(:contact)

      result = Contact.from(phone_number: contact.phone_number, user: contact.user)

      expect(result).to eq(contact)
    end

    it "creates a contact if they do not exist" do
      result = Contact.from(phone_number: "+18282555500", user: create(:user))

      expect(result).to be_a(Contact)
      expect(Contact.count).to eq(1)
    end

    it "adds details to the contact if it recognizes the number" do
      recognized_user = create(:user_with_number)
      user = create(:user)

      result = Contact.from(phone_number: recognized_user.phone_number, user: user)

      expect(result.first_name).to eq(recognized_user.first_name)
    end
  end

  describe "#remove_from_saved" do
    it "changes the contact from saved to unsaved" do
      contact = create(:contact, :saved)

      result = contact.remove_from_saved

      expect(result).to be(true)
      expect(contact.saved).to be(false)
    end
  end

  describe "#full_name" do
    it "returns the first name and last name" do
      contact = create(:contact, last_name: "Doe", first_name: "John")

      result = contact.full_name

      expect(result).to eq("John Doe")
    end

    it "returns just the first name if last name is not set" do
      contact = create(:contact, last_name: nil, first_name: "John")

      result = contact.full_name

      expect(result).to eq("John")
    end

    it "returns just the last name if first name is not set" do
      contact = create(:contact, last_name: "Doe", first_name: nil)

      result = contact.full_name

      expect(result).to eq("Doe")
    end

    it "returns nil if no name is set" do
      contact = create(:contact, last_name: nil, first_name: nil)

      result = contact.full_name

      expect(result).to be(nil)
    end
  end

  describe "#identity" do
    it "returns the contacts name if it has one" do
      contact = create(:contact, last_name: "Doe", first_name: "John", phone_number: "+11231231234")

      result = contact.identity

      expect(result).to eq("John Doe")
    end

    it "returns the phone number if the contact has no name" do
      contact = create(:contact, last_name: nil, first_name: nil, phone_number: "+11231231234")

      result = contact.identity

      expect(result).to eq("+11231231234")
    end
  end

  describe "#internal?" do
    it "returns true if the number matches the number of a user" do
      user = create(:user_with_number)
      contact = create(:contact, phone_number: user.phone_number)

      result = contact.internal?

      expect(result).to be(true)
    end

    it "returns false if no user matches the number" do
      contact = create(:contact)

      result = contact.internal?

      expect(result).to be(false)
    end
  end
end
