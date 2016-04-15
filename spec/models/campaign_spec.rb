require 'rails_helper'

RSpec.describe Campaign, type: :model do
  #pending "add some examples to (or delete) #{__FILE__}"
  # we're using 'describe in here to define a group of test examples For
  # model validations'
  describe "validations" do

      # you use 'it' or 'specify' to define a test example.  The first argument
      # to 'it' is a string that describes what you want to test.  You write your
      # test within a block you pass to the 'it'

      it "requires a title" do
        # GIVEN: campgain with no title
        c = Campaign.new

        # WEHN: we validate the campaign
        validation_outcome = c.valid?

        # THEN: validation_outcome is false
        expect(validation_outcome).to eq(false)

      end

      it "requires a goal" do
        # GIVEN: campaign with no goal
        c = Campaign.new

        # WEHN: we validate the campaign
        validation_outcome = c.valid?

        #Then: There is an error on :goal
        # have_key is a matcher in RSpec
        # puts c.errors.inspect
        expect(c.errors).to have_key(:goal)

      end

      it "requires the goal to be more than $10" do
        c = Campaign.new(goal: 9)
        c.valid?
        expect(c.errors).to have_key(:goal)
      end

      it "requires a unique title" do
        # c = Campaign.new title: "hello", goal: 11
        # c.save
        Campaign.create title: "hello", goal: 11
        c1 = Campaign.new title: "hello", goal: 11

        c1.valid?

        expect(c1.errors).to have_key :title
      end

  end

  # it's a convention to put the method name prefixed with a '.' if you're
  # testing a method (in the describe)
  describe ".upcased_title" do
      it "returns an upcased title" do
        # GIVEN
        c = Campaign.new title: "hello", goal: 11
        # WHEN
        result = c.upcased_title
        # THEN
        expect(result).to eq("HELLO")
      end
  end

end
