require 'rails_helper'

RSpec.describe Note, type: :model do
  subject(:note) do
    create(:note)
  end

  %i[user title content note_type].each do |value|
    it { is_expected.to validate_presence_of(value) }
  end

  it 'has a valid factory' do
    expect(subject).to be_valid
  end

  describe 'validations' do
    context 'when note_type is review' do
      it 'validates word count does not exceed limit' do
        user = create(:user)
        limit = user.utility.review_max_words
        note = build(:note, user: user, note_type: :review, content: 'Hola ' * (limit + 1))
        expect(note).not_to be_valid
        expect(note.errors[:content]).to be_present
      end
      it 'validates word count does not exceed limit' do
        user = create(:user)
        limit = user.utility.review_max_words
        note = build(:note, user: user, note_type: :review, content: 'Hola ' * limit)
        expect(note).to be_valid
      end
    end
  end

  describe 'methods' do
    let(:user) { create(:user) }
    let(:thresholds) { user.utility.word_count_thresholds }

    it 'returns word count' do
      note = build(:note, content: 'Hola ' * 5, user: user)
      expect(note.word_count).to eq(5)
    end

    it 'returns content length' do
      note = build(:note, content: 'Hola ' * thresholds[:short], user: user)
      expect(note.content_length).to eq('short')
    end

    it 'returns content length' do
      note = build(:note, content: 'Hola ' * thresholds[:medium], user: user)
      expect(note.content_length).to eq('medium')
    end

    it 'returns content length' do
      note = build(:note, content: 'Hola ' * (thresholds[:medium] + 1), user: user)
      expect(note.content_length).to eq('long')
    end
  end
end
