require_relative '../../helpers/weight'

describe Weight do
  let(:angler_name) { 'jason.vue' }
  let(:event_name) { 'b5' }
  let(:weight) { '2-8' }
  let(:weight_decimal) { 2.5 }
  let(:weight_oz) { 40 }
  let(:bass_type) { 'largemouth' }
  let(:weight_instance) { Weight.new(angler_name, event_name, weight, bass_type) }
  let(:db) { double('db') }
  let(:datetime_obj1) { double('datetime_1') }
  let(:datetime_obj2) { double('datetime_2')}
  let(:datetime_array) { ["11/24/2019", "02:05 PM"] }

  before do
    allow(DB).to receive(:new) { db }
    allow(Time).to receive(:now) { datetime_obj1 }
    allow(datetime_obj1).to receive(:strftime).with("%m/%d/%Y,%I:%M %p") { datetime_obj2 }
    allow(datetime_obj2).to receive(:split).with(',') {datetime_array}
    allow(db).to receive(:close_db_connection)
  end

  describe 'submit' do
    context 'successful submition' do
      it 'returns success' do
        expect(db).to receive(:add_entry).with(datetime_array[0], datetime_array[1], angler_name, event_name, weight, weight_decimal, weight_oz, bass_type) {true}
        expect(db).to receive(:get_entry).with(datetime_array[0], datetime_array[1], angler_name, event_name, weight, bass_type) {true}
        expect(weight_instance.submit).to eq 'success'
      end
    end

    context 'failed submition' do
      it 'returns error message' do
        expect(db).to receive(:add_entry).with(datetime_array[0], datetime_array[1], angler_name, event_name, weight, weight_decimal, weight_oz, bass_type) {false}
        expect(weight_instance.submit).to eq 'ERROR: Submission failed.'
      end
    end

    context 'failed submition verification' do
      it 'returns error message' do
        expect(db).to receive(:add_entry).with(datetime_array[0], datetime_array[1], angler_name, event_name, weight, weight_decimal, weight_oz, bass_type) {true}
        expect(db).to receive(:get_entry).with(datetime_array[0], datetime_array[1], angler_name, event_name, weight, bass_type) {false}
        expect(weight_instance.submit).to eq 'ERROR: Submission validation failed.'
      end
    end
  end

  describe 'validate_angler' do
    context 'successful validation' do
      it 'returns true' do
        expect(weight_instance.validate_angler).to be_truthy
      end
    end

    context 'angler name is blank/empty' do
      it 'returns error message' do
        expect { Weight.new(nil, event_name, weight, bass_type).validate_angler }.to raise_error('ERROR: Angler name is invalid or missing.')
      end
    end
  end

  describe 'validate_event' do
    context 'successful validation' do
      it 'returns true' do
        expect(weight_instance.validate_event).to be_truthy
      end
    end

    context 'event name is blank/empty' do
      it 'returns error message' do
        expect { Weight.new(angler_name, nil, weight, bass_type).validate_event }.to raise_error('ERROR: Event name is invalid or missing.')
      end
    end
  end

  describe 'validate_weight' do
    context 'successful validation' do
      it 'returns true' do
        expect(weight_instance.validate_weight).to be_truthy
      end
    end

    context 'weight is blank/empty' do
      it 'returns error message' do
        expect { Weight.new(angler_name, event_name, nil, bass_type).validate_weight }.to raise_error('ERROR: Weight entry is invalid or missing.')
      end
    end

    context 'weight format is incorrect' do
      it 'returns error message' do
        expect { Weight.new(angler_name, event_name, '2.332', bass_type).validate_weight }.to raise_error('ERROR: Weight format is incorrect. Needs to be in the "lbs-oz" format (eg: 2-14).')
      end
    end

    context 'pounds column exceeds 25lbs' do
      it 'returns error message' do
        expect { Weight.new(angler_name, event_name, '26-9', bass_type).validate_weight }.to raise_error('ERROR: Weight -> lbs section exceeds 25lbs. You are full of shit bitch.')
      end
    end

    context 'oz column exceeds 15oz' do
      it 'returns error message' do
        expect { Weight.new(angler_name, event_name, '4-19', bass_type).validate_weight }.to raise_error('ERROR: Weight -> oz section exceeds 15oz (needs to be below 16). You are fucking dumb!')
      end
    end
  end

  describe 'validate_bass_type' do
    context 'successful validation' do
      it 'returns true' do
        expect(weight_instance.validate_bass_type).to be_truthy
      end
    end

    context 'bass_type is blank/empty' do
      it 'returns error message' do
        expect { Weight.new(angler_name, event_name, weight, nil).validate_bass_type }.to raise_error('Error: Bass species (largemouth/smallmouth) not selected. Please select a species and try again.')
      end
    end

    context 'bass_type is not largemouth or smallmouth' do
      it 'returns error message' do
        expect { Weight.new(angler_name, event_name, weight, 'salmon').validate_bass_type }.to raise_error('Error: Bass species type is invalid.')
      end
    end
  end

  describe 'decimal' do
    it 'returns decimal value of weight format <lbs-oz>' do
      expect(Weight.new(angler_name, event_name, weight, bass_type).decimal).to eq weight_decimal
    end
  end

  describe 'ounces' do
    it 'returns ounces value of weight format <lbs-oz>' do
      expect(Weight.new(angler_name, event_name, weight, bass_type).ounces).to eq weight_oz
    end
  end

  describe 'submit_angler_entry' do
    context 'successful submition' do
      it 'returns true' do
        expect(db).to receive(:add_entry).with(datetime_array[0], datetime_array[1], angler_name, event_name, weight, weight_decimal, weight_oz, bass_type) {true}
        expect(weight_instance.submit_angler_entry).to be_truthy
      end
    end

    context 'failed submition' do
      it 'returns error message' do
        expect(db).to receive(:add_entry).with(datetime_array[0], datetime_array[1], angler_name, event_name, weight, weight_decimal, weight_oz, bass_type) {false}
        expect { weight_instance.submit_angler_entry }.to raise_error('ERROR: Submission failed.')
      end
    end
  end

  describe 'verify_submission' do
    context 'successful verification' do
      it 'returns true' do
        expect(db).to receive(:get_entry).with(datetime_array[0], datetime_array[1], angler_name, event_name, weight, bass_type) {true}
        expect(weight_instance.verify_submission).to be_truthy
      end
    end

    context 'failed submition' do
      it 'returns error message' do
        expect(db).to receive(:get_entry).with(datetime_array[0], datetime_array[1], angler_name, event_name, weight, bass_type) {false}
        expect { weight_instance.verify_submission }.to raise_error('ERROR: Submission validation failed.')
      end
    end
  end
end
