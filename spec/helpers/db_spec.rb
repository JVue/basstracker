require_relative '../../helpers/db'

describe DB do
  let(:db) { DB.new }
  let(:pg_connection_string) { { :hostaddr => Secrets.db_hostaddress, :dbname => Secrets.db_name, :user => Secrets.db_username, :password => Secrets.db_password } }
  let(:pg) { double('pg') }
  let(:response_object) { double('response') }
  let(:angler_name) { 'jason.vue' }
  let(:event_name) { 'b5' }

  before do
    allow(Secrets).to receive(:db_hostaddress)
    allow(Secrets).to receive(:db_name)
    allow(Secrets).to receive(:db_username)
    allow(Secrets).to receive(:db_password)
    allow(PG).to receive(:connect).with(pg_connection_string).and_return(pg)
  end

  describe 'add_entry' do
    let(:pg_input) { "INSERT INTO basstracker (date, time, angler, event, weight, weight_decimal, weight_oz, bass_type) VALUES('11/20/2019', '09:41 AM', 'jason.vue', 'b5', '3-12', '3.75', '60', 'smallmouth')" }
    context 'successful submition' do
      it 'returns true' do
        expect(pg).to receive(:exec).with(pg_input) { response_object }
        expect(response_object).to receive(:result_status).and_return(1)
        expect(db.add_entry('11/20/2019', '09:41 AM', 'jason.vue', 'b5', '3-12', '3.75', 60, 'smallmouth')).to be_truthy
      end
    end

    context 'failed submition' do
      it 'returns false' do
        expect(pg).to receive(:exec).with(pg_input) { response_object }
        expect(response_object).to receive(:result_status).and_return(0)
        expect(db.add_entry('11/20/2019', '09:41 AM', 'jason.vue', 'b5', '3-12', '3.75', 60, 'smallmouth')).to be_falsey
      end
    end
  end

  describe 'get_anglers' do
    let(:pg_input) { "SELECT angler FROM basstracker_anglers" }
    let(:angler_output) { %w[john.doe carson.daily jason.vue chewy.lee cubby.xiong].sort }
    let(:angler_array) { [["john.doe"], ["carson.daily"], ["jason.vue"], ["chewy.lee"], ["cubby.xiong"]] }
    context 'successful submition' do
      it 'returns array' do
        expect(pg).to receive(:exec).with(pg_input) { response_object }
        expect(response_object).to receive(:values) { angler_array }
        expect(db.get_anglers).to eq angler_output
      end
    end
  end

  describe 'add_angler' do
    let(:pg_input) { "INSERT INTO basstracker_anglers (angler) VALUES(\'#{angler_name}\')" }
    context 'successful submition' do
      it 'returns true' do
        expect(pg).to receive(:exec).with(pg_input) { response_object }
        expect(response_object).to receive(:result_status).and_return(1)
        expect(db.add_angler(angler_name)).to be_truthy
      end
    end

    context 'failed submition' do
      it 'returns false' do
        expect(pg).to receive(:exec).with(pg_input) { response_object }
        expect(response_object).to receive(:result_status).and_return(0)
        expect(db.add_angler(angler_name)).to be_falsey
      end
    end
  end

  describe 'remove_angler' do
    let(:pg_input) { "DELETE FROM basstracker_anglers WHERE angler=\'#{angler_name}\'" }
    context 'successful submition' do
      it 'returns true' do
        expect(pg).to receive(:exec).with(pg_input) { response_object }
        expect(response_object).to receive(:result_status).and_return(1)
        expect(db.remove_angler(angler_name)).to be_truthy
      end
    end

    context 'failed submition' do
      it 'returns false' do
        expect(pg).to receive(:exec).with(pg_input) { response_object }
        expect(response_object).to receive(:result_status).and_return(0)
        expect(db.remove_angler(angler_name)).to be_falsey
      end
    end
  end

  describe 'get_events' do
    let(:pg_input) { "SELECT event FROM basstracker_events" }
    let(:event_output) { %w[b5 tournament mlf 3man].sort }
    let(:event_array) { [['b5'], ['tournament'], ['mlf'], ['3man']] }
    context 'successful submition' do
      it 'returns array' do
        expect(pg).to receive(:exec).with(pg_input) { response_object }
        expect(response_object).to receive(:values) { event_array }
        expect(db.get_events).to eq event_output
      end
    end
  end

  describe 'add_event' do
    let(:pg_input) { "INSERT INTO basstracker_events (event) VALUES(\'#{event_name}\')" }
    context 'successful submition' do
      it 'returns true' do
        expect(pg).to receive(:exec).with(pg_input) { response_object }
        expect(response_object).to receive(:result_status).and_return(1)
        expect(db.add_event(event_name)).to be_truthy
      end
    end

    context 'failed submition' do
      it 'returns false' do
        expect(pg).to receive(:exec).with(pg_input) { response_object }
        expect(response_object).to receive(:result_status).and_return(0)
        expect(db.add_event(event_name)).to be_falsey
      end
    end
  end

  describe 'remove_event' do
    let(:pg_input) { "DELETE FROM basstracker_events WHERE event=\'#{event_name}\'" }
    context 'successful submition' do
      it 'returns true' do
        expect(pg).to receive(:exec).with(pg_input) { response_object }
        expect(response_object).to receive(:result_status).and_return(1)
        expect(db.remove_event(event_name)).to be_truthy
      end
    end

    context 'failed submition' do
      it 'returns false' do
        expect(pg).to receive(:exec).with(pg_input) { response_object }
        expect(response_object).to receive(:result_status).and_return(0)
        expect(db.remove_event(event_name)).to be_falsey
      end
    end
  end

  describe 'get_entry' do
    let(:date) { '08/27/2019' }
    let(:time) { '08:15 AM' }
    let(:weight) { '2-4' }
    let(:bass_type) { 'largemouth' }
    let(:pg_input) { "SELECT * FROM basstracker WHERE date=\'#{date}\' AND time=\'#{time}\' AND angler=\'#{angler_name}\' AND event=\'#{event_name}\' AND weight=\'#{weight}\' AND bass_type=\'#{bass_type}\'" }
    context 'successful submition' do
      it 'returns true' do
        expect(pg).to receive(:exec).with(pg_input) { response_object }
        expect(response_object).to receive(:result_status).and_return(1)
        expect(db.get_entry(time, date, angler_name, event_name, weight, bass_type)).to be_truthy
      end
    end

    context 'failed submition' do
      it 'returns false' do
        expect(pg).to receive(:exec).with(pg_input) { response_object }
        expect(response_object).to receive(:result_status).and_return(0)
        expect(db.get_entry(time, date, angler_name, event_name, weight, bass_type)).to be_falsey
      end
    end
  end

  describe 'close_db_connection' do
    it 'closes the database connection' do
      expect(pg).to receive(:close)
      expect(db.close_db_connection).to be_nil
    end
  end
end
