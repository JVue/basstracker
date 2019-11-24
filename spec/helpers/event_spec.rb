require_relative '../../helpers/event'

describe Event do
  let(:event_name) { 'b5' }
  let(:event_instance) { Event.new(event_name) }
  let(:db) { double('db') }

  before do
    allow(DB).to receive(:new) { db }
    allow(db).to receive(:close_db_connection)
  end

  describe 'add_event' do
    context 'successful submit' do
      it 'returns success' do
        event_array = %w[tournament 3-man mlf]
        expect(db).to receive(:get_events) { event_array }
        expect(db).to receive(:add_event).with(event_name)
        expect(event_instance.add_event).to eq 'success'
      end
    end

    context 'failed submit' do
      it 'returns error message' do
        event_array = %w[b5 tournament 3-man mlf]
        expect(db).to receive(:get_events) { event_array }
        expect(event_instance.add_event).to eq 'Error: Event b5 already exists.'
      end
    end
  end

  describe 'remove_event' do
    context 'successful submit' do
      it 'returns success' do
        event_array = %w[b5 tournament 3-man mlf]
        expect(db).to receive(:get_events) { event_array }
        expect(db).to receive(:remove_event).with(event_name)
        expect(event_instance.remove_event).to eq 'success'
      end
    end

    context 'failed submit' do
      it 'returns error message' do
        event_array = %w[tournament 3-man mlf]
        expect(db).to receive(:get_events) { event_array }
        expect(event_instance.remove_event).to eq 'Error: Event b5 does not exists.'
      end
    end
  end

  describe 'validate_name' do
    context 'successful submit' do
      it 'returns true' do
        event_array = %w[tournament 3-man mlf]
        expect(db).to receive(:get_events) { event_array }
        expect(event_instance.validate_name).to be_truthy
      end
    end

    context 'failed submit' do
      it 'returns error message' do
        event_array = %w[b5 tournament 3-man mlf]
        expect(db).to receive(:get_events) { event_array }
        expect { event_instance.validate_name }.to raise_error('Error: Event b5 already exists.')
      end
    end
  end

  describe 'event_exists?' do
    context 'successful submit' do
      it 'returns true' do
        event_array = %w[b5 tournament 3-man mlf]
        expect(db).to receive(:get_events) { event_array }
        expect(event_instance.event_exists?).to be_truthy
      end
    end

    context 'failed submit' do
      it 'returns error message' do
        event_array = %w[tournament 3-man mlf]
        expect(db).to receive(:get_events) { event_array }
        expect { event_instance.event_exists? }.to raise_error('Error: Event b5 does not exists.')
      end
    end
  end
end
