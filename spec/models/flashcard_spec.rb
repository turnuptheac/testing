require 'rails_helper'

RSpec.describe Flashcard, type: :model do
  let(:fake_now) { Time.new(2016, 11, 8) }

  before(:each) do
    allow(Time).to receive(:now).and_return(fake_now)
  end

  describe 'validation' do
    it 'raises error with no question or answer' do
      expect { f = Flashcard.new; f.save! }.
        to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'raises error with no answer' do
      expect { f = Flashcard.new(question: "q"); f.save! }.
        to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'raises error with no question' do
      expect { f = Flashcard.new(answer: "a"); f.save! }.
        to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  context 'with a valid flashcard' do
    let(:flashcard) { FactoryGirl.create(:flashcard) }

    describe 'initialization' do
      it 'initializes bin and times_wrong' do
        expect(flashcard.bin).to eq(0)
        expect(flashcard.times_wrong).to eq(0)
      end
    end

    describe 'mark correct' do
      before(:each) do
        flashcard.mark_correct
      end

      it 'increments the bin' do
        expect(flashcard.bin).to eq(1)
      end

      it 'updates the time to revisit' do
        expect(flashcard.scheduled_time_to_revisit).
          to eq(fake_now + 5.seconds)
      end

      context 'marked correct twice' do
        let(:fake_now) { Time.new(2016, 11, 9) }
        
        before(:each) do
          flashcard.mark_correct
        end

        it 'increments the bin' do
          expect(flashcard.bin).to eq(2)
        end

        it 'updates the time to revisit' do
          expect(flashcard.scheduled_time_to_revisit).
            to eq(fake_now + 25.seconds)
        end
      end
    end

    describe 'mark incorrect' do
      before(:each) do
        flashcard.mark_incorrect
      end

      it 'resets the bin' do
        expect(flashcard.bin).to eq(1)
      end

      it 'updates the time to revisit' do
        expect(flashcard.scheduled_time_to_revisit).
          to eq(fake_now + 5.seconds)
      end
    end

    describe 'next card to review' do
      # TODO: test no cards to presently test
      # TODO: test that results are sorted by bin

      it 'finds the bin 0 card' do
        flashcard
        expect(Flashcard.next_card_to_review).to eq(flashcard)
      end

      context 'all cards have been wrong 10 times' do
        before(:each) do
          flashcard.times_wrong = 10
          flashcard.bin = 11
          flashcard.save!
        end

        it 'finds no next card to review' do
          expect(Flashcard.next_card_to_review).to eq(nil)
        end
      end
    end

    # TODO: describe 'has_future_cards' do
  end
end
