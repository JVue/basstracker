require_relative '../../helpers/angler'

describe Angler do
  let(:angler_name) { 'john.snow' }
  let(:angler_instance) { Angler.new(angler_name) }
  let(:db) { double('db') }

  before do
    allow(DB).to receive(:new) { db }
    allow(db).to receive(:close_db_connection)
  end

  describe 'add_angler' do
    context 'successful submit' do
      it 'returns success' do
        angler_array = %w[john.doe jason.vue jane.doe]
        expect(db).to receive(:get_anglers) { angler_array }
        expect(db).to receive(:add_angler).with(angler_name)
        expect(angler_instance.add_angler).to eq 'success'
      end
    end

    context 'failed submit' do
      it 'returns error message' do
        angler_array = %w[john.snow jason.vue jane.doe]
        expect(db).to receive(:get_anglers) { angler_array }
        expect(angler_instance.add_angler).to eq 'Error: Angler john.snow already exists.'
      end
    end
  end

  describe 'remove_angler' do
    context 'successful submit' do
      it 'returns success' do
        angler_array = %w[john.snow jason.vue jane.doe]
        expect(db).to receive(:get_anglers) { angler_array }
        expect(db).to receive(:remove_angler).with(angler_name)
        expect(angler_instance.remove_angler).to eq 'success'
      end
    end

    context 'failed submit' do
      it 'returns error message' do
        angler_array = %w[tony.stark jason.vue jane.doe]
        expect(db).to receive(:get_anglers) { angler_array }
        expect(angler_instance.remove_angler).to eq 'Error: Angler field is blank/empty or angler does not exists.'
      end
    end
  end

  describe 'validate_name' do
    context 'successful submit' do
      it 'returns true' do
        angler_array = %w[john.snake jason.vue jane.doe]
        expect(db).to receive(:get_anglers) { angler_array }
        expect(angler_instance.validate_name).to be_truthy
      end
    end

    context 'failed submit' do
      it 'returns error message' do
        angler_array = %w[john.snow jason.vue jane.doe]
        expect(db).to receive(:get_anglers) { angler_array }
        expect { angler_instance.validate_name }.to raise_error('Error: Angler john.snow already exists.')
      end
    end
  end

  describe 'angler_exists?' do
    context 'successful submit' do
      it 'returns true' do
        angler_array = %w[john.snow jason.vue jane.doe]
        expect(db).to receive(:get_anglers) { angler_array }
        expect(angler_instance.angler_exists?).to be_truthy
      end
    end

    context 'failed submit' do
      it 'returns error message' do
        angler_array = %w[john.snake jason.vue jane.doe]
        expect(db).to receive(:get_anglers) { angler_array }
        expect { angler_instance.angler_exists? }.to raise_error('Error: Angler field is blank/empty or angler does not exists.')
      end
    end
  end
end
